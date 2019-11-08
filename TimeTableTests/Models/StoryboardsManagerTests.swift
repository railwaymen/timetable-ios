//
//  StoryboardsManagerTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 25/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class StoryboardsManagerTests: XCTestCase {

    func testIfMainStoryboardExists() {
        //Arrange
        let manager = StoryboardsManager.shared
        //Act
        let controller: ServerConfigurationViewController? = manager.controller(storyboard: .serverConfiguration, controllerIdentifier: .initial)
        //Assert
        XCTAssertNotNil(controller)
    }
}
