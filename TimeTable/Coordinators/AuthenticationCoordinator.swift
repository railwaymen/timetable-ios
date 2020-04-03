//
//  AuthenticationCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 05/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit
import KeychainAccess
import CoordinatorsFoundation

protocol ServerConfigurationCoordinatorDelegate: class {
    func serverConfigurationDidFinish(with serverConfiguration: ServerConfiguration)
}

protocol LoginCoordinatorDelegate: class {
    func loginDidFinish(with state: AuthenticationCoordinator.State)
}

class AuthenticationCoordinator: NavigationCoordinator {
    var customFinishCompletion: ((ApiClientType) -> Void)?
    
    private let dependencyContainer: DependencyContainerType
    private var apiClient: ApiClientType?
    
    private var oldServerConfiguration: ServerConfiguration? {
        guard let configuration = self.dependencyContainer.serverConfigurationManager.getOldConfiguration() else { return nil }
        return configuration.shouldRememberHost ? configuration : nil
    }
    
    // MARK: - Initialization
    init(dependencyContainer: DependencyContainerType) {
        self.dependencyContainer = dependencyContainer
        super.init(window: dependencyContainer.window)
        self.window?.rootViewController = self.navigationController
        self.setUpNavigationController()
        self.setUpNavigationBar()
    }

    // MARK: - Overridden
    override func finish() {
        if let apiClient = self.apiClient {
            self.customFinishCompletion?(apiClient)
        }
        super.finish()
    }
    
    override func openDeepLink(option: DeepLinkOption) {
        #if TEST
        guard case let .testPage(type) = option else { return }
        switch type {
        case .serverConfiguration:
            self.runServerConfigurationFlow(animated: false)
        case .login:
            self.runServerConfigurationFlow(animated: false)
            guard let url = self.dependencyContainer.environmentReader.getURL(forKey: .serverURL) else { return }
            let serverConfiguration = ServerConfiguration(host: url, shouldRememberHost: false)
            self.runAuthenticationFlow(
                with: serverConfiguration,
                animated: false)
        default:
            return
        }
        #endif
    }
    
    // MARK: - Internal
    func start(finishCompletion: ((ApiClientType) -> Void)?) {
        super.start()
        self.customFinishCompletion = finishCompletion
        self.runServerConfigurationFlow()
        guard let configuration = self.oldServerConfiguration else { return }
        self.runAuthenticationFlow(with: configuration, animated: false)
    }
    
}

// MARK: - Structures
extension AuthenticationCoordinator {
    enum State: Equatable {
        case changeAddress
        case loggedInCorrectly
    }
}

// MARK: - ServerConfigurationCoordinatorDelegate
extension AuthenticationCoordinator: ServerConfigurationCoordinatorDelegate {
    func serverConfigurationDidFinish(with serverConfiguration: ServerConfiguration) {
        self.runAuthenticationFlow(with: serverConfiguration, animated: true)
    }
}

// MARK: - LoginCoordinatorDelegate
extension AuthenticationCoordinator: LoginCoordinatorDelegate {
    func loginDidFinish(with state: AuthenticationCoordinator.State) {
        switch state {
        case .changeAddress:
            self.navigationController.popViewController(animated: true)
        case .loggedInCorrectly:
            self.finish()
        }
    }
}

// MARK: - Private
extension AuthenticationCoordinator {
    private func setUpNavigationController() {
        self.navigationController.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController.view.backgroundColor = .clear
    }
    
    private func setUpNavigationBar() {
        self.navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController.navigationBar.isTranslucent = true
        self.navigationController.navigationBar.shadowImage = UIImage()
        self.navigationController.navigationBar.backgroundColor = .clear
        self.navigationController.navigationBar.tintColor = .defaultLabel
    }
    
    private func runServerConfigurationFlow(animated: Bool = true) {
        do {
            let controller = try self.dependencyContainer.viewControllerBuilder.serverConfiguration()
            let viewModel = ServerConfigurationViewModel(
                userInterface: controller,
                coordinator: self,
                serverConfigurationManager: self.dependencyContainer.serverConfigurationManager,
                errorHandler: self.dependencyContainer.errorHandler,
                notificationCenter: self.dependencyContainer.notificationCenter)
            controller.configure(viewModel: viewModel)
            self.navigationController.setViewControllers([controller], animated: animated)
        } catch {
            self.dependencyContainer.errorHandler.stopInDebug("\(error)")
        }
    }
    
    private func runAuthenticationFlow(with configuration: ServerConfiguration, animated: Bool) {
        do {
            let controller = try self.dependencyContainer.viewControllerBuilder.login()
            guard let apiClient = self.createApiClient(
                with: configuration, accessService:
                self.dependencyContainer.accessService) else { return }
            self.apiClient = apiClient
            let contentProvider = LoginContentProvider(
                apiClient: apiClient,
                accessService: self.dependencyContainer.accessService)
            let viewModel = LoginViewModel(
                userInterface: controller,
                coordinator: self,
                contentProvider: contentProvider,
                errorHandler: self.dependencyContainer.errorHandler,
                notificationCenter: self.dependencyContainer.notificationCenter)
            controller.configure(viewModel: viewModel)
            self.navigationController.pushViewController(controller, animated: animated)
            self.navigationController.navigationBar.backItem?.title = ""
        } catch {
            self.dependencyContainer.errorHandler.stopInDebug("\(error)")
        }
    }
    
    private func createApiClient(
        with configuration: ServerConfiguration,
        accessService: AccessServiceApiClientType
    ) -> ApiClientType? {
        guard let hostURL = configuration.host else { return nil }
        return self.dependencyContainer.apiClientFactory.buildAPIClient(accessService: accessService, baseURL: hostURL)
    }
}
