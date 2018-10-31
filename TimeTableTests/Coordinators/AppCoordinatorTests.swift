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
    
    func testStart_appCoorinatorDoNotContainChildControllers() {
        
        //Arrange
        let appCoordinator = AppCoordinator(window: window, storyboardsManager: storyboardsManagerMock, errorHandler: errorHandlerMock)
        
        //Act
        appCoordinator.start()
        
        //Assert
        XCTAssertTrue(appCoordinator.navigationController.children.isEmpty)
    }
    
    func testStart_appCoorinatorContainsChildControllers() {
        
        //Arrange
        let appCoordinator = AppCoordinator(window: window, storyboardsManager: storyboardsManagerMock, errorHandler: errorHandlerMock)
        storyboardsManagerMock.controller = ServerConfigurationViewControllerMock()
        //Act
        appCoordinator.start()
        
        //Assert
        XCTAssertEqual(appCoordinator.navigationController.children.count, 1)
    }
    
    func testRunAuthenticationFlowCreateChildCoordinator() throws {
        //Arrange
        let serverConfiguration = ServerConfiguration(host: try URL(string: "www.example.com").unwrap(), staySignedIn: true)
        let appCoordinator = AppCoordinator(window: window, storyboardsManager: storyboardsManagerMock, errorHandler: errorHandlerMock)
        storyboardsManagerMock.controller = ServerConfigurationViewControllerMock()
        appCoordinator.start()
        let controller = LoginViewControllerMock()
        storyboardsManagerMock.controller = controller
        //Act
        appCoordinator.serverConfigurationDidFinish(with: serverConfiguration)
        //Assert
        XCTAssertEqual(appCoordinator.children.count, 1)
    }

    func testAuthenticationCoordinatorFinishBlock() throws {
        //Arrange
        let serverConfiguration = ServerConfiguration(host: try URL(string: "www.example.com").unwrap(), staySignedIn: true)
        let appCoordinator = AppCoordinator(window: window, storyboardsManager: storyboardsManagerMock, errorHandler: errorHandlerMock)
        storyboardsManagerMock.controller = ServerConfigurationViewControllerMock()
        appCoordinator.start()
        let controller = LoginViewControllerMock()
        storyboardsManagerMock.controller = controller
        appCoordinator.serverConfigurationDidFinish(with: serverConfiguration)
        let authenticationCoordinator = try (appCoordinator.children.first?.key as? AuthenticationCoordinator).unwrap()
        //Act
        XCTAssertEqual(appCoordinator.children.count, 1)
        authenticationCoordinator.finishCompletion?()
        //Assert
        XCTAssertEqual(appCoordinator.children.count, 0)
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
