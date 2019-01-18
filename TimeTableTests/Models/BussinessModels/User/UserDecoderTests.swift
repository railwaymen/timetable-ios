//
//  UserDecoderTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 18/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class UserDecoderTests: XCTestCase {
    
    private enum UserResponse: String, JSONFileResource {
        case userFullResponse
    }
    
    private lazy var decoder = JSONDecoder()
    
    func testParsingUserFullResponse() throws {
        //Arrange
        let data = try self.json(from: UserResponse.userFullResponse)
        //Act
        let sessionReponse = try decoder.decode(UserDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sessionReponse.firstName, "John")
        XCTAssertEqual(sessionReponse.lastName, "Little")
        XCTAssertEqual(sessionReponse.email, "john.little@example.com")
    }
}
