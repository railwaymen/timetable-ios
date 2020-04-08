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
}

class ProfileCoordinator: NavigationCoordinator, TabBarChildCoordinatorType {
    private let dependencyContainer: DependencyContainerType
    private weak var parent: ProfileCoordinatorParentType?
    
    var root: UIViewController {
        return self.navigationController
    }
    var tabBarItem: UITabBarItem
    
    // MARK: - Initialization
    init(
        dependencyContainer: DependencyContainerType,
        parent: ProfileCoordinatorParentType?
    ) {
        self.dependencyContainer = dependencyContainer
        self.parent = parent
        self.tabBarItem = UITabBarItem(
            title: R.string.localizable.tabbarTitleProfile(),
            image: .profile,
            selectedImage: nil)
        super.init(window: dependencyContainer.window)
        self.root.tabBarItem = self.tabBarItem
    }

    // MARK: - Overridden
    override func start(finishHandler: (() -> Void)?) {
        super.start(finishHandler: finishHandler)
        self.runMainFlow()
        self.navigationController.setNavigationBarHidden(false, animated: false)
        self.navigationController.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - ProfileCoordinatorDelegate
extension ProfileCoordinator: ProfileCoordinatorDelegate {
    func userProfileDidLogoutUser() {
        self.parent?.childDidRequestToFinish()
    }
}

// MARK: - Private
extension ProfileCoordinator {
    private func runMainFlow() {
        guard let apiClient = self.dependencyContainer.apiClient else {
            self.dependencyContainer.errorHandler.stopInDebug("Api client is nil")
            return
        }
        do {
            let controller = try self.dependencyContainer.viewControllerBuilder.profile()
            let viewModel = ProfileViewModel(
                userInterface: controller,
                coordinator: self,
                apiClient: apiClient,
                accessService: self.dependencyContainer.accessService,
                errorHandler: self.dependencyContainer.errorHandler)
            controller.configure(viewModel: viewModel)
            self.navigationController.pushViewController(controller, animated: false)
        } catch {
            self.dependencyContainer.errorHandler.stopInDebug("\(error)")
        }
    }
}
