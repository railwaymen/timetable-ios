//
//  DependencyContainer.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 29/10/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

protocol DependencyContainerType {
    var window: UIWindow? { get set }
    var messagePresenter: MessagePresenterType? { get }
    var storyboardsManager: StoryboardsManagerType { get }
    var errorHandler: ErrorHandlerType { get set }
    var serverConfigurationManager: ServerConfigurationManagerType { get }
    var coreDataStack: CoreDataStackType { get }
    var accessServiceBuilder: AccessServiceBuilderType { get }
    var encoder: JSONEncoderType { get }
    var decoder: JSONDecoderType { get }
    var apiClient: ApiClientType? { get set }
    var accessService: AccessServiceLoginType? { get set }
    var notificationCenter: NotificationCenterType { get }
    var dispatchGroupFactory: DispatchGroupFactoryType { get }
}

struct DependencyContainer: DependencyContainerType {
    weak var window: UIWindow?
    weak var messagePresenter: MessagePresenterType?
    let storyboardsManager: StoryboardsManagerType
    var errorHandler: ErrorHandlerType
    let serverConfigurationManager: ServerConfigurationManagerType
    let coreDataStack: CoreDataStackType
    let accessServiceBuilder: AccessServiceBuilderType
    let encoder: JSONEncoderType
    let decoder: JSONDecoderType
    var apiClient: ApiClientType?
    var accessService: AccessServiceLoginType?
    let notificationCenter: NotificationCenterType
    let dispatchGroupFactory: DispatchGroupFactoryType
    
    // MARK: Initialization
    init(window: UIWindow?,
         messagePresenter: MessagePresenterType?,
         storyboardsManager: StoryboardsManagerType,
         errorHandler: ErrorHandlerType,
         serverConfigurationManager: ServerConfigurationManagerType,
         coreDataStack: CoreDataStackType,
         accessServiceBuilder: @escaping AccessServiceBuilderType,
         encoder: JSONEncoderType,
         decoder: JSONDecoderType,
         notificationCenter: NotificationCenterType) {
        self.window = window
        self.messagePresenter = messagePresenter
        self.storyboardsManager = storyboardsManager
        self.errorHandler = errorHandler
        self.serverConfigurationManager = serverConfigurationManager
        self.coreDataStack = coreDataStack
        self.accessServiceBuilder = accessServiceBuilder
        self.encoder = encoder
        self.decoder = decoder
        self.notificationCenter = notificationCenter
        
        self.dispatchGroupFactory = DispatchGroupFactory()
    }
}
