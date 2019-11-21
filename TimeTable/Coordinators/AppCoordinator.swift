//
//  AppCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 25/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

protocol ParentCoordinator {
    func present(error: Error)
}

class AppCoordinator: Coordinator {
    private var dependencyContainer: DependencyContainerType
    private let parentErrorHandler: ErrorHandlerType
    
    private var errorHandler: ErrorHandlerType {
        return self.parentErrorHandler.catchingError(action: { [weak self] error in
            self?.present(error: error)
        })
    }
    
    // MARK: - Initialization
    init(dependencyContainer: DependencyContainerType) {
        self.dependencyContainer = dependencyContainer
        self.parentErrorHandler = dependencyContainer.errorHandler
        super.init(window: dependencyContainer.window)
        self.dependencyContainer.errorHandler = self.errorHandler
    }

    // MARK: - Overridden
    override func start(finishHandler: (() -> Void)?) {
        super.start(finishHandler: finishHandler)
        self.runAuthenticationFlow()
    }
}

// MARK: - ParentCoordinator
extension AppCoordinator: ParentCoordinator {
    func present(error: Error) {
        if let uiError = error as? UIError {
            self.dependencyContainer.messagePresenter?.presentAlertController(withMessage: uiError.localizedDescription)
        } else if let apiError = error as? ApiClientError {
            self.dependencyContainer.messagePresenter?.presentAlertController(withMessage: apiError.type.localizedDescription)
        }
    }
}

// MARK: - Private
extension AppCoordinator {
    private func runAuthenticationFlow() {
        let coordinator = AuthenticationCoordinator(dependencyContainer: self.dependencyContainer)
        self.add(child: coordinator)
        coordinator.start { [weak self, weak coordinator] (configuration, apiClient) in
            self?.remove(child: coordinator)
            self?.runMainFlow(configuration: configuration, apiClient: apiClient)
        }
    }
    
    private func runMainFlow(configuration: ServerConfiguration, apiClient: ApiClientType) {
        let accessService = self.dependencyContainer.accessServiceBuilder(configuration, self.dependencyContainer.encoder, self.dependencyContainer.decoder)
        self.dependencyContainer.apiClient = apiClient
        self.dependencyContainer.accessService = accessService
        let coordinator = TimeTableTabCoordinator(dependencyContainer: self.dependencyContainer)
        self.add(child: coordinator)
        coordinator.start { [weak self, weak coordinator] in
            self?.remove(child: coordinator)
            self?.runAuthenticationFlow()
        }
    }
}
