//
//  WorkTimesTableViewHeaderViewModelTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 27/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class WorkTimesTableViewHeaderViewModelTests: XCTestCase {
    private var userInterface: WorkTimesTableViewHeaderViewMock!
    private var calendar: CalendarMock!
    
    override func setUp() {
        super.setUp()
        self.userInterface = WorkTimesTableViewHeaderViewMock()
        self.calendar = CalendarMock()
    }
    
    func testViewConfiguredWithTodayDate() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 11, day: 21)
        let date = try XCTUnwrap(Calendar.current.date(from: components))
        let data = try self.json(from: WorkTimesJSONResource.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        let dailyWorkTime = DailyWorkTime(day: date, workTimes: workTimes)
        let sut = self.buildSUT(dailyWorkTime: dailyWorkTime)
        self.calendar.isDateInTodayReturnValue = true
        //Act
        sut.viewConfigured()
        //Assert
        XCTAssertEqual(self.userInterface.updateViewParams.last?.dayText, "day.today".localized)
        XCTAssertEqual(self.userInterface.updateViewParams.last?.durationText, "3h")
    }
    
    func testViewConfiguredWithYesterdayDate() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 11, day: 20)
        let date = try XCTUnwrap(Calendar.current.date(from: components))
        let data = try self.json(from: WorkTimesJSONResource.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        let dailyWorkTime = DailyWorkTime(day: date, workTimes: workTimes)
        let sut = self.buildSUT(dailyWorkTime: dailyWorkTime)
        self.calendar.isDateInYesterdayReturnValue = true
        //Act
        sut.viewConfigured()
        //Assert
        XCTAssertEqual(self.userInterface.updateViewParams.last?.dayText, "day.yesterday".localized)
        XCTAssertEqual(self.userInterface.updateViewParams.last?.durationText, "3h")
    }
    
    func testViewConfiguredWithOtherDateThanTodayAndYesterday() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 11, day: 20)
        let date = try XCTUnwrap(Calendar.current.date(from: components))
        let data = try self.json(from: WorkTimesJSONResource.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        let dailyWorkTime = DailyWorkTime(day: date, workTimes: workTimes)
        let expectedDayText = DateFormatter.localizedString(from: dailyWorkTime.day, dateStyle: .medium, timeStyle: .none)
        let sut = self.buildSUT(dailyWorkTime: dailyWorkTime)
        //Act
        sut.viewConfigured()
        //Assert
        XCTAssertEqual(self.userInterface.updateViewParams.last?.dayText, expectedDayText)
        XCTAssertEqual(self.userInterface.updateViewParams.last?.durationText, "3h")
    }
}

// MARK: - Private
extension WorkTimesTableViewHeaderViewModelTests {
    private func buildSUT(dailyWorkTime: DailyWorkTime) -> WorkTimesTableViewHeaderViewModel {
        return WorkTimesTableViewHeaderViewModel(
            userInterface: self.userInterface,
            dailyWorkTime: dailyWorkTime,
            calendar: self.calendar)
    }
}
