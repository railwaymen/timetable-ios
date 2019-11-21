//
//  CalendarExtensionTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 12/12/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class CalendarExtensionTests: XCTestCase {
    
    func testDateByAddingComponentsToDate() throws {
        //Arrange
        let sut: CalendarType = Calendar(identifier: .iso8601)
        let components = DateComponents(hour: 2, minute: 41, second: 04)
        let date = try DateComponents(calendar: Calendar(identifier: .iso8601), hour: 23).date.unwrap()
        let expectedDate = Calendar(identifier: .iso8601).date(byAdding: components, to: date)
        //Act
        let result = sut.date(byAdding: components, to: date)
        //Assert
        XCTAssertEqual(result, expectedDate)
    }
    
    func testDateByAddingComponentsWithIntValueToDate() throws {
        //Arrange
        let sut: CalendarType = Calendar(identifier: .iso8601)
        let components = Calendar.Component.day
        let date = try DateComponents(calendar: Calendar(identifier: .iso8601), month: 1, day: 31).date.unwrap()
        let expectedDate = Calendar.current.date(byAdding: components, value: 1, to: date)
        //Act
        let result = sut.date(byAdding: components, value: 1, to: date)
        //Assert
        XCTAssertEqual(result, expectedDate)
    }
}
