//
//  SignInValidationErrorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 13/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class SignInValidationErrorTests: XCTestCase {}

// MARK: - Decodable
extension SignInValidationErrorTests {
    func testDecoding_emptyBase() throws {
        //Arrange
        let data = try self.json(from: SignInValidationErrorResponse.signInValidationErrorEmptyBase)
        //Act
        let sut = try self.decoder.decode(SignInValidationError.self, from: data)
        //Assert
        XCTAssert(sut.base.isEmpty)
    }
    
    func testDecoding_baseInvalidEmailOrPassword() throws {
        //Arrange
        let data = try self.json(from: SignInValidationErrorResponse.signInValidationErrorBaseInvalidEmailOrPassword)
        //Act
        let sut = try self.decoder.decode(SignInValidationError.self, from: data)
        //Assert
        XCTAssertEqual(sut.base.count, 1)
        XCTAssert(sut.base.contains(.invalidEmailOrPassword))
    }
    
    func testDecoding_baseInactive() throws {
        //Arrange
        let data = try self.json(from: SignInValidationErrorResponse.signInValidationErrorBaseInactive)
        //Act
        let sut = try self.decoder.decode(SignInValidationError.self, from: data)
        //Assert
        XCTAssertEqual(sut.base.count, 1)
        XCTAssert(sut.base.contains(.inactive))
    }
    
    func testDecoding_signInValidationErrorFullModel() throws {
        //Arrange
        let data = try self.json(from: SignInValidationErrorResponse.signInValidationErrorFullModel)
        //Act
        let sut = try self.decoder.decode(SignInValidationError.self, from: data)
        //Assert
        XCTAssertEqual(sut.base.count, 2)
        XCTAssert(sut.base.contains(.invalidEmailOrPassword))
        XCTAssert(sut.base.contains(.inactive))
    }
}

// MARK: - localizedDescription
extension SignInValidationErrorTests {
    func testLocalizedDescription_emptyBase() throws {
        //Arrange
        let sut = try self.buildSUT(type: .signInValidationErrorEmptyBase)
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, "")
    }
    
    func testLocalizedDescription_baseInvalidEmailOrPassword() throws {
        //Arrange
        let sut = try self.buildSUT(type: .signInValidationErrorBaseInvalidEmailOrPassword)
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.credential_error_credentials_invalid())
    }
    
    func testLocalizedDescription_baseInactive() throws {
        //Arrange
        let sut = try self.buildSUT(type: .signInValidationErrorBaseInactive)
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.credential_error_inactive())
    }
    
    func testLocalizedDescription_fullModel() throws {
        //Arrange
        let sut = try self.buildSUT(type: .signInValidationErrorFullModel)
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.credential_error_credentials_invalid())
    }
}

// MARK: - Private
extension SignInValidationErrorTests {
    private func buildSUT(type: SignInValidationErrorResponse) throws -> SignInValidationError {
        let data = try self.json(from: type)
        return try self.decoder.decode(SignInValidationError.self, from: data)
    }
}
