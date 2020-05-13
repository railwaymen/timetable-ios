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

// MARK: - localizedDescription
extension NewVacationDescriptionErrorKeyTests {
    func testLocalizedDescription_blank() {
        //Arrange
        let sut: NewVacationValidationError.DescriptionErrorKey = .blank
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.newvacation_error_description_blank())
    }
}
