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
    func showCollectionView()
    func showErrorView()
    func setActivityIndicator(isHidden: Bool)
}

protocol ProjectsViewModelType: class {
    func numberOfItems() -> Int
    func item(at index: IndexPath) -> Project?
    func viewDidLoad()
    func configure(_ view: ErrorViewable)
}

class ProjectsViewModel {
    
    private weak var userInterface: ProjectsViewModelOutput?
    private let apiClient: ApiClientProjectsType
    private let errorHandler: ErrorHandlerType
    private var projects: [Project]
    
    private var errorViewModel: ErrorViewModelParentType?
    
    // MARK: - Initialization
    init(
        userInterface: ProjectsViewModelOutput?,
        apiClient: ApiClientProjectsType,
        errorHandler: ErrorHandlerType
    ) {
        self.userInterface = userInterface
        self.apiClient = apiClient
        self.errorHandler = errorHandler
        self.projects = []
    }
}

// MARK: - ProjectsViewModelType
extension ProjectsViewModel: ProjectsViewModelType {
    func numberOfItems() -> Int {
        return self.projects.count
    }
    
    func item(at index: IndexPath) -> Project? {
        guard self.projects.count > index.row else { return nil }
        return self.projects[index.row]
    }
    
    func viewDidLoad() {
        self.fetchProjects()
        self.userInterface?.setUpView()
    }
    
    func configure(_ view: ErrorViewable) {
        let viewModel = ErrorViewModel(userInterface: view, error: UIError.genericError) { [weak self] in
            self?.fetchProjects()
        }
        view.configure(viewModel: viewModel)
        self.errorViewModel = viewModel
    }
}
 
// MARK: - Private
extension ProjectsViewModel {
    private func fetchProjects() {
        self.userInterface?.setActivityIndicator(isHidden: false)
        self.apiClient.fetchAllProjects { [weak self] result in
            self?.userInterface?.setActivityIndicator(isHidden: true)
            switch result {
            case .failure(let error):
                self?.handleFetch(error: error)
            case .success(let projectRecords):
                self?.handleFetchSuccess(projectRecords: projectRecords)
            }
        }
    }
    
    private func handleFetch(error: Error) {
        if let error = error as? ApiClientError {
            self.errorViewModel?.update(error: error)
        } else {
            self.errorViewModel?.update(error: UIError.genericError)
            self.errorHandler.throwing(error: error)
        }
        self.userInterface?.showErrorView()
    }
    
    private func handleFetchSuccess(projectRecords: [ProjectRecordDecoder]) {
        self.createProjects(from: projectRecords)
        self.userInterface?.updateView()
        self.userInterface?.showCollectionView()
    }
    
    private func createProjects(from records: [ProjectRecordDecoder]) {        
        self.projects = records.reduce(Set<Project>(), { result, new in
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
