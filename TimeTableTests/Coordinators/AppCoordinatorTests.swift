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
    private var storyboardsManager: StoryboardsManagerMock!
    
    override func setUp() {
        self.window = UIWindow(frame: CGRect.zero)
        self.storyboardsManager = StoryboardsManagerMock()
        super.setUp()
    }
    
    func testStartFailsWhileControllerIsNull() {
        
        //Arrange
        let appCoordinator = AppCoordinator(window: window, storyboardsManager: storyboardsManager)
        
        //Act
        appCoordinator.start()
        
        //Assert
        XCTAssertTrue(appCoordinator.navigationController.children.isEmpty)
    }
}

private class StoryboardsManagerMock: StoryboardsManagerType {
    var controller: UIViewController?
    func controller<T>(storyboard: StoryboardsManager.StoryboardName, controllerIdentifier: StoryboardsManager.ControllerIdentifier) -> T? {
        return controller as? T
    }
}
