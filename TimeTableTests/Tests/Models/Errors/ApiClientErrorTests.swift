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
    private let serverErrorFactory = ServerErrorFactory()
}

// MARK: - localizedDescription: String
extension ApiClientErrorTests {
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
        let serverError = try self.serverErrorFactory.build(wrapper: .init(error: "Internal server sut", status: 500))
        let sut = ApiClientError(type: .serverError(serverError))
        //Act
        let localizedString = sut.type.localizedDescription
        //Assert
        XCTAssertEqual(localizedString, "500 - Internal server sut")
    }
}

// MARK: - init?(code: Int)
extension ApiClientErrorTests {
    func testInit_CodeNSURLErrorNotConnectedToInternet() {
        //Arrange
        let code = NSURLErrorNotConnectedToInternet
        //Act
        let sut = ApiClientError(code: code)
        //Assert
        XCTAssertEqual(sut?.type, .noConnection)
    }
    
    func testInit_CodeNSURLErrorNetworkConnectionLost() {
        //Arrange
        let code = NSURLErrorNetworkConnectionLost
        //Act
        let sut = ApiClientError(code: code)
        //Assert
        XCTAssertEqual(sut?.type, .noConnection)
    }
    
    func testInit_CodeNSURLErrorTimedOut() {
        //Arrange
        let code = NSURLErrorTimedOut
        //Act
        let sut = ApiClientError(code: code)
        //Assert
        XCTAssertEqual(sut?.type, .timeout)
    }
    
    func testInit_CodeNSURLErrorCannotParseResponse() {
        //Arrange
        let code = NSURLErrorCannotParseResponse
        //Act
        let sut = ApiClientError(code: code)
        //Assert
        XCTAssertEqual(sut?.type, .invalidResponse)
    }
    
    func testInit_CodeNSURLErrorBadServerResponse() {
        //Arrange
        let code = NSURLErrorBadServerResponse
        //Act
        let sut = ApiClientError(code: code)
        //Assert
        XCTAssertEqual(sut?.type, .invalidResponse)
    }
    
    func testInit_Code422() {
        //Arrange
        let code = 422
        //Act
        let sut = ApiClientError(code: code)
        //Assert
        XCTAssertEqual(sut?.type, .validationErrors(nil))
    }
    
    func testInit_CodeOutOfRange() {
        //Arrange
        let code = 0
        //Act
        let sut = ApiClientError(code: code)
        //Assert
        XCTAssertNil(sut)
    }
}

// MARK: - init?(data: Data)
extension ApiClientErrorTests {
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
        let serverError = try self.serverErrorFactory.build(wrapper: .init(error: "Internal Server Error", status: 500))
        let expectedError = ApiClientError(type: .serverError(serverError))
        let data = try self.json(from: ApiValidationJSONResource.serverErrorResponse)
        //Act
        let sut = ApiClientError(data: data)
        //Assert
        XCTAssertEqual(sut, expectedError)
    }
}
