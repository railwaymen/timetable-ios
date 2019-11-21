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
        let components = DateComponents(year: 2018, month: 11, day: 21)
        let expectedDate = Calendar.autoupdatingCurrent.date(from: components)
        let sut = DateFormatter(type: .simple)
        //Act
        let date = try sut.date(from: "2018-11-21").unwrap()
        //Assert
        XCTAssertEqual(date, expectedDate)
    }
    
    func testSimpleDateTypeFails() {
        //Arrange
        let sut = DateFormatter(type: .simple)
        //Act
        let date = sut.date(from: "2018-11-21T16:00:00")
        //Assert
        XCTAssertNil(date)
    }
    
    func testDateAndTimeExtendedDateTypeSucceed() throws {
        //Arrange
        let components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018,
                                        month: 11, day: 21, hour: 15, minute: 0, second: 30)
        let expectedDate = Calendar.autoupdatingCurrent.date(from: components)
        let sut = DateFormatter(type: .dateAndTimeExtended)
        //Act
        let date = try sut.date(from: "2018-11-21T15:00:30.000+01:00").unwrap()
        //Assert
        XCTAssertEqual(date, expectedDate)
    }
    
    func testDateAndTimeExtendedDateTypeFails() {
        //Arrange
        let sut = DateFormatter(type: .dateAndTimeExtended)
        //Act
        let date = sut.date(from: "2018-11-21T16:00:00")
        //Assert
        XCTAssertNil(date)
    }
}
