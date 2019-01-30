//
//  WorkTimesContentProvider.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 29/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

protocol WorkTimesContentProviderType: class {
    func fetchWorkTimesData(for date: Date?, completion: @escaping (Result<([DailyWorkTime], MatchingFullTimeDecoder?)>) -> Void)
}

class WorkTimesContentProvider: WorkTimesContentProviderType {
    private let apiClient: WorkTimesApiClientType
    private let accessService: AccessServiceUserIDType
    private let calendar: CalendarType
    
    // MARK: - Initialization
    init(apiClient: WorkTimesApiClientType, accessService: AccessServiceUserIDType, calendar: CalendarType = Calendar.autoupdatingCurrent) {
        self.apiClient = apiClient
        self.accessService = accessService
        self.calendar = calendar
    }

    // MARK: - WorkTimesContentProviderType
    func fetchWorkTimesData(for date: Date?, completion: @escaping (Result<([DailyWorkTime], MatchingFullTimeDecoder?)>) -> Void) {
        var dailyWorkTimes: [DailyWorkTime] = []
        var matchingFullTime: MatchingFullTimeDecoder?
        
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 2
        
        // Stage 1
        let workTimesSemaphore = DispatchSemaphore(value: 0)
        let matchingFullTimeSemaphore = DispatchSemaphore(value: 0)
        let workTimesBlockOperation = BlockOperation()
        let matchingFullTimeBlockOperation = BlockOperation()
        
        workTimesBlockOperation.addExecutionBlock { [weak self, weak workTimesBlockOperation, weak matchingFullTimeBlockOperation] in
            guard let blockOperation = workTimesBlockOperation, !blockOperation.isCancelled else { return }
            self?.fetchWorkTimes(date: date, completion: { result in
                switch result {
                case .success(let workTimes):
                    dailyWorkTimes = workTimes
                    workTimesSemaphore.signal()
                case .failure:
                    matchingFullTimeBlockOperation?.cancel()
                    workTimesSemaphore.signal()
                }
            })
            workTimesSemaphore.wait()
        }
        
        matchingFullTimeBlockOperation.addExecutionBlock { [weak self, weak workTimesBlockOperation, weak matchingFullTimeBlockOperation] in
            guard let blockOperation = matchingFullTimeBlockOperation, !blockOperation.isCancelled else { return }
            self?.fetchMatchingFullTime(date: date, completion: { result in
                switch result {
                case .success(let time):
                    matchingFullTime = time
                    matchingFullTimeSemaphore.signal()
                case .failure(let error):
                    print(error)
                    workTimesBlockOperation?.cancel()
                    matchingFullTimeSemaphore.signal()
                }
            })
            matchingFullTimeSemaphore.wait()
        }
        
        // Done
        let doneBlockOperation = BlockOperation()
        
        doneBlockOperation.addExecutionBlock {
            completion(.success((dailyWorkTimes, matchingFullTime)))
        }
        
        doneBlockOperation.addDependency(matchingFullTimeBlockOperation)
        doneBlockOperation.addDependency(workTimesBlockOperation)
        
        operationQueue.addOperation(doneBlockOperation)
        operationQueue.addOperation(workTimesBlockOperation)
        operationQueue.addOperation(matchingFullTimeBlockOperation)
    }
    
    // MARK: - Private
    
    private func fetchWorkTimes(date: Date?, completion: @escaping (Result<[DailyWorkTime]>) -> Void) {
        let dates = getStartAndEndDate(for: date)
        let parameters = WorkTimesParameters(fromDate: dates.startOfMonth, toDate: dates.endOfMonth, projectIdentifier: nil)
        apiClient.fetchWorkTimes(parameters: parameters) { result in
            switch result {
            case .success(let workTimes):
                let dailyWorkTimesArray = workTimes.reduce([DailyWorkTime](), { (array, workTime) in
                    var newArray = array
                    if let dailyWorkTimes = newArray.first(where: { $0.day == workTime.date }) {
                        dailyWorkTimes.workTimes.append(workTime)
                    } else {
                        let new = DailyWorkTime(day: workTime.date, workTimes: [workTime])
                        newArray.append(new)
                    }
                    return newArray
                }).sorted(by: { $0.day > $1.day })
                completion(.success(dailyWorkTimesArray))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchMatchingFullTime(date: Date?, completion: @escaping (Result<MatchingFullTimeDecoder>) -> Void) {
        let userIdentifier = accessService.getLastLoggedInUserIdentifier()
        let parameters = MatchingFullTimeEncoder(date: date, userIdentifier: userIdentifier)
        apiClient.fetchMatchingFullTime(parameters: parameters, completion: completion)
    }
    
    private func getStartAndEndDate(for date: Date?) -> (startOfMonth: Date?, endOfMonth: Date?) {
        guard let date = date else { return (nil, nil) }
        var startOfMonthComponents = calendar.dateComponents([.year, .month], from: date)
        startOfMonthComponents.day = 1
        startOfMonthComponents.timeZone = TimeZone(secondsFromGMT: 0)
        let startOfMonth = calendar.date(from: startOfMonthComponents)
        guard let startDate = startOfMonth else { return (startOfMonth, nil) }
        let endOfMonthComponents = DateComponents(day: -1, hour: 23, minute: 59, second: 59, nanosecond: 59)
        let endOfMonth = calendar.date(byAdding: endOfMonthComponents, to: startDate)
        return (startOfMonth, endOfMonth)
    }
}
