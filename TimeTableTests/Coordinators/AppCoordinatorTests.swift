//
//  AppCoordinatorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 25/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class AppCoordinatorTests: XCTestCase {
    
    private var window: UIWindow?
    private var storyboardsManagerMock: StoryboardsManagerMock!
    private var errorHandlerMock: ErrorHandlerMock!
    
    override func setUp() {
        self.window = UIWindow(frame: CGRect.zero)
        self.storyboardsManagerMock = StoryboardsManagerMock()
        self.errorHandlerMock = ErrorHandlerMock()
        super.setUp()
    }
    
    func testStart_appCoordinatorDoNotContainChildControllers() {
        //Arrange
        let appCoordinator = AppCoordinator(window: window, storyboardsManager: storyboardsManagerMock, errorHandler: errorHandlerMock)
        //Act
        appCoordinator.start()
        //Assert
        XCTAssertTrue(appCoordinator.navigationController.children.isEmpty)
    }
    
    func testStart_appCoordinatorContainsChildControllers() {
        //Arrange
        let appCoordinator = AppCoordinator(window: window, storyboardsManager: storyboardsManagerMock, errorHandler: errorHandlerMock)
        storyboardsManagerMock.controller = ServerConfigurationViewControllerMock()
        //Act
        appCoordinator.start()
        //Assert
        XCTAssertEqual(appCoordinator.navigationController.children.count, 1)
    }
    
    func testStartAppCoordinatorContainsChildCoordinatorOnTheStart() {
        //Arrange
        let appCoordinator = AppCoordinator(window: window, storyboardsManager: storyboardsManagerMock, errorHandler: errorHandlerMock)
        //Act
        appCoordinator.start()
        //Assert
        XCTAssertEqual(appCoordinator.children.count, 1)
    }
    
    func testStartAppCoordinatorContainsServerConfigurationCoordinatorOnTheStart() {
        //Arrange
        let appCoordinator = AppCoordinator(window: window, storyboardsManager: storyboardsManagerMock, errorHandler: errorHandlerMock)
        //Act
        appCoordinator.start()
        //Assert
        XCTAssertNotNil(appCoordinator.children.first?.value as? ServerConfigurationCoordinator)
    }
    
    func testAppCoordinator_ServerConfigurationCoordinatorDidFinishDoNotContainServerConfigurationCoordinatorAsChild() {
        //Arrange
        let appCoordinator = AppCoordinator(window: window, storyboardsManager: storyboardsManagerMock, errorHandler: errorHandlerMock)
        appCoordinator.start()
        let serverConfigurationCoordinator = appCoordinator.children.first?.value as? ServerConfigurationCoordinator
        //Act
        serverConfigurationCoordinator?.finish()
        //Assert
        XCTAssertEqual(appCoordinator.children.count, 1)
        XCTAssertNil(appCoordinator.children.first?.value as? ServerConfigurationCoordinator)
    }
    
    func testAppCoordinator_ServerConfigurationCoordinatorDidFinishRunAuthenticationFlow() {
        //Arrange
        let appCoordinator = AppCoordinator(window: window, storyboardsManager: storyboardsManagerMock, errorHandler: errorHandlerMock)
        appCoordinator.start()
        let serverConfigurationCoordinator = appCoordinator.children.first?.value as? ServerConfigurationCoordinator
        //Act
        serverConfigurationCoordinator?.finish()
        //Assert
        XCTAssertNotNil(appCoordinator.children.first?.value as? AuthenticationCoordinator)
    }
    
    func testAppCoordinator_AuthenticationCoordinatorDidFinishDoesNotContainChildCoordinators() {
        //Arrange
        let appCoordinator = AppCoordinator(window: window, storyboardsManager: storyboardsManagerMock, errorHandler: errorHandlerMock)
        appCoordinator.start()
        let serverConfigurationCoordinator = appCoordinator.children.first?.value as? ServerConfigurationCoordinator
        serverConfigurationCoordinator?.finish()
        let authenticationCoordinator = appCoordinator.children.first?.value as? AuthenticationCoordinator
        //Act
        authenticationCoordinator?.finish()
        //Assert
        XCTAssertTrue(appCoordinator.children.isEmpty)
    }
}

private class StoryboardsManagerMock: StoryboardsManagerType {
    var controller: UIViewController?
    func controller<T>(storyboard: StoryboardsManager.StoryboardName, controllerIdentifier: StoryboardsManager.ControllerIdentifier) -> T? {
        return controller as? T
    }
}

private class ErrorHandlerMock: ErrorHandlerType {
    func catchingError(action: @escaping (Error) throws -> Void) -> ErrorHandlerType {
        return ErrorHandler(action: action)
    }
    
    func throwing(error: Error, finally: @escaping (Bool) -> Void) {}
}

private class ServerConfigurationViewControllerMock: ServerConfigurationViewControlleralbe {
    func configure(viewModel: ServerConfigurationViewModelType, notificationCenter: NotificationCenterType) {}
    func setupView(checkBoxIsActive: Bool) {}
    func tearDown() {}
    func hideNavigationBar() {}
    func continueButtonEnabledState(_ isEnabled: Bool) {}
    func checkBoxIsActiveState(_ isActive: Bool) {}
    func dissmissKeyboard() {}
}

private class LoginViewControllerMock: LoginViewControllerable {
    func configure(notificationCenter: NotificationCenterType, viewModel: LoginViewModelType) {}
    func setUpView() {}
    func tearDown() {}
    func passwordInputEnabledState(_ isEnabled: Bool) {}
    func loginButtonEnabledState(_ isEnabled: Bool) {}
    func focusOnPasswordTextField() {}
}
