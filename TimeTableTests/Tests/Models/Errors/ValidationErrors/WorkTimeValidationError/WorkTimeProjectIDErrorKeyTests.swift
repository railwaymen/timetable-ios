//
//  WorkTimeProjectIDErrorKeyTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 14/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class WorkTimeProjectIDErrorKeyTests: XCTestCase {}

// MARK: - localizedDescription
extension WorkTimeProjectIDErrorKeyTests {
    func testLocalizedDescription_greaterThan() {
        //Arrange
        let sut: WorkTimeValidationError.ProjectIDErrorKey = .blank
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.worktimeform_error_blank())
    }
}
