//
//  AppCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 25/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

class AppCoordinator: BaseCoordinator {
    
    private let storyboardsManager: StoryboardsManagerType
    private let serverConfigurationManager: ServerConfigurationManagerType
    private let parentErrorHandler: ErrorHandlerType
    private var apiClient: ApiClientType?
    private let coreDataStack: CoreDataStackType
    private let accessServiceBuilder: ((ServerConfiguration, JSONEncoderType, JSONDecoderType) -> AccessServiceLoginType)
    
    private lazy var encoder: JSONEncoderType = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter(type: .dateAndTimeExtended))
        return encoder
    }()
    
    private lazy var decoder: JSONDecoderType = {
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
    }

    // MARK: - CoordinatorType
    func start() {
        defer {
            super.start()
        }
        runAuthenticationFlow()
    }

    // MARK: - Privat
    private func runAuthenticationFlow() {
        let coordinator = AuthenticationCoordinator(window: window, storyboardsManager: storyboardsManager,
                                                    decoder: decoder, encoder: encoder, accessServiceBuilder: accessServiceBuilder,
                                                    coreDataStack: coreDataStack,
                                                    errorHandler: errorHandler, serverConfigurationManager: serverConfigurationManager)
        addChildCoordinator(child: coordinator)
        coordinator.start { [weak self] (configuration, apiClient) in
            defer {
                self?.removeChildCoordinator(child: coordinator)
            }
            self?.runMainFlow(configuration: configuration, apiClient: apiClient)
        }
    }
    
    private func runMainFlow(configuration: ServerConfiguration, apiClient: ApiClientType) {
        let accessService = accessServiceBuilder(configuration, encoder, decoder)
        let coordinator = TimeTableTabCoordinator(window: window,
                                                  storyboardsManager: storyboardsManager,
                                                  apiClient: apiClient,
                                                  accessService: accessService,
                                                  coreDataStack: coreDataStack,
                                                  errorHandler: errorHandler)
        addChildCoordinator(child: coordinator)
        coordinator.start(finishCompletion: { [weak self, weak coordinator] in
            self?.removeChildCoordinator(child: coordinator)
            self?.runAuthenticationFlow()
        })
    }
}
