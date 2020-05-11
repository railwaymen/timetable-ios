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

// MARK: - EndsAtErrorKey.UIErrorRepresentable
extension RegisterRemoteWorkEndsAtErrorKeyTests {
    func testUIError_blank() {
        //Arrange
        let sut = RegisterRemoteWorkValidationError.EndsAtErrorKey.blank
        //Act
        let uiError = sut.uiError
        //Assert
        XCTAssertEqual(uiError, UIError.remoteWorkEndsAtEmpty)
    }
}
