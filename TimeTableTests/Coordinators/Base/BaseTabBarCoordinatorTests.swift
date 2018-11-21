//
//  BaseTabBarCoordinatorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 21/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class BaseTabBarCoordinatorTests: XCTestCase {
    
    func testStartWithDefaultFinishCompletion() {
        //Arrange
        let window = UIWindow()
        let coordinator = BaseTabBarCoordinator(window: window)
        //Act
        coordinator.start()
        //Assert
        XCTAssertNotNil(coordinator.window?.rootViewController as? UITabBarController)
    }
    
    func testStartWithCustomFinishCompletion() {
        //Arrange
        let window = UIWindow()
        let coordinator = BaseTabBarCoordinator(window: window)
        //Act
        coordinator.start {}
        //Assert
        XCTAssertNotNil(coordinator.window?.rootViewController as? UITabBarController)
    }
    
    func testFinishCompletion() {
        //Arrange
        var finishCompletionCalled = false
        let window = UIWindow()
        let coordinator = BaseTabBarCoordinator(window: window)
        //Act
        coordinator.start {
            finishCompletionCalled = true
        }
        coordinator.finishCompletion?()
        //Assert
        XCTAssertTrue(finishCompletionCalled)
    }
}
