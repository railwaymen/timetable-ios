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
    private var restler: RestlerMock!
    private var accessService: AccessServiceMock!
    
    override func setUp() {
        super.setUp()
        self.restler = RestlerMock()
        self.accessService = AccessServiceMock()
    }
}

// MARK: - signIn(with credentials: LoginCredentials, completion: @escaping ((Result<SessionDecoder, Error>) -> Void))
extension ApiClientSessionTests {
    func testSignInSucceed() throws {
        //Arrange
        let data = try self.json(from: SessionJSONResource.signInResponse)
        let decoder = try self.decoder.decode(SessionDecoder.self, from: data)
        let parameters = LoginCredentials(email: "user1@example.com", password: "password")
        let sut = self.buildSUT()
        var completionResult: Result<SessionDecoder, Error>?
        //Act
        sut.signIn(with: parameters) { result in
            completionResult = result
        }
        try self.restler.postReturnValue.callCompletion(type: SessionDecoder.self, result: .success(decoder))
        //Assert
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), decoder)
    }
    
    func testSignInFailed() throws {
        //Arrange
        let error = TestError(message: "sign in failed")
        let parameters = LoginCredentials(email: "user1@example.com", password: "password")
        let sut = self.buildSUT()
        var completionResult: Result<SessionDecoder, Error>?
        //Act
        sut.signIn(with: parameters) { result in
            completionResult = result
        }
        try self.restler.postReturnValue.callCompletion(type: SessionDecoder.self, result: .failure(error))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
}

// MARK: - Private
extension ApiClientSessionTests {
    private func buildSUT() -> ApiClientSessionType {
        return ApiClient(
            restler: self.restler,
            accessService: self.accessService)
    }
}
