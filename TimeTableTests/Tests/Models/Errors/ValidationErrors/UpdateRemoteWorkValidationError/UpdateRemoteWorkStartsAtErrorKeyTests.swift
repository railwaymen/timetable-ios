//
//  UpdateRemoteWorkStartsAtErrorKeyTests.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 14/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class UpdateRemoteWorkStartsAtErrorKeyTests: XCTestCase {}

// MARK: - localizedDescription
extension UpdateRemoteWorkStartsAtErrorKeyTests {
    func testLocalizedDescription_overlap() {
        //Arrange
        let sut: UpdateRemoteWorkValidationError.StartsAtErrorKey = .overlap
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.registerremotework_error_startsAt_overlap())
    }
    
    func testLocalizedDescription_overlapMidnight() {
        //Arrange
        let sut: UpdateRemoteWorkValidationError.StartsAtErrorKey = .overlapMidnight
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.registerremotework_error_startsAt_overlapMidnight())
    }
    
    func testLocalizedDescription_tooOld() {
        //Arrange
        let sut: UpdateRemoteWorkValidationError.StartsAtErrorKey = .tooOld
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.registerremotework_error_startsAt_tooOld())
    }
    
    func testLocalizedDescription_blank() {
        //Arrange
        let sut: UpdateRemoteWorkValidationError.StartsAtErrorKey = .blank
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.registerremotework_error_startsAt_empty())
    }
    
    func testLocalizedDescription_incorrectHours() {
        //Arrange
        let sut: UpdateRemoteWorkValidationError.StartsAtErrorKey = .incorrectHours
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.registerremotework_error_startsAt_incorrectHours())
    }
}
