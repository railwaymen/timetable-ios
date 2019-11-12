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
        let view = AttributedView()
        //Act
        view.borderWidth = 2
        let borderWidth = view.layer.borderWidth
        //Assert
        XCTAssertEqual(borderWidth, 2)
    }
    
    func testCornerRadious() {
        //Arrange
        let view = AttributedView()
        //Act
        view.cornerRadius = 5
        let cornerRadius = view.layer.cornerRadius
        let masksToBounds = view.layer.masksToBounds
        //Assert
        XCTAssertEqual(cornerRadius, 5)
        XCTAssertTrue(masksToBounds)
    }
    
    func testBorderColor() {
        //Arrange
        let view = AttributedView()
        //Act
        view.borderColor = .black
        let borderWidth = view.layer.borderWidth
        let borderColor = view.layer.borderColor
        //Assert
        XCTAssertEqual(borderWidth, 1)
        XCTAssertEqual(borderColor, UIColor.black.cgColor)
    }
}
