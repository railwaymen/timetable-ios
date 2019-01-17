//
//  ApiClientErrorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 31/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ApiClientErrorTests: XCTestCase {
    
    private enum ApiValidationResponse: String, JSONFileResource {
        case baseErrorKeyResponse
        case serverErrorResponse
    }
    
    private var decoder: JSONDecoder = JSONDecoder()
    
    func testLocalizedDescriptionIfInvalidHostHasBeenGiven() throws {
        //Arrange
        let url = try URL(string: "www.example.com").unwrap()
        let error =  ApiClientError(type: .invalidHost(url))
        let expectedResult = String(format: "api.error.invalid_url".localized, url.absoluteString)
        //Act
        let localizedString = error.type.localizedDescription
        //Assert
        XCTAssertEqual(localizedString, expectedResult)
    }
    
    func testLocalizedDescriptionIfNilHostHasBeenGiven() {
        //Arrange
        let error = ApiClientError(type: .invalidHost(nil))
        let expectedResult = String(format: "api.error.invalid_url".localized, "")
        //Act
        let localizedString = error.type.localizedDescription
        //Assert
        XCTAssertEqual(localizedString, expectedResult)
    }
    
    func testLocalizedDescriptionForInvalidParameters() {
        //Arrange
        let error = ApiClientError(type: .invalidParameters)
        let expectedResult = "api.error.invalid_parameters".localized
        //Act
        let localizedString = error.type.localizedDescription
        //Assert
        XCTAssertEqual(localizedString, expectedResult)
    }
    
    func testLocalizedDescriptionForInvalidResponse() {
        //Arrange
        let error = ApiClientError(type: .invalidResponse)
        let expectedResult = "api.error.invalid_response".localized
        //Act
        let localizedString = error.type.localizedDescription
        //Assert
        XCTAssertEqual(localizedString, expectedResult)
    }
    
    func testLocalizedDescriptionForValidationErrors() throws {
        //Arrange
        let data = try self.json(from: ApiValidationResponse.baseErrorKeyResponse)
        let apiValidationErrors = try decoder.decode(ApiValidationErrors.self, from: data)
        let error = ApiClientError(type: .validationErrors(apiValidationErrors))
        //Act
        let localizedString = error.type.localizedDescription
        //Assert
        XCTAssertEqual(localizedString, "Nie można utworzyć lub edytować wpisu./nError")
    }
    
    func testLocalizedDescriptionForServerError() throws {
        //Arrange
        let serverError = ServerError(error: "Internal server error", status: 500)
        let error = ApiClientError(type: .serverError(serverError))
        //Act
        let localizedString = error.type.localizedDescription
        //Assert
        XCTAssertEqual(localizedString, "500 - Internal server error")
    }
    
    func testInitFromDataForTypeOfApiValidationErrors() throws {
        //Arrange
        let data = try self.json(from: ApiValidationResponse.baseErrorKeyResponse)
        let apiValidationErrors = try decoder.decode(ApiValidationErrors.self, from: data)
        let expectedError = ApiClientError(type: .validationErrors(apiValidationErrors))
        //Act
        let error = ApiClientError(data: data)
        //Assert
        XCTAssertEqual(error, expectedError)
    }
    
    func testInitFromDataForTypeOfServerError() throws {
        //Arrange
        let serverError = ServerError(error: "Internal Server Error", status: 500)
        let expectedError = ApiClientError(type: .serverError(serverError))
        let data = try self.json(from: ApiValidationResponse.serverErrorResponse)
        //Act
        let error = ApiClientError(data: data)
        //Assert
        XCTAssertEqual(error, expectedError)
    }
}
