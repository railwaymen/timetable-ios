//
//  ApiClientUsersTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 18/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ApiClientUsersTests: XCTestCase {
    private var networkingMock: NetworkingMock!
    private var requestEncoderMock: RequestEncoderMock!
    private var jsonDecoderMock: JSONDecoderMock!
    
    private enum UserResponse: String, JSONFileResource {
        case userFullResponse
    }
    
    override func setUp() {
        self.networkingMock = NetworkingMock()
        self.requestEncoderMock = RequestEncoderMock()
        self.jsonDecoderMock = JSONDecoderMock()
        super.setUp()
    }
    
    // MARK: - ApiClientSessionType
    func testFetchUserSucceed() throws {
        //Arrange
        let data = try self.json(from: UserResponse.userFullResponse)
        let decoder = try JSONDecoder().decode(UserDecoder.self, from: data)
        var expecdedUserDecoder: UserDecoder?
        let apiClient: ApiClientUsersType = ApiClient(networking: networkingMock, buildEncoder: { () -> RequestEncoderType in
            return requestEncoderMock
        }) { () -> JSONDecoderType in
            return jsonDecoderMock
        }
        //Act
        apiClient.fetchUserProfile(forIdetifier: 2) { result in
            switch result {
            case .success(let userDecoder):
                expecdedUserDecoder = userDecoder
            case .failure:
                XCTFail()
            }
        }
        networkingMock.getCompletion?(.success(data))
        //Assert
        XCTAssertEqual(try expecdedUserDecoder.unwrap(), decoder)
    }
    
    func testFetchUserFailed() throws {
        //Arrange
        var expecdedError: Error?
        let error = TestError(message: "fetch failed")
        let apiClient: ApiClientUsersType = ApiClient(networking: networkingMock, buildEncoder: { () -> RequestEncoderType in
            return requestEncoderMock
        }) { () -> JSONDecoderType in
            return jsonDecoderMock
        }
        //Act
        apiClient.fetchUserProfile(forIdetifier: 2) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expecdedError = error
            }
        }
        networkingMock.getCompletion?(.failure(error))
        //Assert
        let testError = try (expecdedError as? TestError).unwrap()
        XCTAssertEqual(testError, error)
    }
}
