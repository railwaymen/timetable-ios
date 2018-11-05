//
//  ServerConfigurationCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 05/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

protocol ServerConfigurationCoordinatorDelagete: class {
    func serverConfigurationDidFinish(with serverConfiguration: ServerConfiguration)
}

class ServerConfigurationCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    private let storyboardsManager: StoryboardsManagerType
    private let errorHandler: ErrorHandlerType
    private let serverConfigurationManager: ServerConfigurationManagerType
    var customfinishCompletion: ((ServerConfiguration) -> Void)?
    
    // MARK: - Initialization
    init(navigationController: UINavigationController, storyboardsManager: StoryboardsManagerType,
         errorHandler: ErrorHandlerType, serverConfigurationManager: ServerConfigurationManagerType) {
        self.navigationController = navigationController
        self.storyboardsManager = storyboardsManager
        self.errorHandler = errorHandler
        self.serverConfigurationManager = serverConfigurationManager
        super.init(window: nil)
        self.navigationController.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController.navigationItem.leftItemsSupplementBackButton = true
        navigationController.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - CoordinatorType
    func start(finishCompletion: ((ServerConfiguration) -> Void)?) {
        runMainFlow()
        self.customfinishCompletion = finishCompletion
    }
    
    // MARL: - Private
    private func runMainFlow() {
        let controller: ServerConfigurationViewControlleralbe? = storyboardsManager.controller(storyboard: .serverConfiguration, controllerIdentifier: .initial)
        guard let serverSettingsViewController = controller else { return }
        let viewModel = ServerConfigurationViewModel(userInterface: serverSettingsViewController,
                                                     coordinator: self,
                                                     serverConfigurationManager: serverConfigurationManager,
                                                     errorHandler: errorHandler)
        serverSettingsViewController.configure(viewModel: viewModel, notificationCenter: NotificationCenter.default)
        navigationController.setViewControllers([serverSettingsViewController], animated: false)
    }
}

extension ServerConfigurationCoordinator: ServerConfigurationCoordinatorDelagete {
    func serverConfigurationDidFinish(with serverConfiguration: ServerConfiguration) {
        customfinishCompletion?(serverConfiguration)
    }
}
