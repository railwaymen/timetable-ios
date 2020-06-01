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
    var errorHandler: ErrorHandlerType { get set }
    var serverConfigurationManager: ServerConfigurationManagerType { get }
    var encoder: JSONEncoderType { get }
    var decoder: JSONDecoderType { get }
    var apiClient: ApiClientType? { get set }
    var apiClientFactory: APIClientFactoryType { get }
    var accessService: AccessServiceLoginType { get }
    var notificationCenter: NotificationCenterType { get }
    var dispatchGroupFactory: DispatchGroupFactoryType { get }
    var dateFactory: DateFactoryType { get }
    var environmentReader: EnvironmentReaderType { get }
    var taskFormFactory: TaskFormFactoryType { get }
    var viewControllerBuilder: ViewControllerBuilderType { get }
    var keyboardManager: KeyboardManagerable { get }
    var parentCoordinator: ParentCoordinator? { get set }
}

extension DependencyContainerType {
    func requireApiClient() -> ApiClientType? {
        self.apiClient.unwrapped(using: self.errorHandler)
    }
}

struct DependencyContainer: DependencyContainerType {
    weak var application: UIApplicationType?
    weak var window: UIWindow?
    weak var messagePresenter: MessagePresenterType?
    var errorHandler: ErrorHandlerType
    let serverConfigurationManager: ServerConfigurationManagerType
    let encoder: JSONEncoderType
    let decoder: JSONDecoderType
    var apiClient: ApiClientType?
    let apiClientFactory: APIClientFactoryType
    var accessService: AccessServiceLoginType
    let notificationCenter: NotificationCenterType
    let dispatchGroupFactory: DispatchGroupFactoryType
    let dateFactory: DateFactoryType
    let environmentReader: EnvironmentReaderType
    let taskFormFactory: TaskFormFactoryType
    let viewControllerBuilder: ViewControllerBuilderType
    let keyboardManager: KeyboardManagerable
    weak var parentCoordinator: ParentCoordinator?
    
    // MARK: - Initialization
    init(
        application: UIApplicationType?,
        window: UIWindow?,
        messagePresenter: MessagePresenterType?,
        errorHandler: ErrorHandlerType,
        serverConfigurationManager: ServerConfigurationManagerType,
        accessService: AccessServiceLoginType,
        encoder: JSONEncoderType,
        decoder: JSONDecoderType,
        notificationCenter: NotificationCenterType = NotificationCenter.default,
        taskFormFactory: TaskFormFactoryType,
        viewControllerBuilder: ViewControllerBuilderType = ViewControllerBuilder(),
        keyboardManager: KeyboardManagerable
    ) {
        self.application = application
        self.window = window
        self.messagePresenter = messagePresenter
        self.errorHandler = errorHandler
        self.serverConfigurationManager = serverConfigurationManager
        self.accessService = accessService
        self.encoder = encoder
        self.decoder = decoder
        self.notificationCenter = notificationCenter
        self.taskFormFactory = taskFormFactory
        self.viewControllerBuilder = viewControllerBuilder
        self.keyboardManager = keyboardManager
        
        self.dispatchGroupFactory = DispatchGroupFactory()
        self.apiClientFactory = APIClientFactory(
            encoder: encoder,
            decoder: decoder,
            jsonSerialization: CustomJSONSerialization())
        self.dateFactory = DateFactory()
        self.environmentReader = EnvironmentReader()
    }
}
