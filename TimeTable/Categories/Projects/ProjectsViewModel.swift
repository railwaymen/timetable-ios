//
//  ProjectsViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 02/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

protocol ProjectsViewModelOutput: class {
    func setUpView()
    func updateView()
    func showCollectionView()
    func showErrorView()
    func setActivityIndicator(isAnimating: Bool)
    func screenOrientationDidChange()
}

protocol ProjectsViewModelType: class {
    func viewDidLoad()
    func numberOfItems() -> Int
    func item(at index: IndexPath) -> ProjectRecordDecoder?
    func configure(_ view: ErrorViewable)
    func refreshData(completion: @escaping () -> Void)
    func profileButtonTapped()
}

class ProjectsViewModel {
    private weak var userInterface: ProjectsViewModelOutput?
    private weak var coordinator: ProjectsCoordinatorType?
    private let apiClient: ApiClientProjectsType
    private let errorHandler: ErrorHandlerType
    private weak var notificationCenter: NotificationCenterType?
    private let smoothLoadingManager: SmoothLoadingManagerType
    
    private var projects: [ProjectRecordDecoder] = []
    private var errorViewModel: ErrorViewModelParentType?
    
    // MARK: - Initialization
    init(
        userInterface: ProjectsViewModelOutput?,
        coordinator: ProjectsCoordinatorType?,
        apiClient: ApiClientProjectsType,
        errorHandler: ErrorHandlerType,
        notificationCenter: NotificationCenterType
    ) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.errorHandler = errorHandler
        self.notificationCenter = notificationCenter
        self.smoothLoadingManager = SmoothLoadingManager { [weak userInterface] isAnimating in
            userInterface?.setActivityIndicator(isAnimating: isAnimating)
        }
        
        self.setUpNotifications()
    }
    
    deinit {
        self.notificationCenter?.removeObserver(self)
    }
    
    // MARK: - Notifcations
    @objc func screenOrientationDidChange() {
        self.userInterface?.screenOrientationDidChange()
    }
}

// MARK: - ProjectsViewModelType
extension ProjectsViewModel: ProjectsViewModelType {
    func viewDidLoad() {
        self.userInterface?.setUpView()
        self.fetchProjects()
    }
    
    func numberOfItems() -> Int {
        return self.projects.count
    }
    
    func item(at index: IndexPath) -> ProjectRecordDecoder? {
        return self.projects[safeIndex: index.row]
    }
    
    func configure(_ view: ErrorViewable) {
        let viewModel = ErrorViewModel(userInterface: view, localizedError: UIError.genericError) { [weak self] in
            self?.fetchProjects()
        }
        view.configure(viewModel: viewModel)
        self.errorViewModel = viewModel
    }
    
    func refreshData(completion: @escaping () -> Void) {
        self.apiClient.fetchAllProjects { [weak self] result in
            completion()
            switch result {
            case let .success(projectRecords):
                self?.handleFetchSuccess(projectRecords: projectRecords)
            case let .failure(error):
                self?.handleFetch(error: error)
            }
        }
    }
    
    func profileButtonTapped() {
        self.coordinator?.showProfile()
    }
}
 
// MARK: - Private
extension ProjectsViewModel {
    private func setUpNotifications() {
        self.notificationCenter?.addObserver(
            self,
            selector: #selector(self.screenOrientationDidChange),
            name: UIDevice.orientationDidChangeNotification,
            object: nil)
    }
    
    private func fetchProjects() {
        self.smoothLoadingManager.showActivityIndicatorWithDelay()
        self.apiClient.fetchAllProjects { [weak self] result in
            self?.smoothLoadingManager.hideActivityIndicator()
            switch result {
            case let .success(projectRecords):
                self?.handleFetchSuccess(projectRecords: projectRecords)
            case let .failure(error):
                self?.handleFetch(error: error)
            }
        }
    }
    
    private func handleFetch(error: Error) {
        if let error = error as? ApiClientError {
            if error.type == .unauthorized {
                self.errorHandler.throwing(error: error)
            } else {
                self.errorViewModel?.update(localizedError: error)
            }
        } else {
            self.errorViewModel?.update(localizedError: UIError.genericError)
            self.errorHandler.throwing(error: error)
        }
        self.userInterface?.showErrorView()
    }
    
    private func handleFetchSuccess(projectRecords: [ProjectRecordDecoder]) {
        self.projects = projectRecords
        self.userInterface?.updateView()
        self.userInterface?.showCollectionView()
    }
}
