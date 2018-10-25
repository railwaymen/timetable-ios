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
    private var storyboardsManager: StoryboardsManagerType
    
    private let parentErrorHandler: ErrorHandlerType
    
    private var errorHandler: ErrorHandlerType {
        return parentErrorHandler.catchingError(action: { error in
            //Handle error
            print(error)
        })
    }
    
    // MARK: - Initialization
    init(window: UIWindow?, storyboardsManager: StoryboardsManagerType, errorHandler: ErrorHandlerType) {
        self.navigationController = UINavigationController()
        window?.rootViewController = navigationController
        self.storyboardsManager = storyboardsManager
        self.parentErrorHandler = errorHandler
        super.init(window: window)
        navigationController.interactivePopGestureRecognizer?.delegate = nil
    }
    
    // MARK: - CoordinatorType
    func start() {
        defer {
            super.start()
        }
        self.runMainFlow()
    }
    
    // MARK: - Private
    private func runMainFlow() {
        guard let controller: ViewController = storyboardsManager.controller(storyboard: .main, controllerIdentifier: .initial) else { return }
        navigationController.setViewControllers([controller], animated: false)
    }
}
