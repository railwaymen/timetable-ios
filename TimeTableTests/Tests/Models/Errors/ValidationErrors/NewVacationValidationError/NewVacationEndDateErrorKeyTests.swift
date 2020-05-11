//
//  NewVacationEndDateErrorKeyTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 11/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class NewVacationEndDateErrorKeyTests: XCTestCase {}

// MARK: - EndDateErrorKey.UIErrorRepresentable
extension NewVacationEndDateErrorKeyTests {
    func testUIError_blank() {
        //Arrange
        let sut = NewVacationValidationError.EndDateErrorKey.blank
        //Act
        let uiError = sut.uiError
        //Assert
        XCTAssertEqual(uiError, UIError.newVacationEndDateBlank)
    }
}
