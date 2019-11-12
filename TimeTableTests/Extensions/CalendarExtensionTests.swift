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
    
    private var calendar: CalendarType!
    
    override func setUp() {
        super.setUp()
        self.calendar = Calendar.current
    }
    
    func testDateByAddingComponentsToDate() {
        //Arrange
        let components = DateComponents(hour: 13, minute: 41, second: 04)
        let date = Date()
        //Act
        let firstDate = self.calendar.date(byAdding: components, to: date)
        let secondDate = self.calendar.date(byAdding: components, to: date, wrappingComponents: true)
        //Assert
        XCTAssertEqual(firstDate, secondDate)
    }
    
    func testDateByAddingComponentsWithIntValueToDate() {
        //Arrange
        let components = Calendar.Component.day
        let date = Date()
        //Act
        let firstDate = self.calendar.date(byAdding: components, value: 1, to: date)
        let secondDate = self.calendar.date(byAdding: components, value: 1, to: date, wrappingComponents: true)
        //Assert
        XCTAssertEqual(firstDate, secondDate)
    }
}
