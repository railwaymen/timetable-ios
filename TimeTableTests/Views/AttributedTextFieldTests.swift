//
//  AttributedTextFieldTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 21/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class AttributedTextFieldTests: XCTestCase {
    
    func testPlaceholderColor() throws {
        //Arrange
        let expectedColor = UIColor.gray
        let attributedTextField = AttributedTextField()
        attributedTextField.placeholder = "text"
        //Act
        attributedTextField.placeholderColor = expectedColor
        //Assert
        let color = try (attributedTextField.attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor).unwrap()
        XCTAssertEqual(color, expectedColor)
    }
}
