//
//  LoginContentProviderTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 08/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class LoginContentProviderTests: XCTestCase {
    private var apiClientMock: ApiClientMock!
    private var accessServiceMock: AccessServiceMock!
        
    override func setUp() {
        super.setUp()
        self.apiClientMock = ApiClientMock()
        self.accessServiceMock = AccessServiceMock()
    }
}

// MARK: - closeSession()
extension LoginContentProviderTests {
    func testCloseSession() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.closeSession()
        //Assert
        XCTAssertEqual(self.accessServiceMock.closeSessionParams.count, 1)
    }
}

// MARK: - login(with:fetchCompletion:saveCompletion:)
extension LoginContentProviderTests {
    func testLogin_fetchingError_callsCompletionWithProperError() throws {
        //Arrange
        let expectedError = ApiClientError(type: .invalidParameters)
        let loginCredentials = LoginCredentials(email: "user@example.com", password: "password")
        let sut = self.buildSUT()
        var completionResult: Result<SessionDecoder, Error>?
        //Act
        sut.login(with: loginCredentials, shouldSaveUser: true) { result in
            completionResult = result
        }
        try XCTUnwrap(self.apiClientMock.signInParams.last).completion(.failure(expectedError))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: expectedError)
    }
    
    func testLogin_success_callsCompletionWithSession() throws {
        //Arrange
        let loginCredentials = LoginCredentials(email: "user@example.com", password: "password")
        let sut = self.buildSUT()
        let session = try SessionDecoderFactory().build()
        var completionResult: Result<SessionDecoder, Error>?
        //Act
        sut.login(with: loginCredentials, shouldSaveUser: true) { result in
            completionResult = result
        }
        try XCTUnwrap(self.apiClientMock.signInParams.last).completion(.success(session))
        //Assert
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), session)
    }
}

// MARK: - Private
extension LoginContentProviderTests {
    private func buildSUT() -> LoginContentProvider {
        return LoginContentProvider(
            apiClient: self.apiClientMock,
            accessService: self.accessServiceMock)
    }
}
