//
//  NewVacationBaseErrorKeyTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 11/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class NewVacationBaseErrorKeyTests: XCTestCase {}

// MARK: - uiError
extension NewVacationBaseErrorKeyTests {
    func testUIError_blank() {
        //Arrange
        let sut = NewVacationValidationError.BaseErrorKey.workTimeExists
        //Act
        let uiError = sut.uiError
        //Assert
        XCTAssertEqual(uiError, UIError.newVacationBaseWorkTimeExists)
    }
}
