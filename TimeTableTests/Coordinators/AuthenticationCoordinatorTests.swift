//
//  AuthenticationCoordinatorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 30/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class AuthenticationCoordinatorTests: XCTestCase {
 
    private var navigationController: UINavigationController!
    private var storyboardsManagerMock: StoryboardsManagerMock!
    private var errorHandlerMock: ErrorHandlerMock!
    
    override func setUp() {
        self.navigationController = UINavigationController()
        self.storyboardsManagerMock = StoryboardsManagerMock()
        self.errorHandlerMock = ErrorHandlerMock()
        super.setUp()
    }
    
    func testStartAuthenticationCoorinatorDoNotContainChildControllers() {
        //Arrange
        let coordinator = AuthenticationCoordinator(navigationController: navigationController,
                                                    storyboardsManager: storyboardsManagerMock,
                                                    errorHandler: errorHandlerMock)
        //Act
        coordinator.start()
        //Assert
        XCTAssertTrue(coordinator.navigationController.children.isEmpty)
    }
    
    func testStartAuthenticationCoorinatorContainsChildControllers() {
        //Arrange
        let coordinator = AuthenticationCoordinator(navigationController: navigationController,
                                                    storyboardsManager: storyboardsManagerMock,
                                                    errorHandler: errorHandlerMock)
        storyboardsManagerMock.controller = LoginViewControllerMock()
        //Act
        coordinator.start()
        //Assert
        XCTAssertEqual(coordinator.navigationController.children.count, 1)
    }
    
    func testFinishCompletionExecutedWhileLoginDidFinishDelegateCalled() {
        //Arrange
        var finishCompletionCalled = false
        let coordinator = AuthenticationCoordinator(navigationController: navigationController,
                                                    storyboardsManager: storyboardsManagerMock,
                                                    errorHandler: errorHandlerMock)
        storyboardsManagerMock.controller = LoginViewControllerMock()
        coordinator.start(finishCompletion: {
            finishCompletionCalled = true
        })
        //Act
        coordinator.loginDidfinish()
        //Assert
        XCTAssertTrue(finishCompletionCalled)
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

private class LoginViewControllerMock: LoginViewControllerable {
    func configure(notificationCenter: NotificationCenterType, viewModel: LoginViewModelType) {}
    func setUpView() {}
    func tearDown() {}
    func passwordInputEnabledState(_ isEnabled: Bool) {}
    func loginButtonEnabledState(_ isEnabled: Bool) {}
    func focusOnPasswordTextField() {}
}
