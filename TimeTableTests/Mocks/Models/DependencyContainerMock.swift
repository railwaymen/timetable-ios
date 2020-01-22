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
    var applicationMock = UIApplicationMock()
    var application: UIApplicationType? {
        return self.applicationMock
    }
    
    var window: UIWindow?
    
    var messagePresenterMock = MessagePresenterMock()
    var messagePresenter: MessagePresenterType? {
        return self.messagePresenterMock
    }
    
    var storyboardsManagerMock = StoryboardsManagerMock()
    var storyboardsManager: StoryboardsManagerType {
        return self.storyboardsManagerMock
    }
    
    private(set) var errorHandlerSetCalled: Bool = false
    private(set) var errorHandlerSetValue: ErrorHandlerType?
    var errorHandlerMock = ErrorHandlerMock()
    var errorHandler: ErrorHandlerType {
        get {
            return self.errorHandlerMock
        }
        set {
            self.errorHandlerSetCalled = true
            self.errorHandlerSetValue = newValue
        }
    }
    
    var serverConfigurationManagerMock = ServerConfigurationManagerMock()
    var serverConfigurationManager: ServerConfigurationManagerType {
        return self.serverConfigurationManagerMock
    }
    
    var coreDataStackMock = CoreDataStackMock()
    var coreDataStack: CoreDataStackType {
        return self.coreDataStackMock
    }
    
    lazy var accessServiceBuilder: AccessServiceBuilderType = { [weak self] (_, _, _) -> AccessServiceLoginType in
        return self?.accessServiceMock ?? AccessServiceMock()
    }
    
    var encoderMock = JSONEncoderMock()
    var encoder: JSONEncoderType {
        return self.encoderMock
    }
    
    var decoderMock = JSONDecoderMock()
    var decoder: JSONDecoderType {
        return self.decoderMock
    }
    
    private(set) var apiClientSetCalled: Bool = false
    private(set) var apiClientSetValue: ApiClientType?
    var apiClientMock = ApiClientMock()
    var apiClient: ApiClientType? {
        get {
            return self.apiClientMock
        }
        set {
            self.apiClientSetCalled = true
            self.apiClientSetValue = newValue
        }
    }
    
    var apiClientFactoryMock = APIClientFactoryMock()
    var apiClientFactory: APIClientFactoryType {
        return self.apiClientFactoryMock
    }
    
    private(set) var accessServiceSetCalled: Bool = false
    private(set) var accessServiceSetValue: AccessServiceLoginType?
    var accessServiceMock = AccessServiceMock()
    var accessService: AccessServiceLoginType? {
        get {
            return self.accessServiceMock
        }
        set {
            self.accessServiceSetCalled = true
            self.accessServiceSetValue = newValue
        }
    }
    
    var notificationCenterMock = NotificationCenterMock()
    var notificationCenter: NotificationCenterType {
        return self.notificationCenterMock
    }
    
    var dispatchGroupFactoryMock = DispatchGroupFactoryMock()
    var dispatchGroupFactory: DispatchGroupFactoryType {
        return self.dispatchGroupFactoryMock
    }
}
