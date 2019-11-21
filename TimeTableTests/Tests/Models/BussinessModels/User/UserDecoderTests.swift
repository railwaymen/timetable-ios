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
    private lazy var decoder = JSONDecoder()
    
    func testParsingUserFullResponse() throws {
        //Arrange
        let data = try self.json(from: UserJSONResource.userFullResponse)
        //Act
        let sut = try self.decoder.decode(UserDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.firstName, "John")
        XCTAssertEqual(sut.lastName, "Little")
        XCTAssertEqual(sut.email, "john.little@example.com")
    }
}
