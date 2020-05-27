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

// MARK: - quarter(of interval: TimeInterval)
extension TimeIntervalExtensionTests {
    func testQuater_zero() {
        //Arrange
        let sut: TimeInterval = 0
        //Act
        let result = TimeInterval.quarter(of: sut)
        //Assert
        XCTAssertEqual(result, 0)
    }
    
    func testQuater_minute() {
        //Arrange
        let sut: TimeInterval = .minute
        //Act
        let result = TimeInterval.quarter(of: sut)
        //Assert
        XCTAssertEqual(result, 15)
    }
    
    func testQuater_hour() {
        //Arrange
        let sut: TimeInterval = .hour
        //Act
        let result = TimeInterval.quarter(of: sut)
        //Assert
        XCTAssertEqual(result, 900)
    }
    
    func testQuater_day() {
        //Arrange
        let sut: TimeInterval = .day
        //Act
        let result = TimeInterval.quarter(of: sut)
        //Assert
        XCTAssertEqual(result, 21_600)
    }
}

// MARK: - half(of:)
extension TimeIntervalExtensionTests {
    func testHalf_zero() {
        //Arrange
        let sut: TimeInterval = 0
        //Act
        let result = TimeInterval.half(of: sut)
        //Assert
        XCTAssertEqual(result, 0)
    }
    
    func testHalf_minute() {
        //Arrange
        let sut: TimeInterval = .minute
        //Act
        let result = TimeInterval.half(of: sut)
        //Assert
        XCTAssertEqual(result, 30)
    }
    
    func testHalf_hour() {
        //Arrange
        let sut: TimeInterval = .hour
        //Act
        let result = TimeInterval.half(of: sut)
        //Assert
        XCTAssertEqual(result, 1_800)
    }
    
    func testHalf_day() {
        //Arrange
        let sut: TimeInterval = .day
        //Act
        let result = TimeInterval.half(of: sut)
        //Assert
        XCTAssertEqual(result, 43_200)
    }
}

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
