//
//  DateFormatterExtensionTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 21/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class DateFormatterExtensionTests: XCTestCase {

    func testSimpleDateTypeSucceed() throws {
        //Arrange
        let expectedDate = try self.buildDate(year: 2018, month: 11, day: 21)
        let sut = DateFormatter.simple
        //Act
        let date = try XCTUnwrap(sut.date(from: "2018-11-21"))
        //Assert
        XCTAssertEqual(date, expectedDate)
    }
    
    func testSimpleDateTypeFails() {
        //Arrange
        let sut = DateFormatter.simple
        //Act
        let date = sut.date(from: "2018-11-21T16:00:00")
        //Assert
        XCTAssertNil(date)
    }
    
    func testDateAndTimeExtendedDateTypeSucceed() throws {
        //Arrange
        let expectedDate = try self.buildDate(
            timeZone: try XCTUnwrap(TimeZone(secondsFromGMT: 3600)),
            year: 2018,
            month: 11,
            day: 21,
            hour: 15,
            minute: 0,
            second: 30)
        let sut = DateFormatter.dateAndTimeExtended
        //Act
        let date = try XCTUnwrap(sut.date(from: "2018-11-21T15:00:30.000+01:00"))
        //Assert
        XCTAssertEqual(date, expectedDate)
    }
    
    func testDateAndTimeExtendedDateTypeFails() {
        //Arrange
        let sut = DateFormatter.dateAndTimeExtended
        //Act
        let date = sut.date(from: "2018-11-21T16:00:00")
        //Assert
        XCTAssertNil(date)
    }
}
