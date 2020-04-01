//
//  StringExtensionTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 07/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class StringExtensionTests: XCTestCase {}
    
// MARK: - localized: String
extension StringExtensionTests {
    func testLocalized() {
        //Arrange
        let sut = "ui.error.invalid_format"
        //Act
        let localized = sut.localized
        //Assert
        XCTAssertEqual(localized, NSLocalizedString(sut, comment: ""))
    }
}
    
// MARK: - apiSuffix() -> String
extension StringExtensionTests {
    func testApiSuffix_withApiWithoutSlash() {
        //Arrange
        let sut = "http://example.com/api"
        //Act
        let result = sut.apiSuffix()
        //Assert
        XCTAssertEqual(result, "http://example.com/api")
    }
    
    func testApiSuffix_withApiAndWithSlash() {
        //Arrange
        let sut = "http://example.com/api/"
        //Act
        let result = sut.apiSuffix()
        //Assert
        XCTAssertEqual(result, "http://example.com/api")
    }
    
    func testApiSuffix_withoutApiButWithSlash() {
        //Arrange
        let sut = "http://example.com/"
        //Act
        let result = sut.apiSuffix()
        //Assert
        XCTAssertEqual(result, "http://example.com/api")
    }
    
    func testApiSuffix_withoutApiAndWithoutSlash() {
        //Arrange
        let sut = "http://example.com"
        //Act
        let result = sut.apiSuffix()
        //Assert
        XCTAssertEqual(result, "http://example.com/api")
    }
    
    func testApiSuffix_withApiAndSomeText() {
        //Arrange
        let sut = "http://example.com/api/v1"
        //Act
        let result = sut.apiSuffix()
        //Assert
        XCTAssertEqual(result, "http://example.com/api")
    }
    
    func testApiSuffix_withDoubleApi() {
        //Arrange
        let sut = "http://example.com/api/api/"
        //Act
        let result = sut.apiSuffix()
        //Assert
        XCTAssertEqual(result, "http://example.com/api")
    }
    
    func testApiSuffix_withTripleApi() {
        //Arrange
        let sut = "http://example.com/api/api/api"
        //Act
        let result = sut.apiSuffix()
        //Assert
        XCTAssertEqual(result, "http://example.com/api")
    }
    
    func testApiSuffix_withDoubleApiWithSomeTextBetween() {
        //Arrange
        let sut = "http://example.com/api/done/api/"
        //Act
        let result = sut.apiSuffix()
        //Assert
        XCTAssertEqual(result, "http://example.com/api")
    }
}

// MARK: - func httpPrefix() -> String
extension StringExtensionTests {
    func testHttpPrefix_withoutPrefix() {
        //Arrange
        let sut = "example.com"
        //Act
        let result = sut.httpPrefix()
        //Assert
        XCTAssertEqual(result, "https://example.com")
    }
    
    func testHttpPrefix_withHttpPrefix() {
        //Arrange
        let sut = "http://example.com"
        //Act
        let result = sut.httpPrefix()
        //Assert
        XCTAssertEqual(result, "http://example.com")
    }
    
    func testHttpPrefix_withHttpsPrefix() {
        //Arrange
        let sut = "https://example.com"
        //Act
        let result = sut.httpPrefix()
        //Assert
        XCTAssertEqual(result, "https://example.com")
    }
}
