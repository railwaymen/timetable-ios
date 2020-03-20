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
    private var restler: RestlerMock!
    
    override func setUp() {
        super.setUp()
        self.restler = RestlerMock()
    }
}

// MARK: - fetchUserProfile(forIdetifier identifier: Int64, completion: @escaping ((Result<UserDecoder, Error>) -> Void))
extension ApiClientUsersTests {
    func testFetchUserSucceed() throws {
        //Arrange
        let data = try self.json(from: UserJSONResource.userFullResponse)
        let decoder = try self.decoder.decode(UserDecoder.self, from: data)
        let sut = self.buildSUT()
        var completionResult: Result<UserDecoder, Error>?
        //Act
        sut.fetchUserProfile(forIdetifier: 2) { result in
            completionResult = result
        }
        try self.restler.getReturnValue.callCompletion(type: UserDecoder.self, result: .success(decoder))
        //Assert
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), decoder)
    }
    
    func testFetchUserFailed() throws {
        //Arrange
        let error = TestError(message: "fetch failed")
        let sut = self.buildSUT()
        var completionResult: Result<UserDecoder, Error>?
        //Act
        sut.fetchUserProfile(forIdetifier: 2) { result in
            completionResult = result
        }
        try self.restler.getReturnValue.callCompletion(type: UserDecoder.self, result: .failure(error))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
}

// MARK: - Private
extension ApiClientUsersTests {
    private func buildSUT() -> ApiClientUsersType {
        ApiClient(restler: self.restler)
    }
}
