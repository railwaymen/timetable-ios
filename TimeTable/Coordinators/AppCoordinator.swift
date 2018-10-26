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
        let controller: ServerSettingsViewController? = storyboardsManager.controller(storyboard: .serverSettings, controllerIdentifier: .initial)
        guard let serverSettingsViewController = controller else { return }
        let viewModel = ServerSettingsViewModel(userInterface: serverSettingsViewController, errorHandler: errorHandler)
        controller?.configure(viewModel: viewModel, notificationCenter: NotificationCenter.default)
        navigationController.setViewControllers([serverSettingsViewController], animated: false)
    }
    
    private func present(error: Error) {
        
        if let uiError = error as? UIError {
            let alert = UIAlertController(title: "", message: uiError.localizedDescription, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { [unowned alert] _ in
                alert.dismiss(animated: true)
            }
            alert.addAction(action)
            window?.rootViewController?.present(alert, animated: true)
        }
    }
}
