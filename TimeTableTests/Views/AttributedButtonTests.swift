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
    
    func testBorderWidth() {
        //Arrange
        let button = AttributedButton()
        //Act
        button.borderWidth = 2
        let borderWidth = button.layer.borderWidth
        //Assert
        XCTAssertEqual(borderWidth, 2)
    }
    
    func testBorderColor() {
        //Arrange
        let button = AttributedButton()
        //Act
        button.borderColor = .black
        let borderWidth = button.layer.borderWidth
        let borderColor = button.layer.borderColor
        //Assert
        XCTAssertEqual(borderWidth, 1)
        XCTAssertEqual(borderColor, UIColor.black.cgColor)
    }
}
