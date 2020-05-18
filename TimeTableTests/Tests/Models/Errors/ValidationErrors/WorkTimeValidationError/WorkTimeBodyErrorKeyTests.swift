//
//  WorkTimeBodyErrorKeyTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 14/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class WorkTimeBodyErrorKeyTests: XCTestCase {}

// MARK: - localizedDescription
extension WorkTimeBodyErrorKeyTests {
    func testLocalizedDescription_bodyOrTaskBlank() {
        //Arrange
        let sut: WorkTimeValidationError.BodyErrorKey = .bodyOrTaskBlank
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.worktimeform_error_body_or_task_blank())
    }
}
