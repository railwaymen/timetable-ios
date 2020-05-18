//
//  WorkTimeTaskErrorKeyTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 14/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class WorkTimeTaskErrorKeyTests: XCTestCase {}

// MARK: - localizedDescription
extension WorkTimeTaskErrorKeyTests {
    func testLocalizedDescription_invalidExternal() {
        //Arrange
        let sut: WorkTimeValidationError.TaskErrorKey = .invalidExternal
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.worktimeform_error_invalid_external())
    }
    
    func testLocalizedDescription_invalidURI() {
        //Arrange
        let sut: WorkTimeValidationError.TaskErrorKey = .invalidURI
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.worktimeform_error_invalid_uri())
    }
}
