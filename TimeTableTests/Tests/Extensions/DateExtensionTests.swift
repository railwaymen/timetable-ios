//
//  DateExtensionTests.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 02/12/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class DateExtensionTests: XCTestCase {}

// MARK: - roundedToFiveMinutes
extension DateExtensionTests {
    func testRoundedToFiveMinutes_rounded() throws {
        //Arrange
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 0))
        let sut = try self.buildDate(timeZone: timeZone, year: 2019, month: 1, day: 1, hour: 12, minute: 35, second: 0)
        //Act
        let roundedDate = sut.roundedToFiveMinutes()
        //Assert
        let components = Calendar(identifier: .iso8601).dateComponents(in: timeZone, from: roundedDate)
        XCTAssertEqual(components.second, 0)
        XCTAssertEqual(components.minute, 35)
        XCTAssertEqual(components.hour, 12)
        XCTAssertEqual(components.day, 1)
        XCTAssertEqual(components.month, 1)
        XCTAssertEqual(components.year, 2019)
    }
    
    func testRoundedToFiveMinutes_roundsUp() throws {
        //Arrange
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 0))
        let sut = try self.buildDate(timeZone: timeZone, year: 2019, month: 1, day: 1, hour: 12, minute: 32, second: 30)
        //Act
        let roundedDate = sut.roundedToFiveMinutes()
        //Assert
        let components = Calendar(identifier: .iso8601).dateComponents(in: timeZone, from: roundedDate)
        XCTAssertEqual(components.second, 0)
        XCTAssertEqual(components.minute, 35)
        XCTAssertEqual(components.hour, 12)
        XCTAssertEqual(components.day, 1)
        XCTAssertEqual(components.month, 1)
        XCTAssertEqual(components.year, 2019)
    }
    
    func testRoundedToFiveMinutes_roundsDown() throws {
        //Arrange
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 0))
        let sut = try self.buildDate(timeZone: timeZone, year: 2019, month: 1, day: 1, hour: 12, minute: 32, second: 29)
        //Act
        let roundedDate = sut.roundedToFiveMinutes()
        //Assert
        let components = Calendar(identifier: .iso8601).dateComponents(in: timeZone, from: roundedDate)
        XCTAssertEqual(components.second, 0)
        XCTAssertEqual(components.minute, 30)
        XCTAssertEqual(components.hour, 12)
        XCTAssertEqual(components.day, 1)
        XCTAssertEqual(components.month, 1)
        XCTAssertEqual(components.year, 2019)
    }
    
    func testRoundedToFiveMinutes_switchesDayWhileRoundingUp() throws {
        //Arrange
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 0))
        let sut = try self.buildDate(timeZone: timeZone, year: 2019, month: 1, day: 1, hour: 23, minute: 59, second: 30)
        //Act
        let roundedDate = sut.roundedToFiveMinutes()
        //Assert
        let components = Calendar(identifier: .iso8601).dateComponents(in: timeZone, from: roundedDate)
        XCTAssertEqual(components.second, 0)
        XCTAssertEqual(components.minute, 0)
        XCTAssertEqual(components.hour, 0)
        XCTAssertEqual(components.day, 2)
        XCTAssertEqual(components.month, 1)
        XCTAssertEqual(components.year, 2019)
    }
    
    func testRoundedToFiveMinutes_switchesMonthWhileRoundingUp() throws {
        //Arrange
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 0))
        let sut = try self.buildDate(timeZone: timeZone, year: 2019, month: 1, day: 31, hour: 23, minute: 59, second: 30)
        //Act
        let roundedDate = sut.roundedToFiveMinutes()
        //Assert
        let components = Calendar(identifier: .iso8601).dateComponents(in: timeZone, from: roundedDate)
        XCTAssertEqual(components.second, 0)
        XCTAssertEqual(components.minute, 0)
        XCTAssertEqual(components.hour, 0)
        XCTAssertEqual(components.day, 1)
        XCTAssertEqual(components.month, 2)
        XCTAssertEqual(components.year, 2019)
    }
    
    func testRoundedToFiveMinutes_switchesYearWhileRoundingUp() throws {
        //Arrange
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 0))
        let sut = try self.buildDate(timeZone: timeZone, year: 2019, month: 12, day: 31, hour: 23, minute: 59, second: 30)
        //Act
        let roundedDate = sut.roundedToFiveMinutes()
        //Assert
        let components = Calendar(identifier: .iso8601).dateComponents(in: timeZone, from: roundedDate)
        XCTAssertEqual(components.second, 0)
        XCTAssertEqual(components.minute, 0)
        XCTAssertEqual(components.hour, 0)
        XCTAssertEqual(components.day, 1)
        XCTAssertEqual(components.month, 1)
        XCTAssertEqual(components.year, 2020)
    }
}
