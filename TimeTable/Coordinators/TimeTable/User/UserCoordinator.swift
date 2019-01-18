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

class UserCoordinator: BaseNavigationCoordinator, BaseTabBarCordninatorType {
    private let storyboardsManager: StoryboardsManagerType
    private let accessService: AccessServiceUserIDType
    private let coreDataStack: CoreDataStackUserType
    private let errorHandler: ErrorHandlerType
    
    var root: UIViewController {
        return self.navigationController
    }
    var tabBarItem: UITabBarItem
    
    // MARK: - Initialization
    init(window: UIWindow?, storyboardsManager: StoryboardsManagerType, accessService: AccessServiceUserIDType,
         coreDataStack: CoreDataStackUserType, errorHandler: ErrorHandlerType) {
        self.storyboardsManager = storyboardsManager
        self.accessService = accessService
        self.coreDataStack = coreDataStack
        self.errorHandler = errorHandler
        self.tabBarItem = UITabBarItem(title: "tabbar.title.profile".localized, image: nil, selectedImage: nil)
        super.init(window: window)
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
        let controller: UserProfileViewControlleralbe? = storyboardsManager.controller(storyboard: .user, controllerIdentifier: .initial)
        let viewModel = UserProfileViewModel(userInterface: controller,
                                             coordinator: self,
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
