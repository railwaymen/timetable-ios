//
//  SessionDecoderTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 02/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class SessionDecoderTests: XCTestCase {
 
    private enum SessionResponse: String, JSONFileResource {
        case signInResponse
    }
    
    private lazy var decoder = JSONDecoder()
    
    func testParsingSignInResponse() throws {
        //Arrange
        let data = try self.json(from: SessionResponse.signInResponse)
        //Act
        let sessionReponse = try self.decoder.decode(SessionDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sessionReponse.identifier, 1)
        XCTAssertEqual(sessionReponse.firstName, "Admin")
        XCTAssertEqual(sessionReponse.lastName, "Little")
        XCTAssertFalse(sessionReponse.isLeader)
        XCTAssertTrue(sessionReponse.admin)
        XCTAssertFalse(sessionReponse.manager)
        XCTAssertEqual(sessionReponse.token, "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiJiMDhmODZhZi0zNWRhLTQ4ZjIt")
    }
}
