//
//  StringExtensionTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 07/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class StringExtensionTests: XCTestCase {
    
    func testLocalized() {
        //Arrange
        let testString = "ui.error.invalid_format"
        //Act
        let localized = testString.localized
        //Assert
        XCTAssertEqual(localized, NSLocalizedString(testString, comment: ""))
    }
    
    func testApiSuffix() {
        //Arrange
        let expectedString = "http://example.com/api"
        let firstString = "http://example.com/api/"
        let secondString = "http://example.com/api"
        let thirdString = "http://example.com/"
        let fourthString = "http://example.com"
        let fifthString = "http://example.com/api/v1"
        let sixthString = "http://example.com/api/api/"
        let seventhString = "http://example.com/api/api/api"
        let eighthString = "http://example.com/api/done/api"
        //Act
        let firstStringResult = firstString.apiSuffix()
        let secondStringResult = secondString.apiSuffix()
        let thirdStringResult = thirdString.apiSuffix()
        let fourthStringResult = fourthString.apiSuffix()
        let fifthStringResult = fifthString.apiSuffix()
        let sixthStringResult = sixthString.apiSuffix()
        let seventhStringResult = seventhString.apiSuffix()
        let eighthStringResult = eighthString.apiSuffix()
        //Assert
        XCTAssertEqual(firstStringResult, expectedString)
        XCTAssertEqual(secondStringResult, expectedString)
        XCTAssertEqual(thirdStringResult, expectedString)
        XCTAssertEqual(fourthStringResult, expectedString)
        XCTAssertEqual(fifthStringResult, expectedString)
        XCTAssertEqual(sixthStringResult, expectedString)
        XCTAssertEqual(seventhStringResult, expectedString)
        XCTAssertEqual(eighthStringResult, expectedString)
    }
    
    func testHttpPrefix() {
        //Arrange
        let expectedHTTPString = "http://example.com"
        let expectedHTTPSString = "https://example.com"
        let firstString = "example.com"
        let secondString = "http://example.com"
        let thirdString = "https://example.com"
        //Act
        let firstStringResult = firstString.httpPrefix()
        let secondStringResult = secondString.httpPrefix()
        let thirdStringResult = thirdString.httpPrefix()
        //Assert
        XCTAssertEqual(firstStringResult, expectedHTTPString)
        XCTAssertEqual(secondStringResult, expectedHTTPString)
        XCTAssertEqual(thirdStringResult, expectedHTTPSString)
    }
}
