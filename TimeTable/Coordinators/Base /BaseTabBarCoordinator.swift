//
//  BaseTabBarCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 20/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

class BaseTabBarCoordinator: BaseCoordinator {
    
    internal let tabBarController: UITabBarController
    
    // MARK: - Initialization
    override init(window: UIWindow?,
                  messagePresenter: MessagePresenterType?) {
        self.tabBarController = UITabBarController()
        super.init(window: window, messagePresenter: messagePresenter)
    }
    
    // MARK: - Overriden
    override func start(finishCompletion: (() -> Void)?) {
        self.tabBarController.viewControllers = self.children.compactMap { ($0 as? BaseTabBarCoordinatorType)?.root }
        window?.rootViewController = tabBarController
        super.start(finishCompletion: finishCompletion)
    }
    
    override func finish() {
        self.children.forEach { self.removeChildCoordinator(child: $0) }
        super.finish()
    }
}
