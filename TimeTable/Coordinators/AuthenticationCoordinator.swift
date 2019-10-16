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

protocol ServerConfigurationCoordinatorDelagete: class {
    func serverConfigurationDidFinish(with serverConfiguration: ServerConfiguration)
}

protocol LoginCoordinatorDelegate: class {
    func loginDidFinish(with state: AuthenticationCoordinator.State)
}

class AuthenticationCoordinator: BaseNavigationCoordinator {
    
    private let storyboardsManager: StoryboardsManagerType
    private let accessServiceBuilder: ((ServerConfiguration, JSONEncoderType, JSONDecoderType) -> AccessServiceLoginType)
    private let coreDataStack: CoreDataStackUserType
    private let errorHandler: ErrorHandlerType
    private let serverConfigurationManager: ServerConfigurationManagerType
    private let decoder: JSONDecoderType
    private let encoder: JSONEncoderType
    private var apiClient: ApiClientType?
    private var serverConfiguration: ServerConfiguration?
    
    var customFinishCompletion: ((ServerConfiguration, ApiClientType) -> Void)?
    
    enum State {
        case changeAddress
        case loggedInCorrectly(SessionDecoder)
    }
    
    // MARK: - Initialization
    init(window: UIWindow?,
         messagePresenter: MessagePresenterType?,
         storyboardsManager: StoryboardsManagerType,
         decoder: JSONDecoderType,
         encoder: JSONEncoderType,
         accessServiceBuilder: @escaping ((ServerConfiguration, JSONEncoderType, JSONDecoderType) -> AccessServiceLoginType),
         coreDataStack: CoreDataStackUserType,
         errorHandler: ErrorHandlerType,
         serverConfigurationManager: ServerConfigurationManagerType) {
        self.storyboardsManager = storyboardsManager
        self.accessServiceBuilder = accessServiceBuilder
        self.errorHandler = errorHandler
        self.coreDataStack = coreDataStack
        self.serverConfigurationManager = serverConfigurationManager
        self.encoder = encoder
        self.decoder = decoder
        super.init(window: window, messagePresenter: messagePresenter)
        setNavigationBar()
    }

    // MARK: - CoordinatorType
    func start(finishCompletion: ((ServerConfiguration, ApiClientType) -> Void)?) {
        self.customFinishCompletion = finishCompletion
        if let configuration = serverConfigurationManager.getOldConfiguration(), configuration.shouldRememberHost {
            self.serverConfiguration = configuration
            let accessService = accessServiceBuilder(configuration, encoder, decoder)
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
        super.start()
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
        navigationController.navigationBar.tintColor = .white
    }
    
    private func runServerConfigurationFlow() {
        let controller: ServerConfigurationViewControlleralbe? = storyboardsManager.controller(storyboard: .serverConfiguration, controllerIdentifier: .initial)
        guard let serverSettingsViewController = controller else { return }
        let viewModel = ServerConfigurationViewModel(userInterface: serverSettingsViewController,
                                                     coordinator: self,
                                                     serverConfigurationManager: serverConfigurationManager,
                                                     errorHandler: errorHandler)
        serverSettingsViewController.configure(viewModel: viewModel, notificationCenter: NotificationCenter.default)
        navigationController.setViewControllers([serverSettingsViewController], animated: true)
    }
    
    private func runAuthenticationFlow(with configuration: ServerConfiguration, animated: Bool) {
        let accessService = accessServiceBuilder(configuration, encoder, decoder)
        let controller: LoginViewControllerable? = storyboardsManager.controller(storyboard: .login, controllerIdentifier: .initial)
        guard let loginViewController = controller else { return }
        guard let apiClient = createApiClient(with: configuration) else { return }
        self.apiClient = apiClient
        let contentProvider = LoginContentProvider(apiClient: apiClient, coreDataStack: coreDataStack, accessService: accessService)
        let viewModel = LoginViewModel(userInterface: loginViewController, coordinator: self,
                                       accessService: accessService, contentProvider: contentProvider, errorHandler: errorHandler)
        loginViewController.configure(notificationCenter: NotificationCenter.default, viewModel: viewModel)
        navigationController.pushViewController(loginViewController, animated: animated)
        navigationController.navigationBar.backItem?.title = ""
    }
    
    private func createApiClient(with configuration: ServerConfiguration) -> ApiClientType? {
        guard let hostURL = configuration.host else { return nil }
        let networking = Networking(baseURL: hostURL.absoluteString)
        return ApiClient(networking: networking, buildEncoder: { [encoder] in
            return RequestEncoder(encoder: encoder, serialization: CustomJSONSerialization())
        }, buildDecoder: { [decoder] in
            return decoder
        })
    }
    
    private func updateApiClient(with session: SessionDecoder) {
        self.apiClient?.networking.headerFields?["token"] = session.token
    }
}

// MARK: - ServerConfigurationCoordinatorDelagete
extension AuthenticationCoordinator: ServerConfigurationCoordinatorDelagete {
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
