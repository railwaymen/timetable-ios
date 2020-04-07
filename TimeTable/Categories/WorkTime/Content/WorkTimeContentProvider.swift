//
//  WorkTimeContentProvider.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 19/02/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation
import Restler

typealias WorkTimeFetchDataResult = Result<(projects: [SimpleProjectRecordDecoder], tags: [ProjectTag]), Error>
typealias WorkTimeFetchDataCompletion = (WorkTimeFetchDataResult) -> Void

typealias WorkTimeSaveTaskResult = Result<Void, Error>
typealias WorkTimeSaveTaskCompletion = (WorkTimeSaveTaskResult) -> Void

typealias WorkTimeContentProviderable = WorkTimeContainerContentProviderType & WorkTimeContentProviderType

protocol WorkTimeContainerContentProviderType: class {
    func fetchData(completion: @escaping WorkTimeFetchDataCompletion)
}

protocol WorkTimeContentProviderType: class {
    func save(taskForm: TaskFormType, completion: @escaping WorkTimeSaveTaskCompletion)
    func saveWithFilling(taskForm: TaskFormType, completion: @escaping WorkTimeSaveTaskCompletion)
    func getPredefinedTimeBounds(forTaskForm form: TaskFormType, lastTask: TaskFormType?) -> (startDate: Date, endDate: Date)
    func getPredefinedDay(forTaskForm form: TaskFormType) -> Date
    func getValidationErrors(forTaskForm form: TaskFormType) -> [UIError]
}

class WorkTimeContentProvider {
    private let apiClient: WorkTimeApiClientType
    private let calendar: CalendarType
    private let dateFactory: DateFactoryType
    private let dispatchGroupFactory: DispatchGroupFactoryType
    private let errorHandler: ErrorHandlerType
    
    private var currentDate: Date {
        self.dateFactory.currentDate
    }
    
    // MARK: - Initialization
    init(
        apiClient: WorkTimeApiClientType,
        calendar: CalendarType,
        dateFactory: DateFactoryType,
        dispatchGroupFactory: DispatchGroupFactoryType,
        errorHandler: ErrorHandlerType
    ) {
        self.apiClient = apiClient
        self.calendar = calendar
        self.dateFactory = dateFactory
        self.dispatchGroupFactory = dispatchGroupFactory
        self.errorHandler = errorHandler
    }
}

// MARK: - WorkTimeContainerContentProviderType
extension WorkTimeContentProvider: WorkTimeContainerContentProviderType {
    func fetchData(completion: @escaping WorkTimeFetchDataCompletion) {
        let group = self.dispatchGroupFactory.createDispatchGroup()
        var projectsTask: RestlerTaskType?
        var tagsTask: RestlerTaskType?
        var projectsResponse: [SimpleProjectRecordDecoder]?
        var projectsError: Error?
        var tagsResponse: ProjectTagsDecoder?
        var tagsError: Error?
        
        group.enter()
        projectsTask = self.apiClient.fetchSimpleListOfProjects { result in
            defer { group.leave() }
            guard projectsTask?.state != .canceling else { return }
            switch result {
            case let .success(decoder):
                projectsResponse = decoder.filter { $0.isActive ?? true }
            case let .failure(error):
                projectsError = error
                tagsTask?.cancel()
            }
        }
        
        group.enter()
        tagsTask = self.apiClient.fetchTags { result in
            defer { group.leave() }
            guard tagsTask?.state != .canceling else { return }
            switch result {
            case let .success(decoder):
                tagsResponse = decoder
            case let .failure(error):
                tagsError = error
                projectsTask?.cancel()
            }
        }
        
        group.notify(qos: .userInteractive, queue: .main) { [errorHandler] in
            if let projects = projectsResponse, let tagsDecoder = tagsResponse {
                completion(.success((projects, tagsDecoder.tags)))
            } else if let error = projectsError ?? tagsError {
                completion(.failure(error))
            } else {
                errorHandler.stopInDebug("Expected response from both requests.")
                completion(.failure(AppError.internalError))
            }
        }
    }
}

// MARK: - WorkTimeContentProviderType
extension WorkTimeContentProvider: WorkTimeContentProviderType {
    func save(taskForm: TaskFormType, completion: @escaping WorkTimeSaveTaskCompletion) {
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
    
    func saveWithFilling(taskForm: TaskFormType, completion: @escaping WorkTimeSaveTaskCompletion) {
        do {
            let task = try self.validate(taskForm: taskForm)
            self.apiClient.addWorkTimeWithFilling(task: task, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
    
    func getPredefinedTimeBounds(forTaskForm task: TaskFormType, lastTask: TaskFormType?) -> (startDate: Date, endDate: Date) {
        let startDate: Date
        let endDate: Date
        switch task.projectType {
        case let .fullDay(timeInterval):
            startDate = self.calendar.date(bySettingHour: 9, minute: 0, second: 0, of: self.currentDate) ?? self.currentDate
            endDate = startDate.addingTimeInterval(timeInterval)
        case let .lunch(timeInterval):
            startDate = task.startsAt ?? self.currentDate.roundedToFiveMinutes()
            endDate = startDate.addingTimeInterval(timeInterval)
        case .standard, .none:
            startDate = self.pickEndTime(ofLastTask: lastTask) ?? task.startsAt ?? self.currentDate.roundedToFiveMinutes()
            endDate = task.endsAt ?? startDate
        }
        return (startDate, endDate)
    }
    
    func getPredefinedDay(forTaskForm task: TaskFormType) -> Date {
        return task.day ?? self.currentDate
    }
    
    func getValidationErrors(forTaskForm form: TaskFormType) -> [UIError] {
        return form.validationErrors().map { self.getUIError(validationError: $0) }
    }
}

// MARK: - Private
extension WorkTimeContentProvider {
    private func validate(taskForm: TaskFormType) throws -> Task {
        do {
            return try taskForm.generateEncodableRepresentation()
        } catch let error as TaskForm.ValidationError {
            throw self.getUIError(validationError: error)
        } catch {
            self.errorHandler.stopInDebug("Unexpected error catched")
            throw UIError.genericError
        }
    }
    
    private func getUIError(validationError: TaskForm.ValidationError) -> UIError {
        switch validationError {
        case .projectIsNil:
            return UIError.cannotBeEmpty(.projectTextField)
        case .urlIsNil:
            return UIError.cannotBeEmpty(.taskUrlTextField)
        case .bodyIsEmpty:
            return UIError.cannotBeEmpty(.taskNameTextField)
        case .dayIsNil:
            return UIError.cannotBeEmpty(.dayTextField)
        case .startsAtIsNil:
            return UIError.cannotBeEmpty(.startsAtTextField)
        case .endsAtIsNil:
            return UIError.cannotBeEmpty(.endsAtTextField)
        case .timeRangeIsIncorrect:
            return UIError.timeGreaterThan
        case .internalError:
            self.errorHandler.stopInDebug("TaskForm internal error")
            return UIError.genericError
        }
    }
    
    private func pickEndTime(ofLastTask lastTask: TaskFormType?) -> Date? {
        guard let lastTaskEndAt = lastTask?.endsAt, self.calendar.isDateInToday(lastTaskEndAt) else { return nil }
        return lastTaskEndAt
    }
}
