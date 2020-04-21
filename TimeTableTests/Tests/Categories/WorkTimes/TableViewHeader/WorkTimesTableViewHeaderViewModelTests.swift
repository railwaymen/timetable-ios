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
    private let workTimeDecoderFactory = WorkTimeDecoderFactory()
    
    private var userInterface: WorkTimesTableViewHeaderViewMock!
    private var calendar: CalendarMock!
    
    override func setUp() {
        super.setUp()
        self.userInterface = WorkTimesTableViewHeaderViewMock()
        self.calendar = CalendarMock()
    }
}

// MARK: - viewConfigured()
extension WorkTimesTableViewHeaderViewModelTests {
    func testViewConfiguredWithTodayDate() throws {
        //Arrange
        let date = Date()
        let workTimes = try self.buildWorkTimesDecoders()
        let dailyWorkTime = DailyWorkTime(day: date, workTimes: workTimes)
        let sut = self.buildSUT(dailyWorkTime: dailyWorkTime)
        //Act
        sut.viewConfigured()
        //Assert
        XCTAssertEqual(self.userInterface.updateViewParams.last?.dayText, "Today")
        XCTAssertEqual(self.userInterface.updateViewParams.last?.durationText, "3h")
    }
    
    func testViewConfiguredWithYesterdayDate() throws {
        //Arrange
        let date = Date().addingTimeInterval(-.day)
        let workTimes = try self.buildWorkTimesDecoders()
        let dailyWorkTime = DailyWorkTime(day: date, workTimes: workTimes)
        let sut = self.buildSUT(dailyWorkTime: dailyWorkTime)
        //Act
        sut.viewConfigured()
        //Assert
        XCTAssertEqual(self.userInterface.updateViewParams.last?.dayText, "Yesterday")
        XCTAssertEqual(self.userInterface.updateViewParams.last?.durationText, "3h")
    }
    
    func testViewConfiguredWithOtherDateThanTodayAndYesterday() throws {
        //Arrange
        let date = try self.buildDate(year: 2018, month: 11, day: 20)
        let workTimes = try self.buildWorkTimesDecoders()
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
    
    private func buildWorkTimesDecoder(
        id: Int64,
        duration: Int64
    ) throws -> WorkTimeDecoder {
        let project = try SimpleProjectRecordDecoderFactory().build()
        let wrapper = WorkTimeDecoderFactory.Wrapper(
            id: id,
            duration: duration,
            project: project)
        return try self.workTimeDecoderFactory.build(wrapper: wrapper)
    }
    
    private func buildWorkTimesDecoders() throws -> [WorkTimeDecoder] {
        return [
            try self.buildWorkTimesDecoder(id: 1, duration: Int64(TimeInterval.hour)),
            try self.buildWorkTimesDecoder(id: 2, duration: Int64(TimeInterval.hour * 2))
        ]
    }
}
