//
//  ApiClientErrorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 31/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
import Restler
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
