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
    
    var accessServiceMock = AccessServiceMock()
    var accessService: AccessServiceLoginType {
        self.accessServiceMock
    }
    
    var notificationCenterMock = NotificationCenterMock()
    var notificationCenter: NotificationCenterType {
        return self.notificationCenterMock
    }
    
    var dispatchGroupFactoryMock = DispatchGroupFactoryMock()
    var dispatchGroupFactory: DispatchGroupFactoryType {
        return self.dispatchGroupFactoryMock
    }
    
    var dateFactoryMock = DateFactoryMock()
    var dateFactory: DateFactoryType {
        self.dateFactoryMock
    }
    
    let environmentReader: EnvironmentReaderType = EnvironmentReader()
    
    var taskFormFactoryMock = TaskFormFactoryMock()
    var taskFormFactory: TaskFormFactoryType {
        self.taskFormFactoryMock
    }
    
    var viewControllerBuilderMock = ViewControllerBuilderMock()
    var viewControllerBuilder: ViewControllerBuilderType {
        self.viewControllerBuilderMock
    }
    
    var keyboardManagerMock = KeyboardManagerMock()
    var keyboardManager: KeyboardManagerable {
        self.keyboardManagerMock
    }
    
    private(set) var parentCoordinatorSetCalled: Bool = false
    private(set) var parentCoordinatorSetValue: ParentCoordinator?
    var parentCoordinatorMock: ParentCoordinatorMock? = ParentCoordinatorMock()
    var parentCoordinator: ParentCoordinator? {
        get {
            self.parentCoordinatorMock
        }
        set {
            self.parentCoordinatorSetCalled = true
            self.parentCoordinatorSetValue = newValue
        }
    }
}
