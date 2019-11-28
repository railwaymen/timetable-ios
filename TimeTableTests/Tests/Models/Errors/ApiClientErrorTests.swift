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
    
    func testLocalizedDescriptionIfInvalidHostHasBeenGiven() throws {
        //Arrange
        let sut =  ApiClientError(type: .invalidHost(self.exampleURL))
        let expectedResult = String(format: "api.error.invalid_url".localized, self.exampleURL.absoluteString)
        //Act
        let localizedString = sut.type.localizedDescription
        //Assert
        XCTAssertEqual(localizedString, expectedResult)
    }
    
    func testLocalizedDescriptionIfNilHostHasBeenGiven() {
        //Arrange
        let sut = ApiClientError(type: .invalidHost(nil))
        let expectedResult = String(format: "api.error.invalid_url".localized, "")
        //Act
        let localizedString = sut.type.localizedDescription
        //Assert
        XCTAssertEqual(localizedString, expectedResult)
    }
    
    func testLocalizedDescriptionForInvalidParameters() {
        //Arrange
        let sut = ApiClientError(type: .invalidParameters)
        let expectedResult = "api.error.invalid_parameters".localized
        //Act
        let localizedString = sut.type.localizedDescription
        //Assert
        XCTAssertEqual(localizedString, expectedResult)
    }
    
    func testLocalizedDescriptionForInvalidResponse() {
        //Arrange
        let sut = ApiClientError(type: .invalidResponse)
        let expectedResult = "api.error.invalid_response".localized
        //Act
        let localizedString = sut.type.localizedDescription
        //Assert
        XCTAssertEqual(localizedString, expectedResult)
    }
    
    func testLocalizedDescriptionForValidationErrors() throws {
        //Arrange
        let data = try self.json(from: ApiValidationJSONResource.baseErrorKeyResponse)
        let apiValidationErrors = try self.decoder.decode(ApiValidationErrors.self, from: data)
        let sut = ApiClientError(type: .validationErrors(apiValidationErrors))
        //Act
        let localizedString = sut.type.localizedDescription
        //Assert
        XCTAssertEqual(localizedString, "Nie można utworzyć lub edytować wpisu.\nError")
    }
    
    func testLocalizedDescriptionForServerError() throws {
        //Arrange
        let serverError = ServerError(error: "Internal server sut", status: 500)
        let sut = ApiClientError(type: .serverError(serverError))
        //Act
        let localizedString = sut.type.localizedDescription
        //Assert
        XCTAssertEqual(localizedString, "500 - Internal server sut")
    }
    
    func testInitFromDataForTypeOfApiValidationErrors() throws {
        //Arrange
        let data = try self.json(from: ApiValidationJSONResource.baseErrorKeyResponse)
        let apiValidationErrors = try self.decoder.decode(ApiValidationErrors.self, from: data)
        let expectedError = ApiClientError(type: .validationErrors(apiValidationErrors))
        //Act
        let sut = ApiClientError(data: data)
        //Assert
        XCTAssertEqual(sut, expectedError)
    }
    
    func testInitFromDataForTypeOfServerError() throws {
        //Arrange
        let serverError = ServerError(error: "Internal Server Error", status: 500)
        let expectedError = ApiClientError(type: .serverError(serverError))
        let data = try self.json(from: ApiValidationJSONResource.serverErrorResponse)
        //Act
        let sut = ApiClientError(data: data)
        //Assert
        XCTAssertEqual(sut, expectedError)
    }
}
