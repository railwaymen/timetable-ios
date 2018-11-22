//
//  ApiClientTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 06/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ApiClientTests: XCTestCase {
    private var networkingMock: NetworkingMock!
    private var requestEncoderMock: RequestEncoderMock!
    private var jsonDecoderMock: JSONDecoderMock!
    
    private enum SessionResponse: String, JSONFileResource {
        case signInResponse
    }
    
    override func setUp() {
        self.networkingMock = NetworkingMock()
        self.requestEncoderMock = RequestEncoderMock()
        self.jsonDecoderMock = JSONDecoderMock()
        super.setUp()
    }

    // MARK: - ApiClientNetworkingType
    func testPostRetunrsAnErrorWhileGivenWrapperCannotBeEncodedToDictionary() {
        //Arrange
        var expectedError: Error?
        let apiClient = ApiClient(networking: networkingMock, buildEncoder: { () -> RequestEncoderType in
            return requestEncoderMock
        }) { () -> JSONDecoderType in
            return jsonDecoderMock
        }
        let parameters = LoginCredentials(email: "user1@example.com", password: "password")
        requestEncoderMock.isEncodeToDictionaryThrowingError = true
        //Act
        apiClient.post(Endpoints.signIn, parameters: parameters) { (result: TimeTable.Result<SessionDecoder>) in
            switch result {
            case .success: XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        //Assert
        switch expectedError as? ApiClientError {
        case .invalidParameters?: break
        default: XCTFail()
        }
    }
    
    func testPostReturnsAnErrorWhileNetworkRequestFailed() throws {
        //Arrange
        var expectedError: Error?
        let error = TestError(messsage: "500 - server internal error")
        let parameters = LoginCredentials(email: "user1@example.com", password: "password")
        let apiClient = ApiClient(networking: networkingMock, buildEncoder: { () -> RequestEncoderType in
            return requestEncoderMock
        }) { () -> JSONDecoderType in
            return jsonDecoderMock
        }
        //Act
        apiClient.post(Endpoints.signIn, parameters: parameters) { (result: TimeTable.Result<SessionDecoder>) in
            switch result {
            case .success: XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        networkingMock.shortPostCompletion?(.failure(error))
        //Assert
        let testError = try (expectedError as? TestError).unwrap()
        XCTAssertEqual(testError, error)
    }
    
    func testPostRetrunsCorrectDecodableObject() throws {
        //Arrange
        var expectedDecoder: Decodable?
        let parameters = LoginCredentials(email: "user1@example.com", password: "password")
        let data = try self.json(from: SessionResponse.signInResponse)
        let apiClient = ApiClient(networking: networkingMock, buildEncoder: { () -> RequestEncoderType in
            return requestEncoderMock
        }) { () -> JSONDecoderType in
            return jsonDecoderMock
        }
        //Act
        apiClient.post(Endpoints.signIn, parameters: parameters) { (result: TimeTable.Result<SessionDecoder>) in
            switch result {
            case .success(let decoder):
                expectedDecoder = decoder
            case .failure:
                XCTFail()
            }
        }
        networkingMock.shortPostCompletion?(.success(data))
        //Assert
        let decoder = try (expectedDecoder as? SessionDecoder).unwrap()
        XCTAssertEqual(decoder.identifier, 1)
        XCTAssertEqual(decoder.firstName, "Admin")
        XCTAssertEqual(decoder.lastName, "Little")
        XCTAssertFalse(decoder.isLeader)
        XCTAssertTrue(decoder.admin)
        XCTAssertFalse(decoder.manager)
        XCTAssertEqual(decoder.token, "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiJiMDhmODZhZi0zNWRhLTQ4ZjIt")
    }
    
    func testPostReturnsAnErrorWhileResponseJSONIsInvalid() throws {
        //Arrange
        var expectedError: Error?
        let parameters = LoginCredentials(email: "user1@example.com", password: "password")
        let data = try JSONSerialization.data(withJSONObject: ["test": "test"], options: .prettyPrinted)
        let apiClient = ApiClient(networking: networkingMock, buildEncoder: { () -> RequestEncoderType in
            return requestEncoderMock
        }) { () -> JSONDecoderType in
            return jsonDecoderMock
        }
        //Act
        apiClient.post(Endpoints.signIn, parameters: parameters) { (result: TimeTable.Result<SessionDecoder>) in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
                
            }
        }
        networkingMock.shortPostCompletion?(.success(data))
        //Assert
        switch expectedError as? ApiClientError {
        case .invalidResponse?: break
        default: XCTFail()
        }
    }
}
