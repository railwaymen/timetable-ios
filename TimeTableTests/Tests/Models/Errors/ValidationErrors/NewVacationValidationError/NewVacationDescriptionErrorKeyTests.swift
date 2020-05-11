//
//  NewVacationDescriptionErrorKeyTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 11/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class NewVacationDescriptionErrorKeyTests: XCTestCase {}

// MARK: - DescriptionErrorKey.UIErrorRepresentable
extension NewVacationDescriptionErrorKeyTests {
    func testUIError_blank() {
        //Arrange
        let sut = NewVacationValidationError.DescriptionErrorKey.blank
        //Act
        let uiError = sut.uiError
        //Assert
        XCTAssertEqual(uiError, UIError.newVacationDescriptionBlank)
    }
}
