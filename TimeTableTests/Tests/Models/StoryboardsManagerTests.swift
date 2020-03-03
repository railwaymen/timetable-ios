//
//  StoryboardsManagerTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 25/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class StoryboardsManagerTests: XCTestCase {}

// MARK: - controller<T>(storyboard: StoryboardsManager.StoryboardName, controllerIdentifier: ControllerIdentifier) -> T?
extension StoryboardsManagerTests {
    func testIfMainStoryboardExists() {
        //Arrange
        let sut = StoryboardsManager()
        //Act
        let controller: ServerConfigurationViewController? = sut.controller(storyboard: .serverConfiguration, controllerIdentifier: .initial)
        //Assert
        XCTAssertNotNil(controller)
    }
}
