//
//  ValidationErrorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 11/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
import Restler
@testable import TimeTable

class ValidationErrorTests: XCTestCase {}

// MARK: - Init Restler.Response
extension ValidationErrorTests {
    func testInitializationFromResponse_invalidStatusCode() throws {
        //Arrange
        let data = try self.json(from: ValidationErrorResource.validationErrorFullModelResponse)
        let httpURLResponse = try self.buildHTTPURLResponse(statusCode: 500)
        let response = Restler.Response(data: data, response: httpURLResponse, error: nil)
        //Act
        let sut = ValidationError<RegisterRemoteWorkValidationError>(response: response)
        //Assert
        XCTAssertNil(sut)
    }
    
    func testInitializationFromResponse_nilData() throws {
        //Arrange
        let httpURLResponse = try self.buildHTTPURLResponse(statusCode: 422)
        let response = Restler.Response(data: nil, response: httpURLResponse, error: nil)
        //Act
        let sut = ValidationError<RegisterRemoteWorkValidationError>(response: response)
        //Assert
        XCTAssertNil(sut)
    }
    
    func testInitializationFromResponse_invalidData() throws {
        //Arrange
        let httpURLResponse = try self.buildHTTPURLResponse(statusCode: 422)
        let response = Restler.Response(data: Data(), response: httpURLResponse, error: nil)
        //Act
        let sut = ValidationError<RegisterRemoteWorkValidationError>(response: response)
        //Assert
        XCTAssertNil(sut)
    }
    
    func testInitializationFromResponse_validationErrorIsEmpty() throws {
        //Arrange
        let data = try self.json(from: ValidationErrorResource.validationErrorEmptyValidationErrorResponse)
        let httpURLResponse = try self.buildHTTPURLResponse(statusCode: 422)
        let response = Restler.Response(data: data, response: httpURLResponse, error: nil)
        //Act
        let sut = ValidationError<RegisterRemoteWorkValidationError>(response: response)
        //Assert
        XCTAssertNil(sut)
    }
    
    func testInitializationFromResponse_success() throws {
        //Arrange
        let data = try self.json(from: ValidationErrorResource.validationErrorFullModelResponse)
        let httpURLResponse = try self.buildHTTPURLResponse(statusCode: 422)
        let response = Restler.Response(data: data, response: httpURLResponse, error: nil)
        //Act
        let sut = ValidationError<RegisterRemoteWorkValidationError>(response: response)
        //Assert
        XCTAssertEqual(sut?.errors.startsAt.count, 4)
        XCTAssertEqual(sut?.errors.endsAt.count, 1)
    }
}

// MARK: - Decodable
extension ValidationErrorTests {
    func testDecoding() throws {
        //Arrange
        let data = try self.json(from: ValidationErrorResource.validationErrorFullModelResponse)
        //Act
        let sut = try self.decoder.decode(ValidationError<RegisterRemoteWorkValidationError>.self, from: data)
        //Assert
        XCTAssertEqual(sut.errors.endsAt.count, 1)
        XCTAssertEqual(sut.errors.startsAt.count, 4)
    }
}

// MARK: - Private
extension ValidationErrorTests {
    private func buildHTTPURLResponse(statusCode: Int) throws -> HTTPURLResponse {
        return try XCTUnwrap(HTTPURLResponse(url: self.exampleURL, statusCode: statusCode, httpVersion: nil, headerFields: nil))
    }
}
