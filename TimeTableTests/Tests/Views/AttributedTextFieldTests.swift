//
//  AttributedTextFieldTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 21/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class AttributedTextFieldTests: XCTestCase {}

// MARK: - placeholderColor: UIColor
extension AttributedTextFieldTests {
    func testPlaceholderColor_placeholderNil() throws {
        //Arrange
        let expectedColor = UIColor.gray
        let sut = AttributedTextField()
        sut.placeholder = nil
        //Act
        sut.placeholderColor = expectedColor
        //Assert
        let color = sut.attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor
        XCTAssertNil(color)
    }
    
    func testPlaceholderColor_placeholderNotNil() throws {
        //Arrange
        let expectedColor = UIColor.gray
        let sut = AttributedTextField()
        sut.placeholder = "text"
        //Act
        sut.placeholderColor = expectedColor
        //Assert
        let color = try XCTUnwrap(sut.attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor)
        XCTAssertEqual(color, expectedColor)
    }
}
