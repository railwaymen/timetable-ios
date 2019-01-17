//
//  UserCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 20/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

class UserCoordinator: BaseNavigationCoordinator, BaseTabBarCordninatorType {
    private let storyboardsManager: StoryboardsManagerType
    
    var root: UIViewController {
        return self.navigationController
    }
    var tabBarItem: UITabBarItem
    
    // MARK: - Initialization
    init(window: UIWindow?, storyboardsManager: StoryboardsManagerType) {
        self.storyboardsManager = storyboardsManager
        self.tabBarItem = UITabBarItem(title: "tabbar.title.profile".localized, image: nil, selectedImage: nil)
        super.init(window: window)
        self.root.tabBarItem = tabBarItem
    }

    // MARK: - CoordinatorType
    func start() {
        self.runMainFlow()
        navigationController.setNavigationBarHidden(true, animated: false)
        super.start()
    }
    
    // MARK: - Private
    private func runMainFlow() {
        let controller: UserProfileViewController? = storyboardsManager.controller(storyboard: .user, controllerIdentifier: .initial)
        if let controller = controller {
            navigationController.pushViewController(controller, animated: false)
        }
    }
}
