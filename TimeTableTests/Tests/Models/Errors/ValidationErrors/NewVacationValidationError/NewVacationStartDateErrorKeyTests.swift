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

// MARK: - localizedDescription
extension NewVacationStartDateErrorKeyTests {
    func testLocalizedDescription_blank() {
        //Arrange
        let sut = NewVacationValidationError.StartDateErrorKey.blank
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.newvacation_startDate_blank())
    }
    
    func testLocalizedDescription_greaterThanEndDate() {
        //Arrange
        let sut = NewVacationValidationError.StartDateErrorKey.greaterThanEndDate
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.newvacation_startDate_greaterThanEndDate())
    }
}
