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
    
    override func setUp() {
        self.networkingMock = NetworkingMock()
        self.requestEncoderMock = RequestEncoderMock()
        self.jsonDecoderMock = JSONDecoderMock()
        super.setUp()
    }
    
    // MARK: - ApiClientSessionType
    func testFetchUserSucceed() throws {
        //Arrange
        let data = try self.json(from: UserJSONResource.userFullResponse)
        let decoder = try self.decoder.decode(UserDecoder.self, from: data)
        var expectedUserDecoder: UserDecoder?
        let sut = self.buildSUT()
        //Act
        sut.fetchUserProfile(forIdetifier: 2) { result in
            switch result {
            case .success(let userDecoder):
                expectedUserDecoder = userDecoder
            case .failure:
                XCTFail()
            }
        }
        self.networkingMock.getParams.last?.completion(.success(data))
        //Assert
        XCTAssertEqual(try expectedUserDecoder.unwrap(), decoder)
    }
    
    func testFetchUserFailed() throws {
        //Arrange
        var expectedError: Error?
        let error = TestError(message: "fetch failed")
        let sut = self.buildSUT()
        //Act
        sut.fetchUserProfile(forIdetifier: 2) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        self.networkingMock.getParams.last?.completion(.failure(error))
        //Assert
        let testError = try (expectedError as? TestError).unwrap()
        XCTAssertEqual(testError, error)
    }
}

// MARK: - Private
extension ApiClientUsersTests {
    private func buildSUT() -> ApiClientUsersType {
        ApiClient(networking: self.networkingMock,
                  encoder: self.requestEncoderMock,
                  decoder: self.jsonDecoderMock)
    }
}
