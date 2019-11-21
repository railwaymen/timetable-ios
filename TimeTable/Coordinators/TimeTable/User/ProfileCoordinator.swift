//
//  UserCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 20/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

protocol ProfileCoordinatorDelegate: class {
   func userProfileDidLogoutUser()
}

class ProfileCoordinator: BaseNavigationCoordinator, BaseTabBarCoordinatorType {
    private let dependencyContainer: DependencyContainerType
    
    var root: UIViewController {
        return self.navigationController
    }
    var tabBarItem: UITabBarItem
    
    // MARK: - Initialization
    init(dependencyContainer: DependencyContainerType) {
        self.dependencyContainer = dependencyContainer
        self.tabBarItem = UITabBarItem(title: "tabbar.title.profile".localized,
                                       image: .profile,
                                       selectedImage: nil)
        super.init(window: dependencyContainer.window, messagePresenter: dependencyContainer.messagePresenter)
        self.root.tabBarItem = self.tabBarItem
    }

    // MARK: - Overridden
    override func start(finishCompletion: (() -> Void)?) {
        super.start(finishCompletion: finishCompletion)
        self.runMainFlow()
        self.navigationController.setNavigationBarHidden(false, animated: false)
        self.navigationController.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - ProfileCoordinatorDelegate
extension ProfileCoordinator: ProfileCoordinatorDelegate {
    func userProfileDidLogoutUser() {
        self.finishCompletion?()
    }
}

// MARK: - Private
extension ProfileCoordinator {
    private func runMainFlow() {
        guard let apiClient = self.dependencyContainer.apiClient,
            let accessService = self.dependencyContainer.accessService else { return assertionFailure("Api client or access service is nil") }
        let controller: ProfileViewControllerable? = self.dependencyContainer.storyboardsManager.controller(storyboard: .profile)
        let viewModel = ProfileViewModel(userInterface: controller,
                                         coordinator: self,
                                         apiClient: apiClient,
                                         accessService: accessService,
                                         coreDataStack: self.dependencyContainer.coreDataStack,
                                         errorHandler: self.dependencyContainer.errorHandler)
        controller?.configure(viewModel: viewModel)
        guard let profileViewController = controller else { return }
        self.navigationController.pushViewController(profileViewController, animated: false)
    }
}
