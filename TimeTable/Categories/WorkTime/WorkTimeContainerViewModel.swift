//
//  WorkTimeContainerViewModel.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 23/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol WorkTimeContainerContentType: class {
    func containerDidUpdate(projects: [SimpleProjectRecordDecoder], tags: [ProjectTag])
}

protocol WorkTimeContainerViewModelOutput: class {
    func setUp(withTitle title: String)
    func showForm()
    func showError()
    func hideAllContainerViews()
    func setActivityIndicator(isAnimating: Bool)
}

protocol WorkTimeContainerViewModelType: class {
    func viewDidLoad()
    func configure(_ viewController: WorkTimeViewControllerable)
    func configure(_ view: ErrorViewable)
    func closeButtonTapped()
}

class WorkTimeContainerViewModel {
    private weak var userInterface: WorkTimeContainerViewModelOutput?
    private weak var coordinator: WorkTimeCoordinatorType?
    private let contentProvider: WorkTimeContainerContentProviderType
    private let errorHandler: ErrorHandlerType
    private let flowType: WorkTimeViewModel.FlowType
    
    private weak var contentDelegate: WorkTimeContainerContentType?
    private weak var errorDelegate: ErrorViewModelParentType?
    
    // MARK: - Initialization
    init(
        userInterface: WorkTimeContainerViewModelOutput?,
        coordinator: WorkTimeCoordinatorType?,
        contentProvider: WorkTimeContainerContentProviderType,
        errorHandler: ErrorHandlerType,
        flowType: WorkTimeViewModel.FlowType
    ) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.contentProvider = contentProvider
        self.errorHandler = errorHandler
        self.flowType = flowType
    }
}

// MARK: - WorkTimeContainerViewModelType
extension WorkTimeContainerViewModel: WorkTimeContainerViewModelType {
    func viewDidLoad() {
        self.userInterface?.setUp(withTitle: self.flowType.viewTitle)
        self.userInterface?.hideAllContainerViews()
        self.fetchData()
    }
    
    func configure(_ viewController: WorkTimeViewControllerable) {
        self.contentDelegate = self.coordinator?.configure(contentViewController: viewController)
    }
    
    func configure(_ view: ErrorViewable) {
        self.errorDelegate = self.coordinator?.configure(errorView: view) { [weak self] in
            self?.fetchData()
        }
    }
    
    func closeButtonTapped() {
        self.coordinator?.dismissView(isTaskChanged: false)
    }
}

// MARK: - Private
extension WorkTimeContainerViewModel {
    private func fetchData() {
        self.userInterface?.setActivityIndicator(isAnimating: true)
        self.contentProvider.fetchData { [weak self] result in
            self?.userInterface?.setActivityIndicator(isAnimating: false)
            switch result {
            case let .success((projects, tags)):
                self?.contentDelegate?.containerDidUpdate(
                    projects: projects,
                    tags: tags.filter { $0 != .default })
                self?.userInterface?.showForm()
            case let .failure(error):
                self?.errorHandler.throwing(error: error)
                self?.userInterface?.showError()
            }
        }
    }
}
