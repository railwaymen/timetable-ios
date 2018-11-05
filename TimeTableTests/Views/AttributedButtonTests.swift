//
//  AttributedButtonTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 05/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class AttributedButtonTests: XCTestCase {
    
    func testCornerRadious() {
        //Arrange
        let button = AttributedButton()
        //Act
        button.cornerRadius = 5
        let cornerRadius = button.layer.cornerRadius
        let masksToBounds = button.layer.masksToBounds
        //Assert
        XCTAssertEqual(cornerRadius, 5)
        XCTAssertTrue(masksToBounds)
    }
}
