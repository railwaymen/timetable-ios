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
            if case .unauthorized = (error as? ApiClientError)?.type {
                self?.dependencyContainer.accessService.closeSession()
                self?.dependencyContainer.apiClient = nil
                (self?.children.last as? TimeTableTabCoordinator)?.finish()
            } else {
                self?.present(error: error)
            }
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
    
    override func openDeepLink(option: DeepLinkOption) {
        #if TEST
        guard case let .testPage(type) = option else { return }
        guard let url = self.dependencyContainer.environmentReader.getURL(forKey: .serverURL) else { return }
        let apiClient = self.dependencyContainer.apiClientFactory.buildAPIClient(
            accessService: self.dependencyContainer.accessService,
            baseURL: url)
        
        do {
            try self.removeAllData()
            switch type {
            case .serverConfiguration, .login:
                self.runAuthenticationFlow()
            default:
                self.runMainFlow(apiClient: apiClient)
            }
            self.children.last?.openDeepLink(option: option)
        } catch {
            self.errorHandler.stopInDebug("Couldn't remove data: \(error)")
        }
        #endif
    }
    
    // MARK: - Internal
    func appDidResume() {
        if self.dependencyContainer.accessService.isSessionOpened {
            guard !self.children.contains(where: { $0 is TabBarCoordinator }) else { return }
            self.children.forEach { $0.finish() }
        } else {
            guard !self.children.contains(where: { $0 is AuthenticationCoordinator }) else { return }
            self.children.forEach { $0.finish() }
        }
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
        coordinator.start { [weak self, weak coordinator] (_, apiClient) in
            self?.remove(child: coordinator)
            self?.runMainFlow(apiClient: apiClient)
        }
    }
    
    private func runMainFlow(apiClient: ApiClientType) {
        self.dependencyContainer.apiClient = apiClient
        let coordinator = TimeTableTabCoordinator(dependencyContainer: self.dependencyContainer)
        self.add(child: coordinator)
        coordinator.start { [weak self, weak coordinator] in
            self?.remove(child: coordinator)
            self?.runAuthenticationFlow()
        }
    }
    
    #if TEST
    private func removeAllData() throws {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        self.dependencyContainer.accessService.closeSession()
        self.dependencyContainer.apiClient = nil
    }
    #endif
}
