//
//  NewVacationVacationTypeErrorKeyTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 11/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class NewVacationVacationTypeErrorKeyTests: XCTestCase {}

// MARK: - uiError
extension NewVacationVacationTypeErrorKeyTests {
    func testUIError_blank() {
        //Arrange
        let sut = NewVacationValidationError.VacationTypeErrorKey.blank
        //Act
        let uiError = sut.uiError
        //Assert
        XCTAssertEqual(uiError, UIError.newVacationVacationTypeBlank)
    }
    
    func testUIError_inclusion() {
        //Arrange
        let sut = NewVacationValidationError.VacationTypeErrorKey.inclusion
        //Act
        let uiError = sut.uiError
        //Assert
        XCTAssertEqual(uiError, UIError.newVacationVacationTypeInclusion)
    }
}
