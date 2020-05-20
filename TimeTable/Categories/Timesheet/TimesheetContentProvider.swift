//
//  TimesheetContentProvider.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 29/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
import Restler

typealias TimesheetFetchResult = Result<([DailyWorkTime], MatchingFullTimeDecoder), Error>
typealias TimesheetFetchCompletion = (TimesheetFetchResult) -> Void

typealias TimesheetDeleteResult = Result<Void, Error>
typealias TimesheetDeleteCompletion = (TimesheetDeleteResult) -> Void

typealias TimesheetFetchRequiredDataResult = Result<TimesheetViewModel.RequiredData, Error>
typealias TimesheetFetchRequiredDataCompletion = (TimesheetFetchRequiredDataResult) -> Void

protocol TimesheetContentProviderType: class {
    func fetchRequiredData(for date: Date?, completion: @escaping TimesheetFetchRequiredDataCompletion)
    func fetchWorkTimesData(for date: Date?, completion: @escaping TimesheetFetchCompletion)
    func delete(workTime: WorkTimeDecoder, completion: @escaping TimesheetDeleteCompletion)
}

class TimesheetContentProvider {
    private let apiClient: TimesheetApiClientType
    private let accessService: AccessServiceUserIDType
    private let calendar: CalendarType
    private let dispatchGroupFactory: DispatchGroupFactoryType
    
    private var fetchListTask: RestlerTaskType? {
        willSet {
            self.fetchListTask?.cancel()
        }
    }
    
    // MARK: - Initialization
    init(
        apiClient: TimesheetApiClientType,
        accessService: AccessServiceUserIDType,
        calendar: CalendarType = Calendar.autoupdatingCurrent,
        dispatchGroupFactory: DispatchGroupFactoryType
    ) {
        self.apiClient = apiClient
        self.accessService = accessService
        self.calendar = calendar
        self.dispatchGroupFactory = dispatchGroupFactory
    }
}
 
// MARK: - TimesheetContentProviderType
extension TimesheetContentProvider: TimesheetContentProviderType {
    func fetchRequiredData(for date: Date?, completion: @escaping TimesheetFetchRequiredDataCompletion) {
        let group = self.dispatchGroupFactory.createDispatchGroup()
        
        var projects: [SimpleProjectRecordDecoder] = []
        var projectsError: Error?
        var dailyWorkTimes: [DailyWorkTime] = []
        var matchingFullTime: MatchingFullTimeDecoder?
        var workTimesFetchError: Error?
        
        group.enter()
        _ = self.apiClient.fetchSimpleListOfProjects { result in
            switch result {
            case let .success(response):
                projects = response
            case let .failure(error):
                projectsError = error
            }
            group.leave()
        }
        
        group.enter()
        self.fetchWorkTimesData(for: date) { result in
            switch result {
            case let .success(response):
                dailyWorkTimes = response.0
                matchingFullTime = response.1
            case let .failure(error):
                workTimesFetchError = error
            }
            group.leave()
        }
        
        group.notify(qos: .userInteractive, queue: .main) {
            if let error = projectsError ?? workTimesFetchError {
                completion(.failure(error))
            } else if let matchingFullTime = matchingFullTime {
                let requiredData = TimesheetViewModel.RequiredData(
                    dailyWorkTimes: dailyWorkTimes,
                    matchingFulltime: matchingFullTime,
                    simpleProjects: projects)
                completion(.success(requiredData))
            } else {
                completion(.failure(ApiClientError(type: .invalidResponse)))
            }
        }
    }
    
    func fetchWorkTimesData(for date: Date?, completion: @escaping TimesheetFetchCompletion) {
        var dailyWorkTimes: [DailyWorkTime] = []
        var matchingFullTime: MatchingFullTimeDecoder?
        var fetchError: Error?
        let dispatchGroup = self.dispatchGroupFactory.createDispatchGroup()
        
        dispatchGroup.enter()
        self.fetchWorkTimes(date: date) { result in
            switch result {
            case let .success(workTimes):
                dailyWorkTimes = workTimes
            case let .failure(error):
                fetchError = error
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        self.fetchMatchingFullTime(date: date) { result in
            switch result {
            case let .success(time):
                matchingFullTime = time
            case let .failure(error):
                fetchError = error
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(qos: .userInteractive, queue: .main) {
            if let error = fetchError {
                completion(.failure(error))
            } else if let matchingFullTime = matchingFullTime {
                completion(.success((dailyWorkTimes, matchingFullTime)))
            } else {
                completion(.failure(ApiClientError(type: .invalidResponse)))
            }
        }
    }
    
    func delete(workTime: WorkTimeDecoder, completion: @escaping TimesheetDeleteCompletion) {
        self.apiClient.deleteWorkTime(id: workTime.id, completion: completion)
    }
}

// MARK: - Private
extension TimesheetContentProvider {
    private func fetchWorkTimes(date: Date?, completion: @escaping (Result<[DailyWorkTime], Error>) -> Void) {
        let dates = self.getStartAndEndDate(for: date)
        let parameters = WorkTimesParameters(fromDate: dates.startOfMonth, toDate: dates.endOfMonth, projectID: nil)
        self.fetchListTask = self.apiClient.fetchWorkTimes(parameters: parameters) { result in
            switch result {
            case let .success(workTimes):
                let dailyWorkTimesArray = workTimes.reduce(into: [DailyWorkTime]()) { (array, workTime) in
                    if let index = array.firstIndex(where: { $0.day == workTime.date }) {
                        array[index].workTimes.append(workTime)
                    } else {
                        let new = DailyWorkTime(day: workTime.date, workTimes: [workTime])
                        array.append(new)
                    }
                }.sorted(by: { $0.day > $1.day })
                completion(.success(dailyWorkTimesArray))
            case let .failure(error):
                if case let .request(type, _) = error as? Restler.Error, type == .requestCancelled {
                    completion(.success([]))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func fetchMatchingFullTime(date: Date?, completion: @escaping (Result<MatchingFullTimeDecoder, Error>) -> Void) {
        guard let unwrappedDate = date,
            let userID = self.accessService.getLastLoggedInUserID() else {
                completion(.failure(ApiClientError(type: .invalidParameters)))
                return
        }
        let parameters = MatchingFullTimeEncoder(date: unwrappedDate, userID: userID)
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
