//
//  DependencyContainer.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 29/10/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

protocol DependencyContainerType {
    var application: UIApplicationType? { get }
    var window: UIWindow? { get set }
    var messagePresenter: MessagePresenterType? { get }
    var storyboardsManager: StoryboardsManagerType { get }
    var errorHandler: ErrorHandlerType { get set }
    var serverConfigurationManager: ServerConfigurationManagerType { get }
    var accessServiceBuilder: AccessServiceBuilderType { get }
    var encoder: JSONEncoderType { get }
    var decoder: JSONDecoderType { get }
    var apiClient: ApiClientType? { get set }
    var apiClientFactory: APIClientFactoryType { get }
    var accessService: AccessServiceLoginType? { get set }
    var notificationCenter: NotificationCenterType { get }
    var dispatchGroupFactory: DispatchGroupFactoryType { get }
    var dateFactory: DateFactoryType { get }
    var environmentReader: EnvironmentReaderType { get }
}

struct DependencyContainer: DependencyContainerType {
    weak var application: UIApplicationType?
    weak var window: UIWindow?
    weak var messagePresenter: MessagePresenterType?
    let storyboardsManager: StoryboardsManagerType
    var errorHandler: ErrorHandlerType
    let serverConfigurationManager: ServerConfigurationManagerType
    let accessServiceBuilder: AccessServiceBuilderType
    let encoder: JSONEncoderType
    let decoder: JSONDecoderType
    var apiClient: ApiClientType?
    let apiClientFactory: APIClientFactoryType
    var accessService: AccessServiceLoginType?
    let notificationCenter: NotificationCenterType
    let dispatchGroupFactory: DispatchGroupFactoryType
    let dateFactory: DateFactoryType
    let environmentReader: EnvironmentReaderType
    
    // MARK: - Initialization
    init(
        application: UIApplicationType?,
        window: UIWindow?,
        messagePresenter: MessagePresenterType?,
        storyboardsManager: StoryboardsManagerType,
        errorHandler: ErrorHandlerType,
        serverConfigurationManager: ServerConfigurationManagerType,
        accessServiceBuilder: @escaping AccessServiceBuilderType,
        encoder: JSONEncoderType,
        decoder: JSONDecoderType,
        notificationCenter: NotificationCenterType
    ) {
        self.application = application
        self.window = window
        self.messagePresenter = messagePresenter
        self.storyboardsManager = storyboardsManager
        self.errorHandler = errorHandler
        self.serverConfigurationManager = serverConfigurationManager
        self.accessServiceBuilder = accessServiceBuilder
        self.encoder = encoder
        self.decoder = decoder
        self.notificationCenter = notificationCenter
        
        self.dispatchGroupFactory = DispatchGroupFactory()
        self.apiClientFactory = APIClientFactory(
            encoder: encoder,
            decoder: decoder,
            jsonSerialization: CustomJSONSerialization())
        self.dateFactory = DateFactory()
        self.environmentReader = EnvironmentReader()
    }
}
