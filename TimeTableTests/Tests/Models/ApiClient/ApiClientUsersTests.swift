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
//extension ApiClientUsersTests {
//    func testFetchUserSucceed() throws {
//        //Arrange
//        let data = try self.json(from: UserJSONResource.userFullResponse)
//        let decoder = try self.decoder.decode(UserDecoder.self, from: data)
//        var expectedUserDecoder: UserDecoder?
//        let sut = self.buildSUT()
//        //Act
//        sut.fetchUserProfile(forIdetifier: 2) { result in
//            switch result {
//            case .success(let userDecoder):
//                expectedUserDecoder = userDecoder
//            case .failure:
//                XCTFail()
//            }
//        }
//        self.networkingMock.getParams.last?.completion(.success(data))
//        //Assert
//        XCTAssertEqual(try XCTUnwrap(expectedUserDecoder), decoder)
//    }
//    
//    func testFetchUserFailed() throws {
//        //Arrange
//        var expectedError: Error?
//        let error = TestError(message: "fetch failed")
//        let sut = self.buildSUT()
//        //Act
//        sut.fetchUserProfile(forIdetifier: 2) { result in
//            switch result {
//            case .success:
//                XCTFail()
//            case .failure(let error):
//                expectedError = error
//            }
//        }
//        self.networkingMock.getParams.last?.completion(.failure(error))
//        //Assert
//        let testError = try XCTUnwrap(expectedError as? TestError)
//        XCTAssertEqual(testError, error)
//    }
//}

// MARK: - Private
extension ApiClientUsersTests {
    private func buildSUT() -> ApiClientUsersType {
        ApiClient(restler: self.restler)
    }
}
