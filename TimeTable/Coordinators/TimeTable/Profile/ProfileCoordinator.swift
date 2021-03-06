//
//  UserCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 20/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

protocol ProfileCoordinatorParentType: class {
    func childDidRequestToFinish()
}

protocol ProfileCoordinatorDelegate: class {
    func userProfileDidLogoutUser()
    func viewDidRequestToShowAccountingPeriods()
    func viewDidRequestToFinish()
}

class ProfileCoordinator: NavigationCoordinator {
    private let dependencyContainer: DependencyContainerType
    private weak var parent: ProfileCoordinatorParentType?
    private weak var parentViewController: UIViewController?
    
    // MARK: - Initialization
    init(
        dependencyContainer: DependencyContainerType,
        parent: ProfileCoordinatorParentType?,
        parentViewController: UIViewController?
    ) {
        self.dependencyContainer = dependencyContainer
        self.parent = parent
        self.parentViewController = parentViewController
        super.init(window: dependencyContainer.window)
    }
    
    deinit {
        self.navigationController.setViewControllers([], animated: false)
    }

    // MARK: - Overridden
    override func start(finishHandler: (() -> Void)?) {
        super.start(finishHandler: finishHandler)
        self.runMainFlow()
        self.navigationController.setNavigationBarHidden(false, animated: false)
        self.navigationController.navigationBar.tintColor = .tint
    }
}

// MARK: - ProfileCoordinatorDelegate
extension ProfileCoordinator: ProfileCoordinatorDelegate {
    func userProfileDidLogoutUser() {
        self.parent?.childDidRequestToFinish()
    }
    
    func viewDidRequestToShowAccountingPeriods() {
        let coordinator = AccountingPeriodsCoordinator(
            navigationController: self.navigationController,
            dependencyContainer: self.dependencyContainer)
        self.add(child: coordinator)
        coordinator.start { [weak self, weak coordinator] in
            self?.remove(child: coordinator)
        }
    }
    
    func viewDidRequestToFinish() {
        self.navigationController.dismiss(animated: true) { [weak self] in
            self?.finish()
        }
    }
}

// MARK: - Private
extension ProfileCoordinator {
    private func runMainFlow() {
        guard let apiClient = self.dependencyContainer.requireApiClient() else { return }
        do {
            let controller = try self.dependencyContainer.viewControllerBuilder.profile()
            let contentProvider = ProfileContentProvider(
                apiClient: apiClient,
                accessService: self.dependencyContainer.accessService,
                errorHandler: self.dependencyContainer.errorHandler)
            let viewModel = ProfileViewModel(
                userInterface: controller,
                coordinator: self,
                contentProvider: contentProvider,
                errorHandler: self.dependencyContainer.errorHandler)
            controller.configure(viewModel: viewModel)
            self.navigationController.setViewControllers([controller], animated: false)
            self.parentViewController?.present(self.navigationController, animated: true)
        } catch {
            self.dependencyContainer.errorHandler.stopInDebug("\(error)")
        }
    }
}
