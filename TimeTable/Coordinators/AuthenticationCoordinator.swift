//
//  AuthenticationCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 30/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

protocol LoginCoordinatorDelegate: class {
    func loginDidfinish()
}

class AuthenticationCoordinator: BaseCoordinator {
    
    var navigationController: UINavigationController
    private let storyboardsManager: StoryboardsManagerType
    private let errorHandler: ErrorHandlerType

    // MARK: - Initialization
    init(navigationController: UINavigationController, storyboardsManager: StoryboardsManagerType, errorHandler: ErrorHandlerType) {
        self.navigationController = navigationController
        self.storyboardsManager = storyboardsManager
        self.errorHandler = errorHandler
        super.init(window: nil)
        self.navigationController.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController.navigationItem.leftItemsSupplementBackButton = true
        navigationController.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - CoordinatorType
    override func start(finishCompletion: (() -> Void)?) {
        defer {
            super.start(finishCompletion: finishCompletion)
        }
        runMainFlow()
    }
    
    // MARL: - Private
    private func runMainFlow() {
        let controller: LoginViewControllerable? = storyboardsManager.controller(storyboard: .login, controllerIdentifier: .initial)
        guard let loginViewController = controller else { return }
        let viewModel = LoginViewModel(userInterface: loginViewController, coordinator: self)
        loginViewController.configure(notificationCenter: NotificationCenter.default, viewModel: viewModel)
        navigationController.pushViewController(loginViewController, animated: true)
    }
}

extension AuthenticationCoordinator: LoginCoordinatorDelegate {
    func loginDidfinish() {
        finishCompletion?()
    }
}
