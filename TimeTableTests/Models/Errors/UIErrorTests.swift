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
    
    func testLocalizedDescriptionIfTimeGreaterThan() {
        //Arrange
        let error = UIError.timeGreaterThan
        let expectedResult = "ui.error.time_greater_than".localized
        //Act
        let localizedString = error.localizedDescription
        //Assert
        XCTAssertEqual(localizedString, expectedResult)
    }
    
    func testEquatableForCannotBeEmptyWhileElementsAreEqual() {
        //Arrange
        let firstUIError = UIError.cannotBeEmpty(.loginTextField)
        let secondUIError = UIError.cannotBeEmpty(.loginTextField)
        //Assert
        XCTAssertEqual(firstUIError, secondUIError)
    }
    
    func testEquatableForCannotBeEmptyWhileElementsAreNotEqual() {
        //Arrange
        let firstUIError = UIError.cannotBeEmpty(.loginTextField)
        let secondUIError = UIError.cannotBeEmpty(.passwordTextField)
        //Assert
        XCTAssertNotEqual(firstUIError, secondUIError)
    }

    func testEquatableForCannotBeEmptyAndInvalidFormantUIErrors() {
        //Arrange
        let firstUIError = UIError.cannotBeEmpty(.loginTextField)
        let secondUIError = UIError.invalidFormat(.loginTextField)
        //Assert
        XCTAssertNotEqual(firstUIError, secondUIError)
    }
    
    func testEquatableForInvalidFormatWhileElementsAreEqual() {
        //Arrange
        let firstUIError = UIError.invalidFormat(.loginTextField)
        let secondUIError = UIError.invalidFormat(.loginTextField)
        //Assert
        XCTAssertEqual(firstUIError, secondUIError)
    }
    
    func testEquatableForInvalidFormatWhileElementsAreNotEqual() {
        //Arrange
        let firstUIError = UIError.invalidFormat(.loginTextField)
        let secondUIError = UIError.invalidFormat(.passwordTextField)
        //Assert
        XCTAssertNotEqual(firstUIError, secondUIError)
    }
}
