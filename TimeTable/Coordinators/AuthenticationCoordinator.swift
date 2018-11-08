//
//  AuthenticationCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 30/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

protocol LoginCoordinatorDelegate: class {
    func loginDidFinish(with state: AuthenticationCoordinator.State)
}

class AuthenticationCoordinator: BaseCoordinator {
    
    var navigationController: UINavigationController
    private let storyboardsManager: StoryboardsManagerType
    private let apiClient: ApiClientSessionType
    private let errorHandler: ErrorHandlerType
    private let coreDataStack: CoreDataStackUserType
    
    var customFinishCompletion: ((State) -> Void)?
    
    enum State {
        case changeAddress
        case loggedInCorrectly
    }
    
    // MARK: - Initialization
    init(navigationController: UINavigationController, storyboardsManager: StoryboardsManagerType,
         apiClient: ApiClientSessionType, errorHandler: ErrorHandlerType,
         coreDataStack: CoreDataStackUserType) {
        self.navigationController = navigationController
        self.storyboardsManager = storyboardsManager
        self.apiClient = apiClient
        self.errorHandler = errorHandler
        self.coreDataStack = coreDataStack
        super.init(window: nil)
        self.navigationController.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController.navigationItem.leftItemsSupplementBackButton = true
    }

    // MARK: - CoordinatorType
    
    func start(finishCompletion: ((State) -> Void)?) {
        self.customFinishCompletion = finishCompletion
        runMainFlow()
        super.start()
    }
    
    func finish(with state: AuthenticationCoordinator.State) {
        customFinishCompletion?(state)
        super.finish()
    }
    
    // MARL: - Private
    private func runMainFlow() {
        let controller: LoginViewControllerable? = storyboardsManager.controller(storyboard: .login, controllerIdentifier: .initial)
        guard let loginViewController = controller else { return }
        let contentProvider = LoginContentProvider(apiClient: apiClient, coreDataStack: coreDataStack)
        let viewModel = LoginViewModel(userInterface: loginViewController, coordinator: self, contentProvider: contentProvider, errorHandler: errorHandler)
        loginViewController.configure(notificationCenter: NotificationCenter.default, viewModel: viewModel)
        navigationController.pushViewController(loginViewController, animated: true)
    }
}

extension AuthenticationCoordinator: LoginCoordinatorDelegate {
    func loginDidFinish(with state: AuthenticationCoordinator.State) {
        finish(with: state)
    }
}
