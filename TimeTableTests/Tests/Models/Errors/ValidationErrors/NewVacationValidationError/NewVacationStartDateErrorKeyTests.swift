//
//  NewVacationStartDateErrorKeyTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 11/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class NewVacationStartDateErrorKeyTests: XCTestCase {}

// MARK: - uiError
extension NewVacationStartDateErrorKeyTests {
    func testUIError_blank() {
        //Arrange
        let sut = NewVacationValidationError.StartDateErrorKey.blank
        //Act
        let uiError = sut.uiError
        //Assert
        XCTAssertEqual(uiError, UIError.newVacationStartDateBlank)
    }
    
    func testUIError_greaterThanEndDate() {
        //Arrange
        let sut = NewVacationValidationError.StartDateErrorKey.greaterThanEndDate
        //Act
        let uiError = sut.uiError
        //Assert
        XCTAssertEqual(uiError, UIError.newVacationStartDateGreaterThanEndDate)
    }
}
