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

// MARK: - localizedDescription
extension NewVacationEndDateErrorKeyTests {
    func testLocalizedDescription_blank() {
        //Arrange
        let sut: NewVacationValidationError.EndDateErrorKey = .blank
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.newvacation_error_endDate_blank())
    }
}
