//
//  AppCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 25/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

class AppCoordinator: BaseCoordinator {
    
    private var dependencyContainer: DependencyContainerType
    private let parentErrorHandler: ErrorHandlerType
    
    private var errorHandler: ErrorHandlerType {
        return parentErrorHandler.catchingError(action: { [weak self] error in
            self?.present(error: error)
        })
    }
    
    // MARK: - Initialization
    init(dependencyContainer: DependencyContainerType) {
        self.dependencyContainer = dependencyContainer
        self.parentErrorHandler = dependencyContainer.errorHandler
        super.init(window: dependencyContainer.window, messagePresenter: dependencyContainer.messagePresenter)
        self.dependencyContainer.errorHandler = errorHandler
    }

    // MARK: - CoordinatorType
    func start() {
        super.start()
        runAuthenticationFlow()
    }

    // MARK: - Private
    private func runAuthenticationFlow() {
        let coordinator = AuthenticationCoordinator(dependencyContainer: dependencyContainer)
        addChildCoordinator(child: coordinator)
        coordinator.start { [weak self, weak coordinator] (configuration, apiClient) in
            self?.runMainFlow(configuration: configuration, apiClient: apiClient)
            self?.removeChildCoordinator(child: coordinator)
        }
    }
    
    private func runMainFlow(configuration: ServerConfiguration, apiClient: ApiClientType) {
        let accessService = dependencyContainer.accessServiceBuilder(configuration, dependencyContainer.encoder, dependencyContainer.decoder)
        dependencyContainer.apiClient = apiClient
        dependencyContainer.accessService = accessService
        let coordinator = TimeTableTabCoordinator(dependencyContainer: dependencyContainer)
        addChildCoordinator(child: coordinator)
        coordinator.start(finishCompletion: { [weak self, weak coordinator] in
            self?.removeChildCoordinator(child: coordinator)
            self?.runAuthenticationFlow()
        })
    }
}
