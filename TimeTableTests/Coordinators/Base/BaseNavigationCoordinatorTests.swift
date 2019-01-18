//
//  BaseNavigationCoordinatorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 18/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class BaseNavigationCoordinatorTests: XCTestCase {

    func testOverridenInitialization() {
        //Arrange
        let window = UIWindow(frame: .zero)
        //Act
        let coordinator = BaseNavigationCoordinator(window: window)
        //Assert
        XCTAssertNotNil(window.rootViewController as? UINavigationController)
        XCTAssertNotNil(coordinator.navigationController)
    }
    
    func testCustomInitialization() {
        //Arrange
        let window = UIWindow(frame: .zero)
        let navigationController = UINavigationController()
        //Act
        let coordiantor = BaseNavigationCoordinator(window: window, navigationController: navigationController)
        //Assert
        XCTAssertEqual(window.rootViewController, navigationController)
        XCTAssertEqual(coordiantor.navigationController, navigationController)
    }
}
