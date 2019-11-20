//
//  TimeTableTabCoordinatorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 24/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class TimeTableTabCoordinatorTests: XCTestCase {
    private var dependencyContainer: DependencyContainerMock!
    
    override func setUp() {
        self.dependencyContainer = DependencyContainerMock()
        super.setUp()
    }

    func testCountOfChildrensOnStart() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.start(finishCompletion: {})
        //Assert
        XCTAssertEqual(sut.children.count, 3)
    }
    
    func testFinishCalled() {
        //Arrange
        let sut = self.buildSUT()
        sut.start(finishCompletion: {})
        //Act
        sut.finish()
        //Assert
        XCTAssertEqual(sut.children.count, 0)
    }
}

// MARK: - Private
extension TimeTableTabCoordinatorTests {
    private func buildSUT() -> TimeTableTabCoordinator {
        return TimeTableTabCoordinator(dependencyContainer: self.dependencyContainer)
    }
}
