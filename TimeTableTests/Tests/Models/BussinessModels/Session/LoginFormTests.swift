//
//  LoginFormTests.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 04/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class LoginFormTests: XCTestCase {}

// MARK: - validationErrors()
extension LoginFormTests {
    func testValidationErrors_emptyForm_returnsAllErrors() {
        //Arrange
        let sut = LoginForm()
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssertEqual(errors, [.emailEmpty, .passwordEmpty])
        XCTAssertFalse(sut.isValid)
    }
    
    func testValidationErrors_withoutPassword_returnsPasswordEmptyError() {
        //Arrange
        let sut = LoginForm(email: "user")
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssertEqual(errors, [.passwordEmpty])
        XCTAssertFalse(sut.isValid)
    }
    
    func testValidationErrors_withoutEmail_returnsEmailEmptyError() {
        //Arrange
        let sut = LoginForm(password: "password")
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssertEqual(errors, [.emailEmpty])
        XCTAssertFalse(sut.isValid)
    }
    
    func testValidationErrors_filledForm_returnsEmptyArray() {
        //Arrange
        let sut = LoginForm(email: "user", password: "password")
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssert(errors.isEmpty)
        XCTAssert(sut.isValid)
    }
}

// MARK: - generateEncodableObject()
extension LoginFormTests {
    func testGenerateEncodableObject_filledForm_returnsEncodableStructure() throws {
        //Arrange
        let email = "user"
        let password = "password"
        let sut = LoginForm(email: email, password: password)
        //Act
        let object = try sut.generateEncodableObject()
        //Assert
        XCTAssertEqual(object.email, email)
        XCTAssertEqual(object.password, password)
    }
    
    func testGenerateEncodableObject_emptyForm_returnsEncodableStructure() throws {
        //Arrange
        let sut = LoginForm()
        //Act
        XCTAssertThrowsError(try sut.generateEncodableObject()) { error in
            //Assert
            XCTAssertEqual(error as? LoginForm.ValidationError, .emailEmpty)
        }
    }
    
    func testGenerateEncodableObject_emptyPassword_returnsEncodableStructure() throws {
        //Arrange
        let sut = LoginForm(email: "user")
        //Act
        XCTAssertThrowsError(try sut.generateEncodableObject()) { error in
            //Assert
            XCTAssertEqual(error as? LoginForm.ValidationError, .passwordEmpty)
        }
    }
}
