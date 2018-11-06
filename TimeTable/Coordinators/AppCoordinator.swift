//
//  AppCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 25/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

class AppCoordinator: BaseCoordinator {
    
    var navigationController: UINavigationController
    private var storyboardsManager: StoryboardsManagerType
    private var serverConfigurationManager: ServerConfigurationManagerType
    private let parentErrorHandler: ErrorHandlerType
    
    private var errorHandler: ErrorHandlerType {
        return parentErrorHandler.catchingError(action: { [weak self] error in
            self?.present(error: error)
        })
    }
    
    // MARK: - Initialization
    init(window: UIWindow?, storyboardsManager: StoryboardsManagerType,
         errorHandler: ErrorHandlerType, serverConfigurationManager: ServerConfigurationManagerType) {
        self.navigationController = UINavigationController()
        window?.rootViewController = navigationController
        self.storyboardsManager = storyboardsManager
        self.parentErrorHandler = errorHandler
        self.serverConfigurationManager = serverConfigurationManager
        super.init(window: window)
        self.navigationController.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - CoordinatorType
    func start() {
        defer {
            super.start()
        }
        if let configuration = serverConfigurationManager.getOldConfiguration(), configuration.shouldRemeberHost {
            self.runAuthenticationFlow(configuration: configuration)
        } else {
            self.runServerConfigurationFlow()
        }
    }
    
    // MARK: - Private
    private func runServerConfigurationFlow() {
        let coordinator = ServerConfigurationCoordinator(navigationController: navigationController,
                                                         storyboardsManager: storyboardsManager,
                                                         errorHandler: errorHandler,
                                                         serverConfigurationManager: serverConfigurationManager)
        addChildCoordinator(child: coordinator)
        coordinator.start { [weak self, weak coordinator] configuration in
            if let childCoordinator = coordinator {
                self?.removeChildCoordinator(child: childCoordinator)
                self?.runAuthenticationFlow(configuration: configuration)
            }
        }
    }
    
    private func runAuthenticationFlow(configuration: ServerConfiguration) {
        let coordinator = AuthenticationCoordinator(navigationController: navigationController,
                                                    storyboardsManager: storyboardsManager,
                                                    errorHandler: errorHandler)
        addChildCoordinator(child: coordinator)
        coordinator.start { [weak self, weak coordinator] (state) in
            if let childCoordinator = coordinator {
                self?.removeChildCoordinator(child: childCoordinator)
            }
            switch state {
            case .changeAddress:
                self?.runServerConfigurationFlow()
            case .loggedInCorrectly:
                break
            }
        }
    }
}
