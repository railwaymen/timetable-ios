//
//  ServerConfigurationCoordinatorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 05/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ServerConfigurationCoordinatorTests: XCTestCase {

    private var navigationController: UINavigationController!
    private var storyboardsManagerMock: StoryboardsManagerMock!
    private var errorHandlerMock: ErrorHandlerMock!
    private var coordinator: ServerConfigurationCoordinator!
    
    override func setUp() {
        self.navigationController = UINavigationController()
        self.storyboardsManagerMock = StoryboardsManagerMock()
        self.errorHandlerMock = ErrorHandlerMock()
        self.coordinator = ServerConfigurationCoordinator(navigationController: navigationController,
                                                          storyboardsManager: storyboardsManagerMock,
                                                          errorHandler: errorHandlerMock)
        super.setUp()
    }
 
    func testStartServerConfigurationCoorinatorDoNotContainChildControllers() {
        //Arrange
        //Act
        coordinator.start()
        //Assert
        XCTAssertTrue(coordinator.navigationController.children.isEmpty)
    }
    
    func testStartServerConfigurationCoorinatorContainsChildControllers() {
        //Arrange
        storyboardsManagerMock.controller = ServerConfigurationViewControllerMock()
        //Act
        coordinator.start()
        //Assert
        XCTAssertEqual(coordinator.navigationController.children.count, 1)
    }
    
    func testFinishCompletionExecutedWhileLoginDidFinishDelegateCalled() throws {
        //Arrange
        var finishCompletionCalled = false
        storyboardsManagerMock.controller = ServerConfigurationViewControllerMock()
        coordinator.start(finishCompletion: {
            finishCompletionCalled = true
        })
        let url = try URL(string: "www.example.com").unwrap()
        let serverConfiguration = ServerConfiguration(host: url, staySignedIn: false)
        //Act
        coordinator.serverConfigurationDidFinish(with: serverConfiguration)
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

private class ServerConfigurationViewControllerMock: ServerConfigurationViewControlleralbe {
    func configure(viewModel: ServerConfigurationViewModelType, notificationCenter: NotificationCenterType) {}
    func setupView(checkBoxIsActive: Bool) {}
    func tearDown() {}
    func hideNavigationBar() {}
    func continueButtonEnabledState(_ isEnabled: Bool) {}
    func checkBoxIsActiveState(_ isActive: Bool) {}
    func dissmissKeyboard() {}
}
