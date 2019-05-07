//
//  BaseNavigationCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 20/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

class BaseNavigationCoordinator: BaseCoordinator {
    
    internal var navigationController: UINavigationController
    
    // MARK: - Initialization
    override init(window: UIWindow?,
                  messagePresenter: MessagePresenterType?) {
        self.navigationController = UINavigationController()
        super.init(window: window, messagePresenter: messagePresenter)
        window?.rootViewController = navigationController
        navigationController.interactivePopGestureRecognizer?.delegate = nil
    }
    
    init(window: UIWindow?,
         navigationController: UINavigationController,
         messagePresenter: MessagePresenterType?) {
        self.navigationController = navigationController
        super.init(window: window, messagePresenter: messagePresenter)
        window?.rootViewController = navigationController
        navigationController.interactivePopGestureRecognizer?.delegate = nil
    }
}
