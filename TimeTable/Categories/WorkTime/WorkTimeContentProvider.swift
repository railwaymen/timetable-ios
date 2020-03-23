//
//  WorkTimeContentProvider.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 19/02/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation
import Restler

typealias FetchDataResult = Result<(projects: [SimpleProjectRecordDecoder], tags: [ProjectTag]), Error>
typealias FetchDataCompletion = (FetchDataResult) -> Void

typealias SaveTaskResult = Result<Void, Error>
typealias SaveTaskCompletion = (SaveTaskResult) -> Void

protocol WorkTimeContentProviderType: class {
    func fetchData(completion: @escaping FetchDataCompletion)
    func save(taskForm: TaskFormType, completion: @escaping SaveTaskCompletion)
    func saveWithFilling(taskForm: TaskFormType, completion: @escaping SaveTaskCompletion)
    func getPredefinedTimeBounds(forTaskForm form: TaskFormType, lastTask: TaskFormType?) -> (startDate: Date, endDate: Date)
    func getPredefinedDay(forTaskForm form: TaskForm) -> Date
    func pickEndTime(ofLastTask lastTask: TaskFormType?) -> Date?
}

class WorkTimeContentProvider {
    private let apiClient: WorkTimeApiClientType
    private let calendar: CalendarType
    private let dateFactory: DateFactoryType
    private let dispatchGroupFactory: DispatchGroupFactoryType
    private let errorHandler: ErrorHandlerType
    
    private var saveTask: RestlerTaskType? {
        willSet {
            self.saveTask?.cancel()
        }
    }
    
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

// MARK: - WorkTimeContentProviderType
extension WorkTimeContentProvider: WorkTimeContentProviderType {
    func fetchData(completion: @escaping FetchDataCompletion) {
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
    
    func save(taskForm: TaskFormType, completion: @escaping SaveTaskCompletion) {
        do {
            let task = try self.validate(taskForm: taskForm)
            if let workTimeIdentifier = taskForm.workTimeIdentifier {
                self.saveTask = self.apiClient.updateWorkTime(identifier: workTimeIdentifier, parameters: task, completion: completion)
            } else {
                self.saveTask = self.apiClient.addWorkTime(parameters: task, completion: completion)
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func saveWithFilling(taskForm: TaskFormType, completion: @escaping SaveTaskCompletion) {
        do {
            let task = try self.validate(taskForm: taskForm)
            self.saveTask = self.apiClient.addWorkTimeWithFilling(task: task, completion: completion)
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
    
    func getPredefinedDay(forTaskForm task: TaskForm) -> Date {
        return task.day ?? self.currentDate
    }
    
    func pickEndTime(ofLastTask lastTask: TaskFormType?) -> Date? {
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
            self.errorHandler.stopInDebug()
            throw UIError.genericError
        }
    }
}
