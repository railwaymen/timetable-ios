//
//  AttributedViewTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 05/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class AttributedViewTests: XCTestCase {
    
    func testBorderWidth() {
        //Arrange
        let sut = AttributedView()
        //Act
        sut.borderWidth = 2
        let borderWidth = sut.layer.borderWidth
        //Assert
        XCTAssertEqual(borderWidth, 2)
    }
    
    func testCornerRadius() {
        //Arrange
        let sut = AttributedView()
        //Act
        sut.cornerRadius = 5
        let cornerRadius = sut.layer.cornerRadius
        let masksToBounds = sut.layer.masksToBounds
        //Assert
        XCTAssertEqual(cornerRadius, 5)
        XCTAssertTrue(masksToBounds)
    }
    
    func testBorderColor() {
        //Arrange
        let sut = AttributedView()
        //Act
        sut.borderColor = .black
        let borderWidth = sut.layer.borderWidth
        let borderColor = sut.layer.borderColor
        //Assert
        XCTAssertEqual(borderWidth, 1)
        XCTAssertEqual(borderColor, UIColor.black.cgColor)
    }
}
