//
//  WorkTimeStartsAtErrorKeyTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 14/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class WorkTimeStartsAtErrorKeyTests: XCTestCase {}

// MARK: - localizedDescription
extension WorkTimeStartsAtErrorKeyTests {
    func testLocalizedDescription_noGapsToFill() {
        //Arrange
        let sut: WorkTimeValidationError.StartsAtErrorKey = .noGapsToFill
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.worktimeform_error_no_gaps_to_fill())
    }
    
    func testLocalizedDescription_overlap() {
        //Arrange
        let sut: WorkTimeValidationError.StartsAtErrorKey = .overlap
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.worktimeform_error_overlap())
    }
    
    func testLocalizedDescription_overlapMidnight() {
        //Arrange
        let sut: WorkTimeValidationError.StartsAtErrorKey = .overlapMidnight
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.worktimeform_error_overlap_midnight())
    }
    
    func testLocalizedDescription_tooOld() {
        //Arrange
        let sut: WorkTimeValidationError.StartsAtErrorKey = .tooOld
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.worktimeform_error_too_old())
    }
}
