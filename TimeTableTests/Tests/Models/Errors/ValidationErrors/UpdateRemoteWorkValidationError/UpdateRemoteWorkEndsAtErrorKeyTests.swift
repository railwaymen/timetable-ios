//
//  UpdateRemoteWorkEndsAtErrorKeyTests.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 14/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class UpdateRemoteWorkEndsAtErrorKeyTests: XCTestCase {}

// MARK: - localizedDescription
extension UpdateRemoteWorkEndsAtErrorKeyTests {
    func testLocalizedDescription_blank() {
        //Arrange
        let sut: UpdateRemoteWorkValidationError.EndsAtErrorKey = .blank
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.registerremotework_error_endsAt_empty())
    }
}
