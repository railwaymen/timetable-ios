//
//  UIErrorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 26/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class UIErrorTests: XCTestCase {

    func testLocalizedDescriptionIfCannotBeErrorIsCalled() {
        //Arrange
        let error = UIError.cannotBeEmpty(.serverAddressTextField)
        let expectedResult = UIElement.serverAddressTextField.rawValue.localized + " " + "ui.error.cannot_be_empty".localized
        //Act
        let localizedString = error.localizedDescription
        //Assert
        XCTAssertEqual(localizedString, expectedResult)
    }
    
    func testLocalizedDescriptionIfInvalidFormatIsCalled() {
        //Arrange
        let error = UIError.invalidFormat(.serverAddressTextField)
        let expectedResult = UIElement.serverAddressTextField.rawValue.localized + " " + "ui.error.invalid_format".localized
        //Act
        let localizedString = error.localizedDescription
        //Assert
        XCTAssertEqual(localizedString, expectedResult)
    }
}
