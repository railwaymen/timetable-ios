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
        storyboardsManagerMock.controller = ServerConfigurationViewController()
        //Act
        appCoordinator.start()
        
        //Assert
        XCTAssertEqual(appCoordinator.navigationController.children.count, 1)
    }
    
    func testCoordinatorDoesNotPresentAlertController() {
        //Arrange
        let appCoordinator = AppCoordinator(window: window, storyboardsManager: storyboardsManagerMock, errorHandler: errorHandlerMock)
        storyboardsManagerMock.controller = ServerConfigurationViewController()
        appCoordinator.start()
        //Act
        //Assert
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
