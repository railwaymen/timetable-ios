//
//  WorkTimeViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 09/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

protocol WorkTimeViewModelOutput: class {
    func setUp(currentProjectName: String)
    func dismissView()
    func reloadProjectPicker()
}

protocol WorkTimeViewModelType: class {
    func viewDidLoad()
    func viewRequestedForNumberOfProjects() -> Int
    func viewRequestedForProjectTitle(atRow row: Int) -> String?
    func viewRequestedToFinish()
    func viewRequestedForProjectView()
    func taskNameDidChange(value: String?)
    func taskURLDidChange(value: String?)
    func viewRequestedForFromDateView()
    func viewRequestedForToDateView()
    func viewRequesetdToSave()
}

class WorkTimeViewModel: WorkTimeViewModelType {
    private weak var userInterface: WorkTimeViewModelOutput?
    private let apiClient: ApiClientProjectsType
    private let errorHandler: ErrorHandlerType
    private var projects: [ProjectDecoder]
    private var task: Task
    
    struct Task {
        var project: ProjectType
        var title: String
        var url: URL?
        
        enum ProjectType {
            case none
            case some(ProjectDecoder)
            
            var title: String {
                switch self {
                case .none:
                    return "element.button.select_project".localized
                case .some(let project):
                    return project.name
                }
            }
        }
    }
    
    // MARK: - Initialization
    init(userInterface: WorkTimeViewModelOutput?, apiClient: ApiClientProjectsType, errorHandler: ErrorHandlerType) {
        self.userInterface = userInterface
        self.apiClient = apiClient
        self.errorHandler = errorHandler
        self.projects = []
        self.task = Task(project: .none, title: "", url: nil)
    }
    
    // MARK: - WorkTimeViewModelType
    func viewDidLoad() {
        userInterface?.setUp(currentProjectName: task.project.title)
        fetchProjectList()
    }
    
    func viewRequestedForNumberOfProjects() -> Int {
        return projects.count
    }
    
    func viewRequestedForProjectTitle(atRow row: Int) -> String? {
        return projects.count > row ? projects[row].name : nil
    }
    
    func viewRequestedToFinish() {
        userInterface?.dismissView()
    }
    
    func viewRequestedForProjectView() {
        
    }
    
    func taskNameDidChange(value: String?) {
        guard let title = value else { return }
        task.title = title
    }
    
    func taskURLDidChange(value: String?) {
        guard let stringURL = value, let url = URL(string: stringURL) else { return }
        task.url = url
    }
    
    func viewRequestedForFromDateView() {
        
    }
    
    func viewRequestedForToDateView() {
        
    }
    
    func viewRequesetdToSave() {
        
    }
    
    // MARK: - Private
    func fetchProjectList() {
        apiClient.fetchSimpleListOfProjects { [weak self] result in
            switch result {
            case .success(let projects):
                self?.projects = projects
                self?.userInterface?.reloadProjectPicker()
            case .failure(let error):
                self?.errorHandler.throwing(error: error)
            }
        }
    }
}
