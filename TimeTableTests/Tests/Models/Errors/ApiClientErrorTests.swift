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

// MARK: - RestlerErrorDecodable
extension ApiClientErrorTests {
    func testRestlerErrorDecoding_validationErrorInData() throws {
        //Arrange
        let data = try self.json(from: ApiValidationJSONResource.baseErrorKeyResponse)
        let validationErrors = try self.decoder.decode(ApiValidationErrors.self, from: data)
        let response = Restler.Response(data: data, response: nil, error: nil)
        //Act
        let sut = ApiClientError(response: response)
        //Assert
        XCTAssertEqual(sut?.type, .validationErrors(validationErrors))
    }
    
    func testRestlerErrorDecoding_serverErrorInData() throws {
        //Arrange
        let data = try self.json(from: ServerErrorJSONResource.serverErrorFullModel)
        let serverError = try self.decoder.decode(ServerError.self, from: data)
        let response = Restler.Response(data: data, response: nil, error: nil)
        //Act
        let sut = ApiClientError(response: response)
        //Assert
        XCTAssertEqual(sut?.type, .serverError(serverError))
    }
    
    func testRestlerErrorDecoding_responseCode401() throws {
        //Arrange
        let statusCode = 401
        let httpResponse = HTTPURLResponse(url: self.exampleURL, statusCode: statusCode, httpVersion: nil, headerFields: [:])
        let response = Restler.Response(data: nil, response: httpResponse, error: nil)
        //Act
        let sut = ApiClientError(response: response)
        //Assert
        XCTAssertEqual(sut?.type, .unauthorized)
    }
    
    func testRestlerErrorDecoding_responseCode422() throws {
        //Arrange
        let statusCode = 422
        let httpResponse = HTTPURLResponse(url: self.exampleURL, statusCode: statusCode, httpVersion: nil, headerFields: [:])
        let response = Restler.Response(data: nil, response: httpResponse, error: nil)
        //Act
        let sut = ApiClientError(response: response)
        //Assert
        XCTAssertEqual(sut?.type, .validationErrors(nil))
    }
    
    func testRestlerErrorDecoding_responseCode502() throws {
        //Arrange
        let statusCode = 502
        let httpResponse = HTTPURLResponse(url: self.exampleURL, statusCode: statusCode, httpVersion: nil, headerFields: [:])
        let response = Restler.Response(data: nil, response: httpResponse, error: nil)
        //Act
        let sut = ApiClientError(response: response)
        //Assert
        XCTAssertNil(sut)
    }
    
    func testRestlerErrorDecoding_NSURLErrorNotConnectedToInternet() throws {
        //Arrange
        let errorCode = NSURLErrorNotConnectedToInternet
        let error = NSError(domain: "Test", code: errorCode, userInfo: nil)
        let response = Restler.Response(data: nil, response: nil, error: error)
        //Act
        let sut = ApiClientError(response: response)
        //Assert
        XCTAssertEqual(sut?.type, .noConnection)
    }
    
    func testRestlerErrorDecoding_NSURLErrorNetworkConnectionLost() throws {
        //Arrange
        let errorCode = NSURLErrorNetworkConnectionLost
        let error = NSError(domain: "Test", code: errorCode, userInfo: nil)
        let response = Restler.Response(data: nil, response: nil, error: error)
        //Act
        let sut = ApiClientError(response: response)
        //Assert
        XCTAssertEqual(sut?.type, .noConnection)
    }
    
    func testRestlerErrorDecoding_NSURLErrorTimedOut() throws {
        //Arrange
        let errorCode = NSURLErrorTimedOut
        let error = NSError(domain: "Test", code: errorCode, userInfo: nil)
        let response = Restler.Response(data: nil, response: nil, error: error)
        //Act
        let sut = ApiClientError(response: response)
        //Assert
        XCTAssertEqual(sut?.type, .timeout)
    }
    
    func testRestlerErrorDecoding_NSURLErrorCannotParseResponse() throws {
        //Arrange
        let errorCode = NSURLErrorCannotParseResponse
        let error = NSError(domain: "Test", code: errorCode, userInfo: nil)
        let response = Restler.Response(data: nil, response: nil, error: error)
        //Act
        let sut = ApiClientError(response: response)
        //Assert
        XCTAssertEqual(sut?.type, .invalidResponse)
    }
    
    func testRestlerErrorDecoding_NSURLErrorBadServerResponse() throws {
        //Arrange
        let errorCode = NSURLErrorBadServerResponse
        let error = NSError(domain: "Test", code: errorCode, userInfo: nil)
        let response = Restler.Response(data: nil, response: nil, error: error)
        //Act
        let sut = ApiClientError(response: response)
        //Assert
        XCTAssertEqual(sut?.type, .invalidResponse)
    }
    
    func testRestlerErrorDecoding_nilResponse() throws {
        //Arrange
        let response = Restler.Response(data: nil, response: nil, error: nil)
        //Act
        let sut = ApiClientError(response: response)
        //Assert
        XCTAssertNil(sut)
    }
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
        XCTAssertEqual(localizedString, "api_validation_error.overlap".localized)
    }
    
    func testLocalizedDescription_validationErrors_nilApiValidationErrors() throws {
        //Arrange
        let sut = ApiClientError(type: .validationErrors(nil))
        //Act
        let localizedString = sut.type.localizedDescription
        //Assert
        XCTAssertEqual(localizedString, "ui.error.generic_error".localized)
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
