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

class AppCoordinator: BaseNavigationCoordinator {
    
    private let storyboardsManager: StoryboardsManagerType
    private let serverConfigurationManager: ServerConfigurationManagerType
    private let parentErrorHandler: ErrorHandlerType
    private var apiClient: ApiClientType?
    private let coreDataStack: CoreDataStackType
    private let accessServiceBuilder: ((ServerConfiguration, JSONEncoder, JSONDecoder) -> AccessServiceLoginType)
    
    private lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter(type: .dateAndTimeExtended))
        return encoder
    }()
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter(type: .dateAndTimeExtended))
        return decoder
    }()
    
    private var errorHandler: ErrorHandlerType {
        return parentErrorHandler.catchingError(action: { [weak self] error in
            self?.present(error: error)
        })
    }
    
    // MARK: - Initialization
    init(window: UIWindow?, storyboardsManager: StoryboardsManagerType,
         errorHandler: ErrorHandlerType, serverConfigurationManager: ServerConfigurationManagerType, coreDataStack: CoreDataStackType,
         accessServiceBuilder: @escaping ((ServerConfiguration, JSONEncoderType, JSONDecoderType) -> AccessServiceLoginType)) {
        
        self.storyboardsManager = storyboardsManager
        self.parentErrorHandler = errorHandler
        self.serverConfigurationManager = serverConfigurationManager
        self.accessServiceBuilder = accessServiceBuilder
        self.coreDataStack = coreDataStack
        super.init(window: window)
        self.navigationController.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - CoordinatorType
    func start() {
        defer {
            super.start()
        }
        managedFlow()
    }

    // MARK: - Private
    private func managedFlow() {
        if let configuration = serverConfigurationManager.getOldConfiguration(), configuration.shouldRememberHost {
            let accessService = accessServiceBuilder(configuration, encoder, decoder)
            
            accessService.getSession { [weak self] result in
                switch result {
                case .success(let session): 
                    self?.runMainFlow(configuration: configuration, session: session)
                case .failure:
                    self?.runAuthenticationFlow(configuration: configuration)
                }
            }
        } else {
            self.runServerConfigurationFlow()
        }
    }
    
    private func createApiClient(with configuration: ServerConfiguration) -> ApiClientType? {
        guard let hostURL = configuration.host else { return nil }
        let networking = Networking(baseURL: hostURL.absoluteString)
        return ApiClient(networking: networking, buildEncoder: {
            return RequestEncoder(encoder: encoder, serialization: CustomJSONSerialization())
        }, buildDecoder: {
            return decoder
        })
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
        let accessService = accessServiceBuilder(configuration, encoder, decoder)
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
            case .loggedInCorrectly(let session):
                self?.runMainFlow(configuration: configuration, session: session)
            }
        }
    }
    
    private func runMainFlow(configuration: ServerConfiguration, session: SessionDecoder) {
        if apiClient == nil {
            self.apiClient = createApiClient(with: configuration)
            self.apiClient?.networking.headerFields?["token"] = session.token
        }
        guard let apiClient = self.apiClient else { return }
        let coordinator = TimeTableTabCoordinator(window: self.window,
                                                  storyboardsManager: storyboardsManager,
                                                  apiClient: apiClient,
                                                  errorHandler: errorHandler)
        addChildCoordinator(child: coordinator)
        coordinator.start(finishCompletion: { [weak self, weak coordinator] in
            self?.removeChildCoordinator(child: coordinator)
            self?.managedFlow()
        })
    }
}
