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

// MARK: - uiError
extension RegisterRemoteWorkStartsAtErrorKeyTests {
    func testUIError_overlap() {
        //Arrange
        let sut = RegisterRemoteWorkValidationError.StartsAtErrorKey.overlap
        //Act
        let uiError = sut.uiError
        //Assert
        XCTAssertEqual(uiError, UIError.remoteWorkStartsAtOvelap)
    }
    
    func testUIError_tooOld() {
        //Arrange
        let sut = RegisterRemoteWorkValidationError.StartsAtErrorKey.tooOld
        //Act
        let uiError = sut.uiError
        //Assert
        XCTAssertEqual(uiError, UIError.remoteWorkStartsAtTooOld)
    }
    
    func testUIError_blank() {
        //Arrange
        let sut = RegisterRemoteWorkValidationError.StartsAtErrorKey.blank
        //Act
        let uiError = sut.uiError
        //Assert
        XCTAssertEqual(uiError, UIError.remoteWorkStartsAtEmpty)
    }
    
    func testUIError_incorrectHours() {
        //Arrange
        let sut = RegisterRemoteWorkValidationError.StartsAtErrorKey.incorrectHours
        //Act
        let uiError = sut.uiError
        //Assert
        XCTAssertEqual(uiError, UIError.remoteWorkStartsAtIncorrectHours)
    }
}
