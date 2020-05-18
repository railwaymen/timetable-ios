//
//  WorkTimeDurationErrorKeyTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 14/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class WorkTimeDurationErrorKeyTests: XCTestCase {}

// MARK: - localizedDescription
extension WorkTimeDurationErrorKeyTests {
    func testLocalizedDescription_greaterThan() {
        //Arrange
        let sut: WorkTimeValidationError.DurationErrorKey = .greaterThan
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.worktimeform_error_greater_than())
    }
}
