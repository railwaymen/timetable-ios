//
//  ApiClientSessionTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ApiClientSessionTests: XCTestCase {
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
    
    // MARK: - ApiClientSessionType
    func testSignInSucced() throws {
        //Arrange
        let data = try self.json(from: SessionResponse.signInResponse)
        let decoder = try JSONDecoder().decode(SessionDecoder.self, from: data)
        var expecdedSessionDecoder: SessionDecoder?
        let parameters = LoginCredentials(email: "user1@example.com", password: "password")
        let apiClient: ApiClientSessionType = ApiClient(networking: networkingMock, buildEncoder: { () -> RequestEncoderType in
            return requestEncoderMock
        }) { () -> JSONDecoderType in
            return jsonDecoderMock
        }
        //Act
        apiClient.signIn(with: parameters) { result in
            switch result {
            case .success(let sessionDecoder):
                expecdedSessionDecoder = sessionDecoder
            case .failure:
                XCTFail()
            }
        }
        networkingMock.shortPostCompletion?(.success(data))
        //Assert
        XCTAssertEqual(try expecdedSessionDecoder.unwrap(), decoder)
    }
    
    func testSignInFailed() throws {
        //Arrange
        var expecdedError: Error?
        let error = TestError(message: "sign in failed")
        let parameters = LoginCredentials(email: "user1@example.com", password: "password")
        let apiClient: ApiClientSessionType = ApiClient(networking: networkingMock, buildEncoder: { () -> RequestEncoderType in
            return requestEncoderMock
        }) { () -> JSONDecoderType in
            return jsonDecoderMock
        }
        //Act
        apiClient.signIn(with: parameters) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expecdedError = error
            }
        }
        networkingMock.shortPostCompletion?(.failure(error))
        //Assert
        let testError = try (expecdedError as? TestError).unwrap()
        XCTAssertEqual(testError, error)
    }
}
