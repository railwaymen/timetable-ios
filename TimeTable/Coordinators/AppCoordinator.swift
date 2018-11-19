//
//  AppCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 25/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit
import Networking
import KeychainAccess

class AppCoordinator: BaseCoordinator {
    
    var navigationController: UINavigationController
    private let storyboardsManager: StoryboardsManagerType
    private let serverConfigurationManager: ServerConfigurationManagerType
    private let parentErrorHandler: ErrorHandlerType
    private var apiClient: ApiClientType?
    private var accessService: AccessServiceLoginType?
    private let coreDataStack: CoreDataStackType
    private let bundle: BundleType
    
    private lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    private var errorHandler: ErrorHandlerType {
        return parentErrorHandler.catchingError(action: { [weak self] error in
            self?.present(error: error)
        })
    }
    
    // MARK: - Initialization
    init(window: UIWindow?, storyboardsManager: StoryboardsManagerType,
         errorHandler: ErrorHandlerType, serverConfigurationManager: ServerConfigurationManagerType,
         coreDataStack: CoreDataStackType, bundle: BundleType) {
        self.navigationController = UINavigationController()
        window?.rootViewController = navigationController
        self.storyboardsManager = storyboardsManager
        self.parentErrorHandler = errorHandler
        self.serverConfigurationManager = serverConfigurationManager
        self.coreDataStack = coreDataStack
        self.bundle = bundle
        super.init(window: window)
        self.navigationController.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - CoordinatorType
    func start() {
        defer {
            super.start()
        }
        if let configuration = serverConfigurationManager.getOldConfiguration(), configuration.shouldRememberHost {
            self.runAuthenticationFlow(configuration: configuration)
        } else {
            self.runServerConfigurationFlow()
        }
    }
    
    // MARK: - Private
    private func createApiClient(with configuration: ServerConfiguration) -> ApiClientType? {
        guard let hostURL = configuration.host else { return nil }
        let networking = Networking(baseURL: hostURL.absoluteString)
        return ApiClient(networking: networking, buildEncoder: {
            return RequestEncoder(encoder: encoder, serialization: CustomJSONSerialization())
        }, buildDecoder: {
            return decoder
        })
    }
    
    private func createKeychain(with configuration: ServerConfiguration) -> Keychain {
        if let host = configuration.host {
            if host.isHTTP {
                return Keychain(server: host, protocolType: .http)
            } else if host.isHTTPS {
                return Keychain(server: host, protocolType: .https)
            }
        }
        guard let bundleIdentifier = bundle.bundleIdentifier else {
            return Keychain()
        }
        return Keychain(accessGroup: bundleIdentifier)
    }
    
    private func createAccessService(with configuration: ServerConfiguration) -> AccessServiceLoginType {
        let keychainAccess = createKeychain(with: configuration)
        return AccessService(userDefaults: UserDefaults.standard,
                             keychainAccess: keychainAccess,
                             buildEncoder: { return encoder },
                             buildDecoder: { return decoder })
    }
    
    private func runServerConfigurationFlow() {
        let coordinator = ServerConfigurationCoordinator(navigationController: navigationController,
                                                         storyboardsManager: storyboardsManager,
                                                         errorHandler: errorHandler,
                                                         serverConfigurationManager: serverConfigurationManager)
        addChildCoordinator(child: coordinator)
        coordinator.start { [weak self, weak coordinator] configuration in
            if let childCoordinator = coordinator {
                self?.removeChildCoordinator(child: childCoordinator)
                self?.runAuthenticationFlow(configuration: configuration)
            }
        }
    }
    
    private func runAuthenticationFlow(configuration: ServerConfiguration) {
        self.apiClient = createApiClient(with: configuration)
        let accessService = createAccessService(with: configuration)
        self.accessService = accessService
        guard let apiClient = self.apiClient else { return }
        let coordinator = AuthenticationCoordinator(navigationController: navigationController,
                                                    storyboardsManager: storyboardsManager,
                                                    accessService: accessService,
                                                    apiClient: apiClient,
                                                    errorHandler: errorHandler,
                                                    coreDataStack: coreDataStack)
        addChildCoordinator(child: coordinator)
        coordinator.start { [weak self, weak coordinator] (state) in
            if let childCoordinator = coordinator {
                self?.removeChildCoordinator(child: childCoordinator)
            }
            switch state {
            case .changeAddress:
                self?.runServerConfigurationFlow()
            case .loggedInCorrectly:
                break
            }
        }
    }
}
