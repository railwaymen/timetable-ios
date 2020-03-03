//
//  SessionDecoderTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 02/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class SessionDecoderTests: XCTestCase {}
    
// MARK: - Decodable
extension SessionDecoderTests {
    func testParsingSignInResponse() throws {
        //Arrange
        let data = try self.json(from: SessionJSONResource.signInResponse)
        //Act
        let sut = try self.decoder.decode(SessionDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 1)
        XCTAssertEqual(sut.firstName, "Admin")
        XCTAssertEqual(sut.lastName, "Little")
        XCTAssertFalse(sut.isLeader)
        XCTAssertTrue(sut.admin)
        XCTAssertFalse(sut.manager)
        XCTAssertEqual(sut.token, "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiJiMDhmODZhZi0zNWRhLTQ4ZjIt")
    }
}
