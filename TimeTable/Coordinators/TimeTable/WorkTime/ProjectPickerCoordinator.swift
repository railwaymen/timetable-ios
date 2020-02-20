//
//  ProjectPickerCoordinator.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 07/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

protocol ProjectPickerCoordinatorType: class {
    func finishFlow(project: ProjectDecoder?)
}

class ProjectPickerCoordinator: NavigationCoordinator {
    typealias CustomFinishHandlerType = (ProjectDecoder?) -> Void
    private let dependencyContainer: DependencyContainerType
    private weak var parentViewController: UIViewController?
    private let projects: [ProjectDecoder]
    
    private var customFinishHandler: CustomFinishHandlerType?
    
    // MARK: - Initialization
    init(
        dependencyContainer: DependencyContainerType,
        parentViewController: UIViewController,
        projects: [ProjectDecoder]
    ) {
        self.dependencyContainer = dependencyContainer
        self.parentViewController = parentViewController
        self.projects = projects
        super.init(window: dependencyContainer.window)
    }
    
    // MARK: - Overridden
    override func start(finishHandler: FinishHandlerType?) {
        super.start(finishHandler: finishHandler)
        self.runMainFlow()
    }
    
    override func finish() {
        self.customFinishHandler?(nil)
        super.finish()
    }
    
    // MARK: - Internal
    func start(finishHandler: @escaping CustomFinishHandlerType) {
        self.customFinishHandler = finishHandler
        self.start()
    }
    
    func finish(project: ProjectDecoder?) {
        self.customFinishHandler?(project)
        super.finish()
    }
}

// MARK: - ProjectPickerCoordinatorType
extension ProjectPickerCoordinator: ProjectPickerCoordinatorType {
    func finishFlow(project: ProjectDecoder?) {
        self.navigationController.dismiss(animated: true) { [weak self] in
            self?.finish(project: project)
        }
    }
}

// MARK: - Private
extension ProjectPickerCoordinator {
    private func runMainFlow() {
        let controller = ProjectPickerViewController()
        let viewModel = ProjectPickerViewModel(
            userInterface: controller,
            coordinator: self,
            notificationCenter: self.dependencyContainer.notificationCenter,
            projects: self.projects)
        controller.configure(viewModel: viewModel)
        self.navigationController.setViewControllers([controller], animated: false)
        self.parentViewController?.present(self.navigationController, animated: true)
    }
}
