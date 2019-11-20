//
//  NSRegularExpresionExtensionTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 07/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class NSRegularExpressionExtensionTests: XCTestCase {
    
    func testInitWithPattern() {
        //Arrange
        let testString = "example.com.com.example"
        let pattern = "(?:^|\\W)example(?:$|\\W)"
        let sut = try? NSRegularExpression(pattern: pattern)
        //Act
        let result = sut?.matches(in: testString)
        //Assert
        XCTAssertEqual(result?.count, 2)
    }
}
