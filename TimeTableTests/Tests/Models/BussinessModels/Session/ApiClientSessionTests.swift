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
    
    override func setUp() {
        super.setUp()
        self.networkingMock = NetworkingMock()
        self.requestEncoderMock = RequestEncoderMock()
        self.jsonDecoderMock = JSONDecoderMock()
    }
    
    // MARK: - ApiClientSessionType
    func testSignInSucceed() throws {
        //Arrange
        let data = try self.json(from: SessionJSONResource.signInResponse)
        let decoder = try self.decoder.decode(SessionDecoder.self, from: data)
        var expectedSessionDecoder: SessionDecoder?
        let parameters = LoginCredentials(email: "user1@example.com", password: "password")
        let sut = self.buildSUT()
        //Act
        sut.signIn(with: parameters) { result in
            switch result {
            case .success(let sessionDecoder):
                expectedSessionDecoder = sessionDecoder
            case .failure:
                XCTFail()
            }
        }
        self.networkingMock.postParams.last?.completion(.success(data))
        //Assert
        XCTAssertEqual(try expectedSessionDecoder.unwrap(), decoder)
    }
    
    func testSignInFailed() throws {
        //Arrange
        var expectedError: Error?
        let error = TestError(message: "sign in failed")
        let parameters = LoginCredentials(email: "user1@example.com", password: "password")
        let sut = self.buildSUT()
        //Act
        sut.signIn(with: parameters) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        self.networkingMock.postParams.last?.completion(.failure(error))
        //Assert
        let testError = try (expectedError as? TestError).unwrap()
        XCTAssertEqual(testError, error)
    }
}

// MARK: - Private
extension ApiClientSessionTests {
    private func buildSUT() -> ApiClientSessionType {
        return ApiClient(
            networking: self.networkingMock,
            encoder: self.requestEncoderMock,
            decoder: self.jsonDecoderMock)
    }
}
