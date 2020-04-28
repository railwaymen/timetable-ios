//
//  IntExtensionTests.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 28/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class IntExtensionTests: XCTestCase {}

// MARK: - description(minimumDigitsCount:)
extension IntExtensionTests {
    func testDescriptionWithMinimumDigitsCount_lessDigitsThanMinimum() {
        //Arrange
        let sut = 24
        //Act
        let result = sut.description(minimumDigitsCount: 4)
        //Assert
        XCTAssertEqual(result, "0024")
    }
    
    func testDescriptionWithMinimumDigitsCount_moreDigitsThanMinimum() {
        //Arrange
        let sut = 24047
        //Act
        let result = sut.description(minimumDigitsCount: 4)
        //Assert
        XCTAssertEqual(result, "24047")
    }
    
    func testDescriptionWithMinimumDigitsCount_equalDigitsCountAsMinimum() {
        //Arrange
        let sut = 2404
        //Act
        let result = sut.description(minimumDigitsCount: 4)
        //Assert
        XCTAssertEqual(result, "2404")
    }
}
