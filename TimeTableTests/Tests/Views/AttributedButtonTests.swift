//
//  AttributedButtonTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 05/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class AttributedButtonTests: XCTestCase {}

// MARK: - cornerRadius: CGFloat
extension AttributedButtonTests {
    func testCornerRadious() {
        //Arrange
        let sut = AttributedButton()
        //Act
        sut.cornerRadius = 5
        let cornerRadius = sut.layer.cornerRadius
        let masksToBounds = sut.layer.masksToBounds
        //Assert
        XCTAssertEqual(cornerRadius, 5)
        XCTAssertTrue(masksToBounds)
    }
}

// MARK: - borderWidth: CGFloat
extension AttributedButtonTests {
    func testBorderWidth() {
        //Arrange
        let sut = AttributedButton()
        //Act
        sut.borderWidth = 2
        let borderWidth = sut.layer.borderWidth
        //Assert
        XCTAssertEqual(borderWidth, 2)
    }
}

// MARK: - borderColor: UIColor?
extension AttributedButtonTests {
    func testBorderColor() {
        //Arrange
        let sut = AttributedButton()
        //Act
        sut.borderColor = .black
        let borderWidth = sut.layer.borderWidth
        let borderColor = sut.layer.borderColor
        //Assert
        XCTAssertEqual(borderWidth, 1)
        XCTAssertEqual(borderColor, UIColor.black.cgColor)
    }
}
