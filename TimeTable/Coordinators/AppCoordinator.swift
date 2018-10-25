//
//  AppCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 25/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    //MARK: - Initialization
    override init(window: UIWindow?) {
        self.navigationController = UINavigationController()
        window?.rootViewController = navigationController
        super.init(window: window)
        navigationController.interactivePopGestureRecognizer?.delegate = nil
    }
    
    //MARK: - CoordinatorType
    func start() {
        defer {
            super.start()
        }
        self.runMainFlow()
    }
    
    //MARK: - Private
    private func runMainFlow() {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? ViewController else {
            return
        }
        navigationController.setViewControllers([controller], animated: false)
    }
}
