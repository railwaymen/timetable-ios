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

// MARK: - localizedDescription
extension NewVacationVacationTypeErrorKeyTests {
    func testLocalizedDescription_blank() {
        //Arrange
        let sut: NewVacationValidationError.VacationTypeErrorKey = .blank
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.newvacation_error_vacationType_blank())
    }
    
    func testLocalizedDescription_inclusion() {
        //Arrange
        let sut: NewVacationValidationError.VacationTypeErrorKey = .inclusion
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.newvacation_error_vacationType_inclusion())
    }
}
