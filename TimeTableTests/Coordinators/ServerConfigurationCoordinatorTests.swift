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
        coordinator.start(finishCompletion: { _ in })
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
        let serverConfiguration = ServerConfiguration(host: url, shouldRememberHost: false)
        //Act
        coordinator.serverConfigurationDidFinish(with: serverConfiguration)
        //Assert
        XCTAssertTrue(finishCompletionCalled)
        XCTAssertEqual(expectedServerConfiguration, serverConfiguration)
    }
}
