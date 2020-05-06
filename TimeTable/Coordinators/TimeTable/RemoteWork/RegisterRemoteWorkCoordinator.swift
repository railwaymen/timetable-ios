//
//  RegisterRemoteWorkCoordinator.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 06/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

protocol RegisterRemoteWorkCoordinatorType: class {}

class RegisterRemoteWorkCoordinator: NavigationCoordinator {
    private let dependencyContainer: DependencyContainerType
    private weak var parentViewController: UIViewController?
    
    // MARK: - Initialization
    init(
        dependencyContainer: DependencyContainerType,
        parentViewController: UIViewController
    ) {
        self.dependencyContainer = dependencyContainer
        self.parentViewController = parentViewController
        super.init(window: dependencyContainer.window)
        self.navigationController.setNavigationBarHidden(false, animated: false)
        self.navigationController.navigationBar.prefersLargeTitles = false
        self.navigationController.navigationBar.tintColor = .tint
    }
    
    // MARK: - Overridden
    override func start(finishHandler: (() -> Void)?) {
        super.start(finishHandler: finishHandler)
        self.runMainFlow()
    }
}

// MARK: - RegisterRemoteWorkCoordinatorType
extension RegisterRemoteWorkCoordinator: RegisterRemoteWorkCoordinatorType {}

// MARK: - Private
extension RegisterRemoteWorkCoordinator {
    private func runMainFlow() {
        do {
            let controller = try self.dependencyContainer.viewControllerBuilder.registerRemoteWork()
            let viewModel = RegisterRemoteWorkViewModel(
                userInterface: controller,
                coordinator: self)
            controller.configure(viewModel: viewModel)
            self.navigationController.setViewControllers([controller], animated: false)
            self.parentViewController?.present(self.navigationController, animated: true)
        } catch {
            self.dependencyContainer.errorHandler.stopInDebug("\(error)")
        }
    }
}
