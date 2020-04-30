//
//  NewVacationCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 30/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

protocol NewVacationCoordinatorDelegate: class {
    func finishFlow()
}

class NewVacationCoordinator: NavigationCoordinator {
    private let dependencyContainer: DependencyContainerType
    private weak var parentViewController: UIViewController?
    
    var root: UIViewController {
        return self.navigationController
    }
    
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
    
    deinit {
        self.navigationController.setViewControllers([], animated: false)
    }
    
    // MARK: - Overridden
    override func start(finishHandler: (() -> Void)?) {
        super.start(finishHandler: finishHandler)
        self.runMainFlow()
    }
}

// MARK: - NewVacationCoordinatorDelegate
extension NewVacationCoordinator: NewVacationCoordinatorDelegate {
    func finishFlow() {
        self.navigationController.dismiss(animated: true) { [weak self] in
            self?.finish()
        }
    }
}

// MARK: - Private
extension NewVacationCoordinator {
    private func runMainFlow() {
        guard let apiClient = self.dependencyContainer.apiClient else {
            self.dependencyContainer.errorHandler.stopInDebug("Api client is nil")
            return
        }
        do {
            let controller = try self.dependencyContainer.viewControllerBuilder.newVacation()
            let viewModel = NewVacationViewModel(
                userInterface: controller,
                apiClient: apiClient,
                errorHandler: self.dependencyContainer.errorHandler,
                coordinator: self)
            controller.configure(viewModel: viewModel)
            self.navigationController.setViewControllers([controller], animated: false)
            self.parentViewController?.present(self.navigationController, animated: true)
        } catch {
            self.dependencyContainer.errorHandler.stopInDebug("\(error)")
        }
    }
}
