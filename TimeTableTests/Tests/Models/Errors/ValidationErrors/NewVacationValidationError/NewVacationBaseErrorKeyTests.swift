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

// MARK: - localizedDescription
extension NewVacationBaseErrorKeyTests {
    func testLocalizedDescription_blank() {
        //Arrange
        let sut: NewVacationValidationError.BaseErrorKey = .workTimeExists
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.newvacation_error_base_workTimeExists())
    }
}
