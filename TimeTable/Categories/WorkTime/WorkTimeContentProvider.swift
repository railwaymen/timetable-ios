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
}

class WorkTimeContentProvider {
    private let apiClient: WorkTimeApiClientType
    
    // MARK: - Initialization
    init(
        apiClient: WorkTimeApiClientType
    ) {
        self.apiClient = apiClient
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
