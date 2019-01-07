//
//  ProjectsViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 02/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

protocol ProjectsViewModelOutput: class {
    func setUpView()
    func updateView()
}

protocol ProjectsViewModelType: class {
    func numberOfItems() -> Int
    func item(at index: IndexPath) -> Project
    func viewDidLoad()
}

class ProjectsViewModel: ProjectsViewModelType {
    
    private weak var userInterface: ProjectsViewModelOutput?
    private let apiClient: ApiClientProjectsType
    private let errorHandler: ErrorHandlerType
    private var projects: [Project]
    
    // MARK: - Initialization
    init(userInterface: ProjectsViewModelOutput?, apiClient: ApiClientProjectsType, errorHandler: ErrorHandlerType) {
        self.userInterface = userInterface
        self.apiClient = apiClient
        self.errorHandler = errorHandler
        self.projects = []
    }
    
    // MARK: - ProjectsViewModelType
    func numberOfItems() -> Int {
        return projects.count
    }
    
    func item(at index: IndexPath) -> Project {
        return projects[index.row]
    }
    
    func viewDidLoad() {
        fetchProjects()
        userInterface?.setUpView()
    }
    
    // MARK: - Private
    private func fetchProjects() {
        apiClient.fetchAllProjects { [weak self] result in
            switch result {
            case .failure(let error):
                self?.errorHandler.throwing(error: error)
            case .success(let projectRecords):
                self?.projects = self?.createProjects(from: projectRecords) ?? []
                self?.userInterface?.updateView()
            }
        }
    }
    
    private func createProjects(from records: [ProjectRecordDecoder]) -> [Project] {
        return records.reduce(Set<Project>(), { result, new in
            var newResult = result
            if let project = newResult.first(where: { $0.identifier == new.projectIdentifier }), let newUser = new.user {
                project.users.append(Project.User(decoder: newUser))
                project.users.sort(by: { $0.name > $1.name })
            } else {
                newResult.insert(Project(decoder: new))
            }
            return newResult
        }).sorted(by: { $0.name > $1.name })
    }
}
