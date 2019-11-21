//
//  AuthenticationCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 05/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit
import Networking
import KeychainAccess

protocol ServerConfigurationCoordinatorDelegate: class {
    func serverConfigurationDidFinish(with serverConfiguration: ServerConfiguration)
}

protocol LoginCoordinatorDelegate: class {
    func loginDidFinish(with state: AuthenticationCoordinator.State)
}

class AuthenticationCoordinator: BaseNavigationCoordinator {
    private let dependencyContainer: DependencyContainerType
    private var apiClient: ApiClientType?
    private var serverConfiguration: ServerConfiguration?
    
    var customFinishCompletion: ((ServerConfiguration, ApiClientType) -> Void)?
    
    // MARK: - Initialization
    init(dependencyContainer: DependencyContainerType) {
        self.dependencyContainer = dependencyContainer
        super.init(window: dependencyContainer.window, messagePresenter: dependencyContainer.messagePresenter)
        self.window?.rootViewController = self.navigationController
        self.setNavigationBar()
    }

    // MARK: - Overridden
    override func finish() {
        if let configuration = self.serverConfiguration, let apiClient = self.apiClient {
            customFinishCompletion?(configuration, apiClient)
        }
        super.finish()
    }
    
    // MARK: - Internal
    func start(finishCompletion: ((ServerConfiguration, ApiClientType) -> Void)?) {
        super.start()
        self.customFinishCompletion = finishCompletion
        if let configuration = self.dependencyContainer.serverConfigurationManager.getOldConfiguration(), configuration.shouldRememberHost {
            self.serverConfiguration = configuration
            let accessService = self.dependencyContainer.accessServiceBuilder(configuration, self.dependencyContainer.encoder, self.dependencyContainer.decoder)
            accessService.getSession { [weak self] result in
                switch result {
                case .success(let session):
                    self?.apiClient = self?.createApiClient(with: configuration)
                    self?.updateApiClient(with: session)
                    self?.finish()
                case .failure:
                    self?.runServerConfigurationFlow()
                    self?.runAuthenticationFlow(with: configuration, animated: false)
                }
            }
        } else {
            self.runServerConfigurationFlow()
        }
    }
}

// MARK: - Structures
extension AuthenticationCoordinator {
    enum State {
        case changeAddress
        case loggedInCorrectly(SessionDecoder)
    }
}

// MARK: - ServerConfigurationCoordinatorDelegate
extension AuthenticationCoordinator: ServerConfigurationCoordinatorDelegate {
    func serverConfigurationDidFinish(with serverConfiguration: ServerConfiguration) {
        self.serverConfiguration = serverConfiguration
        self.runAuthenticationFlow(with: serverConfiguration, animated: true)
    }
}

// MARK: - LoginCoordinatorDelegate
extension AuthenticationCoordinator: LoginCoordinatorDelegate {
    func loginDidFinish(with state: AuthenticationCoordinator.State) {
        switch state {
        case .changeAddress:
            self.navigationController.popViewController(animated: true)
        case .loggedInCorrectly(let session):
            self.updateApiClient(with: session)
            self.finish()
        }
    }
}

// MARK: - Equatable
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

// MARK: - Private
extension AuthenticationCoordinator {
    private func setNavigationBar() {
        self.navigationController.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController.navigationBar.isTranslucent = true
        self.navigationController.navigationBar.shadowImage = UIImage()
        self.navigationController.view.backgroundColor = .clear
        self.navigationController.navigationBar.backgroundColor = .clear
        self.navigationController.navigationBar.tintColor = .defaultLabel
    }
    
    private func runServerConfigurationFlow() {
        let controller: ServerConfigurationViewControllerable? = self.dependencyContainer.storyboardsManager.controller(storyboard: .serverConfiguration)
        guard let serverSettingsViewController = controller else { return }
        let viewModel = ServerConfigurationViewModel(userInterface: serverSettingsViewController,
                                                     coordinator: self,
                                                     serverConfigurationManager: self.dependencyContainer.serverConfigurationManager,
                                                     errorHandler: self.dependencyContainer.errorHandler)
        serverSettingsViewController.configure(viewModel: viewModel, notificationCenter: self.dependencyContainer.notificationCenter)
        self.navigationController.setViewControllers([serverSettingsViewController], animated: true)
    }
    
    private func runAuthenticationFlow(with configuration: ServerConfiguration, animated: Bool) {
        let accessService = self.dependencyContainer.accessServiceBuilder(configuration, self.dependencyContainer.encoder, self.dependencyContainer.decoder)
        let controller: LoginViewControllerable? = self.dependencyContainer.storyboardsManager.controller(storyboard: .login)
        guard let loginViewController = controller else { return }
        guard let apiClient = self.createApiClient(with: configuration) else { return }
        self.apiClient = apiClient
        let contentProvider = LoginContentProvider(apiClient: apiClient,
                                                   coreDataStack: self.dependencyContainer.coreDataStack,
                                                   accessService: accessService)
        let viewModel = LoginViewModel(userInterface: loginViewController,
                                       coordinator: self,
                                       accessService: accessService,
                                       contentProvider: contentProvider,
                                       errorHandler: self.dependencyContainer.errorHandler)
        loginViewController.configure(notificationCenter: self.dependencyContainer.notificationCenter, viewModel: viewModel)
        self.navigationController.pushViewController(loginViewController, animated: animated)
        self.navigationController.navigationBar.backItem?.title = ""
    }
    
    private func createApiClient(with configuration: ServerConfiguration) -> ApiClientType? {
        guard let hostURL = configuration.host else { return nil }
        let networking = Networking(baseURL: hostURL.absoluteString)
        return ApiClient(networking: networking,
                         encoder: RequestEncoder(encoder: self.dependencyContainer.encoder, serialization: CustomJSONSerialization()),
                         decoder: self.dependencyContainer.decoder)
    }
    
    private func updateApiClient(with session: SessionDecoder) {
        self.apiClient?.networking.headerFields?["token"] = session.token
    }
}
