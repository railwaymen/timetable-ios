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
    private let storyboardsManager: StoryboardsManagerType
    private let apiClient: ApiClientUsersType
    private let accessService: AccessServiceUserIDType
    private let coreDataStack: CoreDataStackUserType
    private let errorHandler: ErrorHandlerType
    
    var root: UIViewController {
        return self.navigationController
    }
    var tabBarItem: UITabBarItem
    
    // MARK: - Initialization
    init(window: UIWindow?,
         messagePresenter: MessagePresenterType?,
         storyboardsManager: StoryboardsManagerType,
         apiClient: ApiClientUsersType,
         accessService: AccessServiceUserIDType,
         coreDataStack: CoreDataStackUserType,
         errorHandler: ErrorHandlerType) {
        self.storyboardsManager = storyboardsManager
        self.apiClient = apiClient
        self.accessService = accessService
        self.coreDataStack = coreDataStack
        self.errorHandler = errorHandler
        var image: UIImage = #imageLiteral(resourceName: "profile_icon")
        if #available(iOS 13, *), let sfSymbol = UIImage(systemName: "person.fill") {
            image = sfSymbol
        }
        self.tabBarItem = UITabBarItem(title: "tabbar.title.profile".localized,
                                       image: image,
                                       selectedImage: nil)
        super.init(window: window, messagePresenter: messagePresenter)
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
        let controller: ProfileViewControllerable? = storyboardsManager.controller(storyboard: .profile, controllerIdentifier: .initial)
        let viewModel = ProfileViewModel(userInterface: controller,
                                             coordinator: self,
                                             apiClient: apiClient,
                                             accessService: accessService,
                                             coreDataStack: coreDataStack,
                                             errorHandler: errorHandler)
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
