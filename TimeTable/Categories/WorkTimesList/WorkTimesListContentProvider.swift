//
//  WorkTimesListContentProvider.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 29/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

protocol WorkTimesListContentProviderType: class {
    func fetchWorkTimesData(for date: Date?, completion: @escaping (Result<([DailyWorkTime], MatchingFullTimeDecoder), Error>) -> Void)
    func delete(workTime: WorkTimeDecoder, completion: @escaping (Result<Void, Error>) -> Void)
}

class WorkTimesListContentProvider {
    private let apiClient: WorkTimesListApiClientType
    private let accessService: AccessServiceUserIDType
    private let calendar: CalendarType
    private let dispatchGroupFactory: DispatchGroupFactoryType
    
    // MARK: - Initialization
    init(apiClient: WorkTimesListApiClientType,
         accessService: AccessServiceUserIDType,
         calendar: CalendarType = Calendar.autoupdatingCurrent,
         dispatchGroupFactory: DispatchGroupFactoryType) {
        self.apiClient = apiClient
        self.accessService = accessService
        self.calendar = calendar
        self.dispatchGroupFactory = dispatchGroupFactory
    }
}
 
// MARK: - WorkTimesListContentProviderType
extension WorkTimesListContentProvider: WorkTimesListContentProviderType {
    func fetchWorkTimesData(for date: Date?, completion: @escaping (Result<([DailyWorkTime], MatchingFullTimeDecoder), Error>) -> Void) {
        var dailyWorkTimes: [DailyWorkTime] = []
        var matchingFullTime: MatchingFullTimeDecoder?
        var fetchError: Error?
        let dispatchGroup = dispatchGroupFactory.createDispatchGroup()
        
        dispatchGroup.enter()
        self.fetchWorkTimes(date: date) { result in
            switch result {
            case .success(let workTimes):
                dailyWorkTimes = workTimes
            case .failure(let error):
                fetchError = error
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        self.fetchMatchingFullTime(date: date) { result in
            switch result {
            case .success(let time):
                matchingFullTime = time
            case .failure(let error):
                fetchError = error
            }
            dispatchGroup.leave()
        }
        
        // Done
        dispatchGroup.notify(qos: .userInitiated, queue: .main) {
            if let error = fetchError {
                completion(.failure(error))
            } else if let matchingFullTime = matchingFullTime {
                completion(.success((dailyWorkTimes, matchingFullTime)))
            } else {
                completion(.failure(ApiClientError(type: .invalidResponse)))
            }
        }
    }
    
    func delete(workTime: WorkTimeDecoder, completion: @escaping (Result<Void, Error>) -> Void) {
        self.apiClient.deleteWorkTime(identifier: workTime.identifier, completion: completion)
    }
}

// MARK: - Private
extension WorkTimesListContentProvider {
    private func fetchWorkTimes(date: Date?, completion: @escaping (Result<[DailyWorkTime], Error>) -> Void) {
        let dates = self.getStartAndEndDate(for: date)
        let parameters = WorkTimesParameters(fromDate: dates.startOfMonth, toDate: dates.endOfMonth, projectIdentifier: nil)
        self.apiClient.fetchWorkTimes(parameters: parameters) { result in
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
    
    private func fetchMatchingFullTime(date: Date?, completion: @escaping (Result<MatchingFullTimeDecoder, Error>) -> Void) {
        let userIdentifier = self.accessService.getLastLoggedInUserIdentifier()
        let parameters = MatchingFullTimeEncoder(date: date, userIdentifier: userIdentifier)
        self.apiClient.fetchMatchingFullTime(parameters: parameters, completion: completion)
    }
    
    private func getStartAndEndDate(for date: Date?) -> (startOfMonth: Date?, endOfMonth: Date?) {
        guard let date = date else { return (nil, nil) }
        var startOfMonthComponents = self.calendar.dateComponents([.year, .month], from: date)
        startOfMonthComponents.day = 1
        startOfMonthComponents.timeZone = TimeZone(secondsFromGMT: 0)
        let startOfMonth = self.calendar.date(from: startOfMonthComponents)
        guard let startDate = startOfMonth else { return (startOfMonth, nil) }
        let endOfMonthComponents = DateComponents(month: 1)
        let endOfMonth = self.calendar.date(byAdding: endOfMonthComponents, to: startDate)
        return (startOfMonth, endOfMonth)
    }
}
