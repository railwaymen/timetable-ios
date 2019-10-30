//
//  DependencyContainerMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 30/10/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class DependencyContainerMock: DependencyContainerType {
    var window: UIWindow?
    
    var messagePresenterMock = MessagePresenterMock()
    var messagePresenter: MessagePresenterType? {
        return messagePresenterMock
    }
    
    var storyboardsManagerMock = StoryboardsManagerMock()
    var storyboardsManager: StoryboardsManagerType {
        return storyboardsManagerMock
    }
    
    private(set) var errorHandlerSetCalled: Bool = false
    private(set) var errorHandlerSetValue: ErrorHandlerType?
    var errorHandlerMock = ErrorHandlerMock()
    var errorHandler: ErrorHandlerType {
        get {
            return errorHandlerMock
        }
        set {
            errorHandlerSetCalled = true
            errorHandlerSetValue = newValue
        }
    }
    
    var serverConfigurationManagerMock = ServerConfigurationManagerMock()
    var serverConfigurationManager: ServerConfigurationManagerType {
        return serverConfigurationManagerMock
    }
    
    var coreDataStackMock = CoreDataStackMock()
    var coreDataStack: CoreDataStackType {
        return coreDataStackMock
    }
    
    lazy var accessServiceBuilder: AccessServiceBuilderType = { [weak self] (_, _, _) -> AccessServiceLoginType in
        return self?.accessServiceMock ?? AccessServiceMock()
    }
    
    var encoderMock = JSONEncoderMock()
    var encoder: JSONEncoderType {
        return encoderMock
    }
    
    var decoderMock = JSONDecoderMock()
    var decoder: JSONDecoderType {
        return decoderMock
    }
    
    private(set) var apiClientSetCalled: Bool = false
    private(set) var apiClientSetValue: ApiClientType?
    var apiClientMock = ApiClientMock()
    var apiClient: ApiClientType? {
        get {
            return apiClientMock
        }
        set {
            apiClientSetCalled = true
            apiClientSetValue = newValue
        }
    }
    
    private(set) var accessServiceSetCalled: Bool = false
    private(set) var accessServiceSetValue: AccessServiceLoginType?
    var accessServiceMock = AccessServiceMock()
    var accessService: AccessServiceLoginType? {
        get {
            return accessServiceMock
        }
        set {
            accessServiceSetCalled = true
            accessServiceSetValue = newValue
        }
    }
    
    var notificationCenterMock = NotificationCenterMock()
    var notificationCenter: NotificationCenterType {
        return notificationCenterMock
    }
    
    var dispatchGroupFactoryMock = DispatchGroupFactoryMock()
    var dispatchGroupFactory: DispatchGroupFactoryType {
        return dispatchGroupFactoryMock
    }
}
