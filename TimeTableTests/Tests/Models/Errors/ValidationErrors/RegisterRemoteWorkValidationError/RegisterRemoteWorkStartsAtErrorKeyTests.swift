//
//  RegisterRemoteWorkStartsAtErrorKeyTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 11/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class RegisterRemoteWorkStartsAtErrorKeyTests: XCTestCase {}

// MARK: - localizedDescription
extension RegisterRemoteWorkStartsAtErrorKeyTests {
    func testLocalizedDescription_overlap() {
        //Arrange
        let sut = RegisterRemoteWorkValidationError.StartsAtErrorKey.overlap
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.remotework_startsAt_overlap())
    }
    
    func testLocalizedDescription_tooOld() {
        //Arrange
        let sut = RegisterRemoteWorkValidationError.StartsAtErrorKey.tooOld
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.remotework_startsAt_tooOld())
    }
    
    func testLocalizedDescription_blank() {
        //Arrange
        let sut = RegisterRemoteWorkValidationError.StartsAtErrorKey.blank
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.remotework_startsAt_empty())
    }
    
    func testLocalizedDescription_incorrectHours() {
        //Arrange
        let sut = RegisterRemoteWorkValidationError.StartsAtErrorKey.incorrectHours
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.remotework_startsAt_incorrectHours())
    }
}
