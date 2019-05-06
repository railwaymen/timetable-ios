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
    private weak var messagePresenter: MessagePresenterType?
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
    init(window: UIWindow?,
         messagePresenter: MessagePresenterType?,
         storyboardsManager: StoryboardsManagerType,
         errorHandler: ErrorHandlerType,
         serverConfigurationManager: ServerConfigurationManagerType,
         coreDataStack: CoreDataStackType,
         accessServiceBuilder: @escaping ((ServerConfiguration, JSONEncoderType, JSONDecoderType) -> AccessServiceLoginType)) {
        
        self.storyboardsManager = storyboardsManager
        self.parentErrorHandler = errorHandler
        self.serverConfigurationManager = serverConfigurationManager
        self.accessServiceBuilder = accessServiceBuilder
        self.coreDataStack = coreDataStack
        super.init(window: window, messagePresenter: messagePresenter)
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
        let coordinator = AuthenticationCoordinator(window: self.window,
                                                    messagePresenter: self.messagePresenter,
                                                    storyboardsManager: self.storyboardsManager,
                                                    decoder: self.decoder,
                                                    encoder: self.encoder,
                                                    accessServiceBuilder: self.accessServiceBuilder,
                                                    coreDataStack: self.coreDataStack,
                                                    errorHandler: self.errorHandler,
                                                    serverConfigurationManager: self.serverConfigurationManager)
        self.addChildCoordinator(child: coordinator)
        coordinator.start { [weak self] (configuration, apiClient) in
            defer {
                self?.removeChildCoordinator(child: coordinator)
            }
            self?.runMainFlow(configuration: configuration, apiClient: apiClient)
        }
    }
    
    private func runMainFlow(configuration: ServerConfiguration, apiClient: ApiClientType) {
        let accessService = self.accessServiceBuilder(configuration, self.encoder, self.decoder)
        let coordinator = TimeTableTabCoordinator(window: self.window,
                                                  messagePresenter: self.messagePresenter,
                                                  storyboardsManager: self.storyboardsManager,
                                                  apiClient: apiClient,
                                                  accessService: accessService,
                                                  coreDataStack: self.coreDataStack,
                                                  errorHandler: self.errorHandler)
        self.addChildCoordinator(child: coordinator)
        coordinator.start(finishCompletion: { [weak self, weak coordinator] in
            self?.removeChildCoordinator(child: coordinator)
            self?.runAuthenticationFlow()
        })
    }
}
