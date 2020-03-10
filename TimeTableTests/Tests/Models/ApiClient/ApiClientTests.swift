//
//  ApiClientTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 06/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ApiClientTests: XCTestCase {
    private var restler: RestlerMock!

    override func setUp() {
        super.setUp()
        self.restler = RestlerMock()
    }
}

// MARK: - setAuthenticationToken(_ token: String)
extension ApiClientTests {
    func testSetAuthenticationToken_emptyString() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.setAuthenticationToken("")
        //Assert
        XCTAssertEqual(self.restler.header[.custom("token")], "")
    }
    
    func testSetAuthenticationToken_testString() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.setAuthenticationToken("token_123")
        //Assert
        XCTAssertEqual(self.restler.header[.custom("token")], "token_123")
    }
}

// MARK: - removeAuthenticationToken()
extension ApiClientTests {
    func testRemoveAuthenticationToken() {
        //Arrange
        let sut = self.buildSUT()
        sut.setAuthenticationToken("token_123")
        XCTAssertEqual(self.restler.header[.custom("token")], "token_123")
        //Act
        sut.removeAuthenticationToken()
        //Assert
        XCTAssertNil(self.restler.header[.custom("token")])
    }
}

// MARK: - Private
extension ApiClientTests {
    private func buildSUT() -> ApiClient {
        return ApiClient(restler: self.restler)
    }
}
