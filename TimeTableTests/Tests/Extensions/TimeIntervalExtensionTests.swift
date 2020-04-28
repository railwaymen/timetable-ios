//
//  TimeIntervalExtensionTests.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 28/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class TimeIntervalExtensionTests: XCTestCase {}

// MARK: - timerBigComponents
extension TimeIntervalExtensionTests {
    func testTimerBigComponents_lessThanMinute() {
        //Arrange
        let sut: TimeInterval = 1
        //Act
        let result = sut.timerBigComponents
        //Assert
        XCTAssertEqual(result.hours, 0)
        XCTAssertEqual(result.minutes, 0)
    }
    
    func testTimerBigComponents_oneMinute() {
        //Arrange
        let sut: TimeInterval = .minute
        //Act
        let result = sut.timerBigComponents
        //Assert
        XCTAssertEqual(result.hours, 0)
        XCTAssertEqual(result.minutes, 1)
    }
    
    func testTimerBigComponents_oneHour() {
        //Arrange
        let sut: TimeInterval = .hour
        //Act
        let result = sut.timerBigComponents
        //Assert
        XCTAssertEqual(result.hours, 1)
        XCTAssertEqual(result.minutes, 0)
    }
    
    func testTimerBigComponents_moreThanDay() {
        //Arrange
        let sut: TimeInterval = (25 * .hour) + (34 * .minute)
        //Act
        let result = sut.timerBigComponents
        //Assert
        XCTAssertEqual(result.hours, 25)
        XCTAssertEqual(result.minutes, 34)
    }
}
