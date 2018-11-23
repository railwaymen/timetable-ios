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

class AuthenticationCoordinator: BaseNavigationCoordinator {
    
    private let storyboardsManager: StoryboardsManagerType
    private let apiClient: ApiClientSessionType
    private let accessService: AccessServiceLoginType
    private let errorHandler: ErrorHandlerType
    private let coreDataStack: CoreDataStackUserType
    
    var customFinishCompletion: ((State) -> Void)?
    
    enum State {
        case changeAddress
        case loggedInCorrectly(SessionDecoder)
    }
    
    // MARK: - Initialization
    init(navigationController: UINavigationController, storyboardsManager: StoryboardsManagerType, accessService: AccessServiceLoginType,
         apiClient: ApiClientSessionType, errorHandler: ErrorHandlerType, coreDataStack: CoreDataStackUserType) {
        self.storyboardsManager = storyboardsManager
        self.accessService = accessService
        self.apiClient = apiClient
        self.errorHandler = errorHandler
        self.coreDataStack = coreDataStack
        super.init(navigationController: navigationController)
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
        let contentProvider = LoginContentProvider(apiClient: apiClient, coreDataStack: coreDataStack, accessService: accessService)
        let viewModel = LoginViewModel(userInterface: loginViewController, coordinator: self,
                                       accessService: accessService, contentProvider: contentProvider, errorHandler: errorHandler)
        loginViewController.configure(notificationCenter: NotificationCenter.default, viewModel: viewModel)
        navigationController.pushViewController(loginViewController, animated: true)
    }
}

extension AuthenticationCoordinator: LoginCoordinatorDelegate {
    func loginDidFinish(with state: AuthenticationCoordinator.State) {
        finish(with: state)
    }
}

extension AuthenticationCoordinator.State: Equatable {
    static func == (lhs: AuthenticationCoordinator.State, rhs: AuthenticationCoordinator.State) -> Bool {
        switch (lhs, rhs) {
        case (.changeAddress, .changeAddress):
            return true
        case (.loggedInCorrectly(let lhsSessionDecoder), .loggedInCorrectly(let rhsSessionDecoder)):
            return lhsSessionDecoder == rhsSessionDecoder
        default:
            return false
        }
    }
}
