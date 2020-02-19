//
//  WorkTimeContentProvider.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 19/02/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

typealias FetchSimpleProjectsListResult = Result<(projects: [ProjectDecoder], tags: [ProjectTag]), Error>
typealias FetchSimpleProjectsListCompletion = (FetchSimpleProjectsListResult) -> Void

typealias SaveTaskResult = Result<Void, Error>
typealias SaveTaskCompletion = (SaveTaskResult) -> Void

protocol WorkTimeContentProviderType: class {
    func fetchSimpleProjectsList(completion: @escaping FetchSimpleProjectsListCompletion)
    func save(task: Task, completion: @escaping SaveTaskCompletion)
    func getDefaultTime(forTask task: Task, lastTask: Task?) -> (startDate: Date, endDate: Date)
    func getDefaultDay(forTask task: Task) -> Date
    func pickEndTime(ofLastTask lastTask: Task?) -> Date?
}

class WorkTimeContentProvider {
    private let apiClient: WorkTimeApiClientType
    private let calendar: CalendarType
    
    // MARK: - Initialization
    init(
        apiClient: WorkTimeApiClientType,
        calendar: CalendarType
    ) {
        self.apiClient = apiClient
        self.calendar = calendar
    }
}

// MARK: - WorkTimeContentProviderType
extension WorkTimeContentProvider: WorkTimeContentProviderType {
    func fetchSimpleProjectsList(completion: @escaping FetchSimpleProjectsListCompletion) {
        self.apiClient.fetchSimpleListOfProjects { result in
            switch result {
            case let .success(decoder):
                let projects = decoder.projects.filter { $0.isActive ?? false }
                let tags = decoder.tags.filter { $0 != .default }
                completion(.success((projects, tags)))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func save(task: Task, completion: @escaping SaveTaskCompletion) {
        do {
            try self.validate(task: task)
            if let workTimeIdentifier = task.workTimeIdentifier {
                self.apiClient.updateWorkTime(identifier: workTimeIdentifier, parameters: task, completion: completion)
            } else {
                self.apiClient.addWorkTime(parameters: task, completion: completion)
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func getDefaultTime(forTask task: Task, lastTask: Task?) -> (startDate: Date, endDate: Date) {
        let startDate: Date
        let endDate: Date
        switch task.type {
        case let .fullDay(timeInterval):
            startDate = self.calendar.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
            endDate = startDate.addingTimeInterval(timeInterval)
        case let .lunch(timeInterval):
            startDate = task.startsAt ?? Date().roundedToFiveMinutes()
            endDate = startDate.addingTimeInterval(timeInterval)
        case .standard, .none:
            startDate = self.pickEndTime(ofLastTask: lastTask) ?? task.startsAt ?? Date().roundedToFiveMinutes()
            endDate = task.endsAt ?? startDate
        }
        return (startDate, endDate)
    }
    
    func getDefaultDay(forTask task: Task) -> Date {
        return task.day ?? Date()
    }
    
    func pickEndTime(ofLastTask lastTask: Task?) -> Date? {
        guard let lastTaskEndAt = lastTask?.endsAt, self.calendar.isDateInToday(lastTaskEndAt) else { return nil }
        return lastTaskEndAt
    }
}

// MARK: - Private
extension WorkTimeContentProvider {
    private func validate(task: Task) throws {
        do {
            try task.validate()
        } catch let error as TaskValidationError {
            switch error {
            case .projectIsNil:
                throw UIError.cannotBeEmpty(.projectTextField)
            case .urlIsNil:
                throw UIError.cannotBeEmpty(.taskUrlTextField)
            case .bodyIsEmpty:
                throw UIError.cannotBeEmpty(.taskNameTextField)
            case .startsAtIsNil:
                throw UIError.cannotBeEmpty(.startsAtTextField)
            case .endsAtIsNil:
                throw UIError.cannotBeEmpty(.endsAtTextField)
            case .timeRangeIsIncorrect:
                throw UIError.timeGreaterThan
            }
        } catch {
            assertionFailure()
        }
    }
}
