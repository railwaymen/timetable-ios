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
        let sut = UIError.cannotBeEmpty(.serverAddressTextField)
        let expectedResult = UIElement.serverAddressTextField.rawValue.localized + " " + "ui.error.cannot_be_empty".localized
        //Act
        let localizedString = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedString, expectedResult)
    }
    
    func testLocalizedDescriptionIfInvalidFormatIsCalled() {
        //Arrange
        let sut = UIError.invalidFormat(.serverAddressTextField)
        let expectedResult = UIElement.serverAddressTextField.rawValue.localized + " " + "ui.error.invalid_format".localized
        //Act
        let localizedString = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedString, expectedResult)
    }
    
    func testLocalizedDescriptionIfTimeGreaterThan() {
        //Arrange
        let sut = UIError.timeGreaterThan
        let expectedResult = "ui.error.time_greater_than".localized
        //Act
        let localizedString = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedString, expectedResult)
    }
    
    func testEquatableForCannotBeEmptyWhileElementsAreEqual() {
        //Arrange
        let sut1 = UIError.cannotBeEmpty(.loginTextField)
        let sut2 = UIError.cannotBeEmpty(.loginTextField)
        //Assert
        XCTAssertEqual(sut1, sut2)
    }
    
    func testEquatableForCannotBeEmptyWhileElementsAreNotEqual() {
        //Arrange
        let sut1 = UIError.cannotBeEmpty(.loginTextField)
        let sut2 = UIError.cannotBeEmpty(.passwordTextField)
        //Assert
        XCTAssertNotEqual(sut1, sut2)
    }

    func testEquatableForCannotBeEmptyAndInvalidFormantUIErrors() {
        //Arrange
        let sut1 = UIError.cannotBeEmpty(.loginTextField)
        let sut2 = UIError.invalidFormat(.loginTextField)
        //Assert
        XCTAssertNotEqual(sut1, sut2)
    }
    
    func testEquatableForInvalidFormatWhileElementsAreEqual() {
        //Arrange
        let sut1 = UIError.invalidFormat(.loginTextField)
        let sut2 = UIError.invalidFormat(.loginTextField)
        //Assert
        XCTAssertEqual(sut1, sut2)
    }
    
    func testEquatableForInvalidFormatWhileElementsAreNotEqual() {
        //Arrange
        let sut1 = UIError.invalidFormat(.loginTextField)
        let sut2 = UIError.invalidFormat(.passwordTextField)
        //Assert
        XCTAssertNotEqual(sut1, sut2)
    }
}
