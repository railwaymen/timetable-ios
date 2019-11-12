//
//  URLExtensionTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 20/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class URLExtensionTests: XCTestCase {

    func testIsHTTP() throws {
        //Arrange
        let httpURL = try URL(string: "http://www.example.com").unwrap()
        let httpsURL = try URL(string: "https://www.example.com").unwrap()
        let url = try URL(string: "www.example.com").unwrap()
        //Assert
        XCTAssertTrue(httpURL.isHTTP)
        XCTAssertFalse(httpsURL.isHTTP)
        XCTAssertFalse(url.isHTTP)
    }
    
    func testIsHTTPS() throws {
        //Arrange
        let httpURL = try URL(string: "http://www.example.com").unwrap()
        let httpsURL = try URL(string: "https://www.example.com").unwrap()
        let url = try URL(string: "www.example.com").unwrap()
        //Assert
        XCTAssertFalse(httpURL.isHTTPS)
        XCTAssertTrue(httpsURL.isHTTPS)
        XCTAssertFalse(url.isHTTPS)
    }
}
