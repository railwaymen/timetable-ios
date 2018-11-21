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
    override init(window: UIWindow?) {
        self.tabBarController = UITabBarController()
        super.init(window: window)
    }
    
    // MARK: - Overriden
    func start() {
        window?.rootViewController = tabBarController
        super.start()
    }
    
    override func start(finishCompletion: (() -> Void)?) {
        window?.rootViewController = tabBarController
        super.start(finishCompletion: finishCompletion)
    }
}
