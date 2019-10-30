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
        var image: UIImage = #imageLiteral(resourceName: "profile_icon")
        if #available(iOS 13, *), let sfSymbol = UIImage(systemName: "person.fill") {
            image = sfSymbol
        }
        self.tabBarItem = UITabBarItem(title: "tabbar.title.profile".localized,
                                       image: image,
                                       selectedImage: nil)
        super.init(window: dependencyContainer.window, messagePresenter: dependencyContainer.messagePresenter)
        self.root.tabBarItem = tabBarItem
    }

    // MARK: - CoordinatorType
    override func start(finishCompletion: (() -> Void)?) {
        self.runMainFlow()
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.navigationBar.prefersLargeTitles = true
        super.start(finishCompletion: finishCompletion)
    }
    
    // MARK: - Private
    private func runMainFlow() {
        guard let apiClient = dependencyContainer.apiClient,
            let accessService = dependencyContainer.accessService else { return assertionFailure("Api client or access service is nil") }
        let controller: ProfileViewControllerable? = dependencyContainer.storyboardsManager.controller(storyboard: .profile)
        let viewModel = ProfileViewModel(userInterface: controller,
                                             coordinator: self,
                                             apiClient: apiClient,
                                             accessService: accessService,
                                             coreDataStack: dependencyContainer.coreDataStack,
                                             errorHandler: dependencyContainer.errorHandler)
        controller?.configure(viewModel: viewModel)
        guard let profileViewController = controller else { return }
        navigationController.pushViewController(profileViewController, animated: false)
    }
}

// MARK: - ProfileCoordinatorDelegate
extension ProfileCoordinator: ProfileCoordinatorDelegate {
    func userProfileDidLogoutUser() {
        finishCompletion?()
    }
}
