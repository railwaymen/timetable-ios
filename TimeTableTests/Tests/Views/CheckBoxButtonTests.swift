//
//  CheckBoxButtonTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 05/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class CheckBoxButtonTests: XCTestCase {}

// MARK: - isActive: Bool
extension CheckBoxButtonTests {
    func testIsActiveTrue() {
        //Arrange
        let sut = CheckBoxButton()
        //Act
        sut.isActive = true
        let image = sut.image(for: .normal)
        //Assert
        XCTAssertEqual(image, UIImage(named: "check"))
    }
    
    func testIsActiveFalse() {
        //Arrange
        let sut = CheckBoxButton()
        //Act
        sut.isActive = false
        let image = sut.image(for: .normal)
        //Assert
        XCTAssertNil(image)
    }
}

// MARK: - borderWidth: CGFloat
extension CheckBoxButtonTests {
    func testBorderWidth() {
        //Arrange
        let sut = CheckBoxButton()
        //Act
        sut.borderWidth = 2
        let borderWidth = sut.layer.borderWidth
        //Assert
        XCTAssertEqual(borderWidth, 2)
    }
}

// MARK: - cornerRadius: CGFloat
extension CheckBoxButtonTests {
    func testCornerRadious() {
        //Arrange
        let sut = CheckBoxButton()
        //Act
        sut.cornerRadius = 5
        let cornerRadius = sut.layer.cornerRadius
        let masksToBounds = sut.layer.masksToBounds
        //Assert
        XCTAssertEqual(cornerRadius, 5)
        XCTAssertTrue(masksToBounds)
    }
}

// MARK: - borderColor: UIColor?
extension CheckBoxButtonTests {
    func testBorderColor() {
        //Arrange
        let sut = CheckBoxButton()
        //Act
        sut.borderColor = .black
        let borderWidth = sut.layer.borderWidth
        let borderColor = sut.layer.borderColor
        //Assert
        XCTAssertEqual(borderWidth, 1)
        XCTAssertEqual(borderColor, UIColor.black.cgColor)
    }
}
