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
    func save(taskForm: TaskFormType, completion: @escaping SaveTaskCompletion)
    func getPredefinedTimeBounds(forTaskForm form: TaskForm, lastTask: TaskForm?) -> (startDate: Date, endDate: Date)
    func getPredefinedDay(forTaskForm form: TaskForm) -> Date
    func pickEndTime(ofLastTask lastTask: TaskForm?) -> Date?
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
    
    func save(taskForm: TaskFormType, completion: @escaping SaveTaskCompletion) {
        do {
            let task = try self.validate(taskForm: taskForm)
            if let workTimeIdentifier = taskForm.workTimeIdentifier {
                self.apiClient.updateWorkTime(identifier: workTimeIdentifier, parameters: task, completion: completion)
            } else {
                self.apiClient.addWorkTime(parameters: task, completion: completion)
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func getPredefinedTimeBounds(forTaskForm task: TaskForm, lastTask: TaskForm?) -> (startDate: Date, endDate: Date) {
        let startDate: Date
        let endDate: Date
        switch task.projectType {
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
    
    func getPredefinedDay(forTaskForm task: TaskForm) -> Date {
        return task.day ?? Date()
    }
    
    func pickEndTime(ofLastTask lastTask: TaskForm?) -> Date? {
        guard let lastTaskEndAt = lastTask?.endsAt, self.calendar.isDateInToday(lastTaskEndAt) else { return nil }
        return lastTaskEndAt
    }
}

// MARK: - Private
extension WorkTimeContentProvider {
    private func validate(taskForm: TaskFormType) throws -> Task {
        do {
            return try taskForm.generateEncodableRepresentation()
        } catch let error as TaskForm.ValidationError {
            switch error {
            case .projectIsNil:
                throw UIError.cannotBeEmpty(.projectTextField)
            case .urlIsNil:
                throw UIError.cannotBeEmpty(.taskUrlTextField)
            case .bodyIsEmpty:
                throw UIError.cannotBeEmpty(.taskNameTextField)
            case .dayIsNil:
                throw UIError.cannotBeEmpty(.dayTextField)
            case .startsAtIsNil:
                throw UIError.cannotBeEmpty(.startsAtTextField)
            case .endsAtIsNil:
                throw UIError.cannotBeEmpty(.endsAtTextField)
            case .timeRangeIsIncorrect:
                throw UIError.timeGreaterThan
            case .internalError:
                throw UIError.genericError
            }
        } catch {
            assertionFailure()
            throw UIError.genericError
        }
    }
}
