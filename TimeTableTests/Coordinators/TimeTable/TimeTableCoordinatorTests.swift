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
        self.dependencyContainer = DependencyContainerMock()
        self.coordinator = TimeTableTabCoordinator(dependencyContainer: self.dependencyContainer)
        super.setUp()
    }

    func testCountOfChildrensOnStart() {
        //Arrange
        //Act
        self.coordinator.start(finishCompletion: {})
        //Assert
        XCTAssertEqual(self.coordinator.children.count, 3)
    }
    
    func testFinishCalled() {
        //Arrange
        self.coordinator.start(finishCompletion: {})
        //Act
        self.coordinator.finish()
        //Assert
        XCTAssertEqual(self.coordinator.children.count, 0)
    }
}
