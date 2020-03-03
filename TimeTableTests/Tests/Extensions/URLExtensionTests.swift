//
//  URLExtensionTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 20/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class URLExtensionTests: XCTestCase {}

// MARK: - isHTTP: Bool
extension URLExtensionTests {
    func testIsHTTP_withHttpPrefix() throws {
        //Arrange
        let sut = try XCTUnwrap(URL(string: "http://www.example.com"))
        //Act
        let result = sut.isHTTP
        //Assert
        XCTAssertTrue(result)
    }
    
    func testIsHTTP_withHttpsPrefix() throws {
        //Arrange
        let sut = try XCTUnwrap(URL(string: "https://www.example.com"))
        //Act
        let result = sut.isHTTP
        //Assert
        XCTAssertFalse(result)
    }
    
    func testIsHTTP_withoutPrefix() throws {
        //Arrange
        let sut = try XCTUnwrap(URL(string: "www.example.com"))
        //Act
        let result = sut.isHTTP
        //Assert
        XCTAssertFalse(result)
    }
}

// MARK: - isHTTPS: Bool
extension URLExtensionTests {
    func testIsHTTPS_withHttpPrefix() throws {
        //Arrange
        let sut = try XCTUnwrap(URL(string: "http://www.example.com"))
        //Act
        let result = sut.isHTTPS
        //Assert
        XCTAssertFalse(result)
    }
    
    func testIsHTTPS_withHttpsPrefix() throws {
        //Arrange
        let sut = try XCTUnwrap(URL(string: "https://www.example.com"))
        //Act
        let result = sut.isHTTPS
        //Assert
        XCTAssertTrue(result)
    }
    
    func testIsHTTPS_withoutPrefix() throws {
        //Arrange
        let sut = try XCTUnwrap(URL(string: "www.example.com"))
        //Act
        let result = sut.isHTTPS
        //Assert
        XCTAssertFalse(result)
    }
}
