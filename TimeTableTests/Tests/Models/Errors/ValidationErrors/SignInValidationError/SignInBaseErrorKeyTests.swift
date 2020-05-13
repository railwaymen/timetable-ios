//
//  SignInBaseErrorKeyTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 13/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class SignInBaseErrorKeyTests: XCTestCase {}

// MARK: - localizedDescription
extension SignInBaseErrorKeyTests {
    func testLocalizedDescription_invalidEmailOrPassword() {
        //Arrange
        let sut = SignInValidationError.BaseErrorKey.invalidEmailOrPassword
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.credential_error_credentials_invalid())
    }
    
    func testLocalizedDescription_inactive() {
        //Arrange
        let sut = SignInValidationError.BaseErrorKey.inactive
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.credential_error_inactive())
    }
}
