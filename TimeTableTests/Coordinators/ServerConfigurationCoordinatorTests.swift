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
    private var serverConfigurationManagerMock: ServerConfigurationManagerMock!
    
    override func setUp() {
        self.navigationController = UINavigationController()
        self.storyboardsManagerMock = StoryboardsManagerMock()
        self.errorHandlerMock = ErrorHandlerMock()
        self.serverConfigurationManagerMock = ServerConfigurationManagerMock()
        self.coordinator = ServerConfigurationCoordinator(navigationController: navigationController,
                                                          storyboardsManager: storyboardsManagerMock,
                                                          errorHandler: errorHandlerMock,
                                                          serverConfigurationManager: serverConfigurationManagerMock)
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
        coordinator.start(finishCompletion: { _ in })
        //Assert
        XCTAssertEqual(coordinator.navigationController.children.count, 1)
    }
    
    func testFinishCompletionExecutedWhileLoginDidFinishDelegateCalled() throws {
        //Arrange
        var finishCompletionCalled = false
        var expectedServerConfiguration: ServerConfiguration?
        storyboardsManagerMock.controller = ServerConfigurationViewControllerMock()
        coordinator.start(finishCompletion: { configuration in
            finishCompletionCalled = true
            expectedServerConfiguration = configuration
        })
        coordinator.start(finishCompletion: {
            
        })
        let url = try URL(string: "www.example.com").unwrap()
        let serverConfiguration = ServerConfiguration(host: url, shouldRemeberHost: false)
        //Act
        coordinator.serverConfigurationDidFinish(with: serverConfiguration)
        //Assert
        XCTAssertTrue(finishCompletionCalled)
        XCTAssertEqual(expectedServerConfiguration, serverConfiguration)
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

private class ServerConfigurationManagerMock: ServerConfigurationManagerType {
    func getOldConfiguration() -> ServerConfiguration? {
        return nil
    }
    func verify(configuration: ServerConfiguration, completion: @escaping ((Result<Void>) -> Void)) {}
}

private class ServerConfigurationViewControllerMock: ServerConfigurationViewControlleralbe {
    func configure(viewModel: ServerConfigurationViewModelType, notificationCenter: NotificationCenterType) {}
    func setupView(checkBoxIsActive: Bool, serverAddress: String) {}
    func tearDown() {}
    func hideNavigationBar() {}
    func continueButtonEnabledState(_ isEnabled: Bool) {}
    func checkBoxIsActiveState(_ isActive: Bool) {}
    func dissmissKeyboard() {}
}
