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
    func testLocalizedDescription_invalidHostHasBeenGiven() throws {
        //Arrange
        let sut =  ApiClientError(type: .invalidHost(self.exampleURL))
        let expectedResult = String(format: "api.error.invalid_url".localized, self.exampleURL.absoluteString)
        //Act
        let localizedString = sut.type.localizedDescription
        //Assert
        XCTAssertEqual(localizedString, expectedResult)
    }
    
    func testLocalizedDescription_nilHostHasBeenGiven() {
        //Arrange
        let sut = ApiClientError(type: .invalidHost(nil))
        let expectedResult = String(format: "api.error.invalid_url".localized, "")
        //Act
        let localizedString = sut.type.localizedDescription
        //Assert
        XCTAssertEqual(localizedString, expectedResult)
    }
    
    func testLocalizedDescription_invalidParameters() {
        //Arrange
        let sut = ApiClientError(type: .invalidParameters)
        let expectedResult = "api.error.invalid_parameters".localized
        //Act
        let localizedString = sut.type.localizedDescription
        //Assert
        XCTAssertEqual(localizedString, expectedResult)
    }
    
    func testLocalizedDescription_invalidResponse() {
        //Arrange
        let sut = ApiClientError(type: .invalidResponse)
        let expectedResult = "api.error.invalid_response".localized
        //Act
        let localizedString = sut.type.localizedDescription
        //Assert
        XCTAssertEqual(localizedString, expectedResult)
    }
    
    func testLocalizedDescription_validationErrors() throws {
        //Arrange
        let data = try self.json(from: ApiValidationJSONResource.baseErrorKeyResponse)
        let apiValidationErrors = try self.decoder.decode(ApiValidationErrors.self, from: data)
        let sut = ApiClientError(type: .validationErrors(apiValidationErrors))
        //Act
        let localizedString = sut.type.localizedDescription
        //Assert
        XCTAssertEqual(localizedString, "Nie można utworzyć lub edytować wpisu.\nError")
    }
    
    func testLocalizedDescription_validationErrors_nilApiValidationErrors() throws {
        //Arrange
        let sut = ApiClientError(type: .validationErrors(nil))
        //Act
        let localizedString = sut.type.localizedDescription
        //Assert
        XCTAssertEqual(localizedString, "")
    }
    
    func testLocalizedDescription_serverError() throws {
        //Arrange
        let serverError = try self.serverErrorFactory.build(wrapper: .init(error: "Internal server sut", status: 500))
        let sut = ApiClientError(type: .serverError(serverError))
        //Act
        let localizedString = sut.type.localizedDescription
        //Assert
        XCTAssertEqual(localizedString, "500 - Internal server sut")
    }
    
    func testLocalizedDescription_noConnection() throws {
        //Arrange
        let sut = ApiClientError(type: .noConnection)
        //Act
        let localizedString = sut.type.localizedDescription
        //Assert
        XCTAssertEqual(localizedString, "api.error.no_connection".localized)
    }
    
    func testLocalizedDescription_timeout() throws {
        //Arrange
        let sut = ApiClientError(type: .timeout)
        //Act
        let localizedString = sut.type.localizedDescription
        //Assert
        XCTAssertEqual(localizedString, "api.error.timeout".localized)
    }
}

// MARK: - init?(code: Int)
extension ApiClientErrorTests {
    func testInit_codeNSURLErrorNotConnectedToInternet() {
        //Arrange
        let code = NSURLErrorNotConnectedToInternet
        //Act
        let sut = ApiClientError(code: code)
        //Assert
        XCTAssertEqual(sut?.type, .noConnection)
    }
    
    func testInit_codeNSURLErrorNetworkConnectionLost() {
        //Arrange
        let code = NSURLErrorNetworkConnectionLost
        //Act
        let sut = ApiClientError(code: code)
        //Assert
        XCTAssertEqual(sut?.type, .noConnection)
    }
    
    func testInit_codeNSURLErrorTimedOut() {
        //Arrange
        let code = NSURLErrorTimedOut
        //Act
        let sut = ApiClientError(code: code)
        //Assert
        XCTAssertEqual(sut?.type, .timeout)
    }
    
    func testInit_codeNSURLErrorCannotParseResponse() {
        //Arrange
        let code = NSURLErrorCannotParseResponse
        //Act
        let sut = ApiClientError(code: code)
        //Assert
        XCTAssertEqual(sut?.type, .invalidResponse)
    }
    
    func testInit_codeNSURLErrorBadServerResponse() {
        //Arrange
        let code = NSURLErrorBadServerResponse
        //Act
        let sut = ApiClientError(code: code)
        //Assert
        XCTAssertEqual(sut?.type, .invalidResponse)
    }
    
    func testInit_code422() {
        //Arrange
        let code = 422
        //Act
        let sut = ApiClientError(code: code)
        //Assert
        XCTAssertEqual(sut?.type, .validationErrors(nil))
    }
    
    func testInit_codeOutOfRange() {
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
    func testInitFromData_typeOfApiValidationErrors() throws {
        //Arrange
        let data = try self.json(from: ApiValidationJSONResource.baseErrorKeyResponse)
        let apiValidationErrors = try self.decoder.decode(ApiValidationErrors.self, from: data)
        let expectedError = ApiClientError(type: .validationErrors(apiValidationErrors))
        //Act
        let sut = ApiClientError(data: data)
        //Assert
        XCTAssertEqual(sut, expectedError)
    }
    
    func testInitFromData_typeOfServerError() throws {
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
