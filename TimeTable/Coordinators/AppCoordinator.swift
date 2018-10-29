//
//  AppCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 25/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

protocol ServerConfigurationCoordinatorDelagete: class {
    func serverConfigurationDidFinish(with serverConfiguration: ServerConfiguration)
}

class AppCoordinator: BaseCoordinator {
    
    var navigationController: UINavigationController
    private var storyboardsManager: StoryboardsManagerType
    
    private let parentErrorHandler: ErrorHandlerType
    
    private var errorHandler: ErrorHandlerType {
        return parentErrorHandler.catchingError(action: { [weak self] error in
            self?.present(error: error)
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
        navigationController.setNavigationBarHidden(true, animated: false)
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
        let controller: ServerConfigurationViewController? = storyboardsManager.controller(storyboard: .serverConfiguration, controllerIdentifier: .initial)
        guard let serverSettingsViewController = controller else { return }
        let viewModel = ServerConfigurationViewModel(userInterface: serverSettingsViewController, coordinator: self, errorHandler: errorHandler)
        controller?.configure(viewModel: viewModel, notificationCenter: NotificationCenter.default)
        navigationController.setViewControllers([serverSettingsViewController], animated: false)
    }
}

extension AppCoordinator: ServerConfigurationCoordinatorDelagete {
    func serverConfigurationDidFinish(with serverConfiguration: ServerConfiguration) {
        
    }
}
