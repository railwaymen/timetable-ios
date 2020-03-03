//
//  CalendarExtensionTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 12/12/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class CalendarExtensionTests: XCTestCase {}

// MARK: - date(byAdding components: DateComponents, to date: Date) -> Date?
extension CalendarExtensionTests {
    func testDateByAddingComponentsToDate() throws {
        //Arrange
        let sut: CalendarType = Calendar(identifier: .iso8601)
        let components = DateComponents(hour: 2, minute: 41, second: 04)
        let date = try self.buildDate(year: 1, month: 1, day: 1, hour: 23)
        let expectedDate = try XCTUnwrap(Calendar(identifier: .iso8601).date(byAdding: components, to: date))
        //Act
        let result = sut.date(byAdding: components, to: date)
        //Assert
        XCTAssertEqual(result, expectedDate)
    }
}

// MARK: - date(byAdding component: Calendar.Component, value: Int, to date: Date) -> Date?
extension CalendarExtensionTests {
    func testDateByAddingComponentsWithIntValueToDate() throws {
        //Arrange
        let sut: CalendarType = Calendar(identifier: .iso8601)
        let components = Calendar.Component.day
        let date = try self.buildDate(year: 1, month: 1, day: 31)
        let expectedDate = Calendar(identifier: .iso8601).date(byAdding: components, value: 1, to: date)
        //Act
        let result = sut.date(byAdding: components, value: 1, to: date)
        //Assert
        XCTAssertEqual(result, expectedDate)
    }
}
