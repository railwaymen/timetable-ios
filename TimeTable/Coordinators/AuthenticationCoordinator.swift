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
    
    enum State {
        case changeAddress
        case loggedInCorrectly(SessionDecoder)
    }
    
    // MARK: - Initialization
    init(dependencyContainer: DependencyContainerType) {
        self.dependencyContainer = dependencyContainer
        super.init(window: dependencyContainer.window, messagePresenter: dependencyContainer.messagePresenter)
        window?.rootViewController = navigationController
        setNavigationBar()
    }

    // MARK: - CoordinatorType
    func start(finishCompletion: ((ServerConfiguration, ApiClientType) -> Void)?) {
        super.start()
        self.customFinishCompletion = finishCompletion
        if let configuration = dependencyContainer.serverConfigurationManager.getOldConfiguration(), configuration.shouldRememberHost {
            self.serverConfiguration = configuration
            let accessService = dependencyContainer.accessServiceBuilder(configuration, dependencyContainer.encoder, dependencyContainer.decoder)
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
    
    override func finish() {
        if let configuration = self.serverConfiguration, let apiClient = self.apiClient {
            customFinishCompletion?(configuration, apiClient)
        }
        super.finish()
    }

    // MARL: - Private
    private func setNavigationBar() {
        navigationController.interactivePopGestureRecognizer?.delegate = nil
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.view.backgroundColor = .clear
        navigationController.navigationBar.backgroundColor = .clear
        navigationController.navigationBar.tintColor = .defaultLabel
    }
    
    private func runServerConfigurationFlow() {
        let controller: ServerConfigurationViewControllerable? = dependencyContainer.storyboardsManager.controller(storyboard: .serverConfiguration)
        guard let serverSettingsViewController = controller else { return }
        let viewModel = ServerConfigurationViewModel(userInterface: serverSettingsViewController,
                                                     coordinator: self,
                                                     serverConfigurationManager: dependencyContainer.serverConfigurationManager,
                                                     errorHandler: dependencyContainer.errorHandler)
        serverSettingsViewController.configure(viewModel: viewModel, notificationCenter: dependencyContainer.notificationCenter)
        navigationController.setViewControllers([serverSettingsViewController], animated: true)
    }
    
    private func runAuthenticationFlow(with configuration: ServerConfiguration, animated: Bool) {
        let accessService = dependencyContainer.accessServiceBuilder(configuration, dependencyContainer.encoder, dependencyContainer.decoder)
        let controller: LoginViewControllerable? = dependencyContainer.storyboardsManager.controller(storyboard: .login)
        guard let loginViewController = controller else { return }
        guard let apiClient = createApiClient(with: configuration) else { return }
        self.apiClient = apiClient
        let contentProvider = LoginContentProvider(apiClient: apiClient,
                                                   coreDataStack: dependencyContainer.coreDataStack,
                                                   accessService: accessService)
        let viewModel = LoginViewModel(userInterface: loginViewController,
                                       coordinator: self,
                                       accessService: accessService,
                                       contentProvider: contentProvider,
                                       errorHandler: dependencyContainer.errorHandler)
        loginViewController.configure(notificationCenter: dependencyContainer.notificationCenter, viewModel: viewModel)
        navigationController.pushViewController(loginViewController, animated: animated)
        navigationController.navigationBar.backItem?.title = ""
    }
    
    private func createApiClient(with configuration: ServerConfiguration) -> ApiClientType? {
        guard let hostURL = configuration.host else { return nil }
        let networking = Networking(baseURL: hostURL.absoluteString)
        return ApiClient(networking: networking, buildEncoder: { [encoder = dependencyContainer.encoder] in
            return RequestEncoder(encoder: encoder, serialization: CustomJSONSerialization())
        }, buildDecoder: { [decoder = dependencyContainer.decoder] in
            return decoder
        })
    }
    
    private func updateApiClient(with session: SessionDecoder) {
        self.apiClient?.networking.headerFields?["token"] = session.token
    }
}

// MARK: - ServerConfigurationCoordinatorDelegate
extension AuthenticationCoordinator: ServerConfigurationCoordinatorDelegate {
    func serverConfigurationDidFinish(with serverConfiguration: ServerConfiguration) {
        self.serverConfiguration = serverConfiguration
        runAuthenticationFlow(with: serverConfiguration, animated: true)
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

// MARK: - State Equatable
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
