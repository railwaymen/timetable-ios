//
//  TaskHistoryCoordinator.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 17/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

protocol TaskHistoryCoordinatorType: class {
    func openWithSafari(url: URL)
    func dismiss()
}

class TaskHistoryCoordinator: NavigationCoordinator {
    private let dependencyContainer: DependencyContainerType
    private weak var parentViewController: UIViewController?
    private let taskForm: TaskForm
    
    // MARK: - Initialization
    init(
        dependencyContainer: DependencyContainerType,
        parentViewController: UIViewController,
        taskForm: TaskForm
    ) {
        self.dependencyContainer = dependencyContainer
        self.parentViewController = parentViewController
        self.taskForm = taskForm
        super.init(window: dependencyContainer.window)
    }
    
    // MARK: - Overridden
    override func start(finishHandler: FinishHandlerType?) {
        super.start(finishHandler: finishHandler)
        self.runMainFlow()
    }
}

// MARK: - TaskHistoryCoordinatorType
extension TaskHistoryCoordinator: TaskHistoryCoordinatorType {
    func openWithSafari(url: URL) {
        self.dependencyContainer.application?.open(url)
    }
    
    func dismiss() {
        self.navigationController.dismiss(animated: true) { [weak self] in
            self?.finish()
        }
    }
}

// MARK: - Private
extension TaskHistoryCoordinator {
    private func runMainFlow() {
        guard let apiClient = self.dependencyContainer.apiClient else { return assertionFailure("API client mustn't be nil") }
        guard let controller: TaskHistoryViewController = self.dependencyContainer.storyboardsManager.controller(storyboard: .taskHistory) else { return }
        let viewModel = TaskHistoryViewModel(
            userInterface: controller,
            coordinator: self,
            apiClient: apiClient,
            errorHandler: self.dependencyContainer.errorHandler,
            taskForm: self.taskForm)
        controller.configure(viewModel: viewModel)
        self.navigationController.setViewControllers([controller], animated: false)
        self.parentViewController?.present(self.navigationController, animated: true)
    }
}
