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

class ProjectPickerCoordinator: BaseNavigationCoordinator {
    typealias FinishHandlerType = (ProjectDecoder?) -> Void
    private let dependencyContainer: DependencyContainerType
    private weak var parentViewController: UIViewController?
    private let projects: [ProjectDecoder]
    
    private var customFinishHandler: FinishHandlerType?
    
    // MARK: - Initialization
    init(dependencyContainer: DependencyContainerType,
         parentViewController: UIViewController,
         projects: [ProjectDecoder]) {
        self.dependencyContainer = dependencyContainer
        self.parentViewController = parentViewController
        self.projects = projects
        super.init(window: dependencyContainer.window, messagePresenter: dependencyContainer.messagePresenter)
    }
    
    // MARK: - Overridden
    override func start(finishCompletion: (() -> Void)?) {
        super.start(finishCompletion: finishCompletion)
        runMainFlow()
    }
    
    override func finish() {
        customFinishHandler?(nil)
        super.finish()
    }
    
    // MARK: - Internal
    func start(finishHandler: @escaping FinishHandlerType) {
        customFinishHandler = finishHandler
        self.start()
    }
    
    func finish(project: ProjectDecoder?) {
        customFinishHandler?(project)
        super.finish()
    }
    
    // MARK: - Private
    private func runMainFlow() {
        let controller = ProjectPickerViewController()
        let viewModel = ProjectPickerViewModel(userInterface: controller,
                                               coordinator: self,
                                               notificationCenter: dependencyContainer.notificationCenter,
                                               projects: projects)
        controller.configure(viewModel: viewModel)
        navigationController.setViewControllers([controller], animated: false)
        parentViewController?.present(navigationController, animated: true)
    }
}

// MARK: - ProjectPickerCoordinatorType
extension ProjectPickerCoordinator: ProjectPickerCoordinatorType {
    func finishFlow(project: ProjectDecoder?) {
        navigationController.dismiss(animated: true)
        finish(project: project)
    }
}
