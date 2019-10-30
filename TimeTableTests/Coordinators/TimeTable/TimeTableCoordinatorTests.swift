//
//  TimeTableCoordinatorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 24/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class TimeTableCoordinatorTests: XCTestCase {
    private var dependencyContainer: DependencyContainerMock!
    private var coordinator: TimeTableTabCoordinator!
    
    override func setUp() {
        dependencyContainer = DependencyContainerMock()
        coordinator = TimeTableTabCoordinator(dependencyContainer: dependencyContainer)
        super.setUp()
    }

    func testCountOfChildrensOnStart() {
        //Arrange
        //Act
        coordinator.start(finishCompletion: {})
        //Assert
        XCTAssertEqual(coordinator.children.count, 3)
    }
    
    func testFinishCalled() {
        //Arrange
        coordinator.start(finishCompletion: {})
        //Act
        coordinator.finish()
        //Assert
        XCTAssertEqual(coordinator.children.count, 0)
    }
}
