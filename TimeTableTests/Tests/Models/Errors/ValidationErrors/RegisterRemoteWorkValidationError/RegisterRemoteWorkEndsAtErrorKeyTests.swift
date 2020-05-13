//
//  RegisterRemoteWorkEndsAtErrorKeyTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 11/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class RegisterRemoteWorkEndsAtErrorKeyTests: XCTestCase {}

// MARK: - localizedDescription
extension RegisterRemoteWorkEndsAtErrorKeyTests {
    func testLocalizedDescription_blank() {
        //Arrange
        let sut = RegisterRemoteWorkValidationError.EndsAtErrorKey.blank
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.remotework_endsAt_empty())
    }
}
