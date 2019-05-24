//
//  UserCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 20/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

protocol UserCoordinatorDelegate: class {
   func userProfileDidLogoutUser()
}

class UserCoordinator: BaseNavigationCoordinator, BaseTabBarCoordinatorType {
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
        self.tabBarItem = UITabBarItem(title: "tabbar.title.profile".localized,
                                       image: #imageLiteral(resourceName: "profile_icon"),
                                       selectedImage: nil)
        super.init(window: window, messagePresenter: messagePresenter)
        self.root.tabBarItem = tabBarItem
    }

    // MARK: - CoordinatorType
    override func start(finishCompletion: (() -> Void)?) {
        self.runMainFlow()
        navigationController.setNavigationBarHidden(true, animated: false)
        super.start(finishCompletion: finishCompletion)
    }
    
    // MARK: - Private
    private func runMainFlow() {
        let controller: UserProfileViewControllerable? = storyboardsManager.controller(storyboard: .user, controllerIdentifier: .initial)
        let viewModel = UserProfileViewModel(userInterface: controller,
                                             coordinator: self,
                                             apiClient: apiClient,
                                             accessService: accessService,
                                             coreDataStack: coreDataStack,
                                             errorHandler: errorHandler)
        controller?.configure(viewModel: viewModel)
        if let controller = controller {
            navigationController.pushViewController(controller, animated: false)
        }
    }
}

// MARK: - UserCoordinatorDelegate
extension UserCoordinator: UserCoordinatorDelegate {
    func userProfileDidLogoutUser() {
        finishCompletion?()
    }
}
