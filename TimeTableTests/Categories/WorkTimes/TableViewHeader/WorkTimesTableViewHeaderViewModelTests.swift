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
    
    private enum WorkTimesResponse: String, JSONFileResource {
        case workTimesResponse
    }
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter(type: .dateAndTimeExtended))
        return decoder
    }()
    
    override func setUp() {
        super.setUp()
        self.userInterface = WorkTimesTableViewHeaderViewMock()
        self.calendar = CalendarMock()
        
    }
    
    func testViewConfiguredWithTodayDate() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 11, day: 21)
        let date = try Calendar.current.date(from: components).unwrap()
        let data = try self.json(from: WorkTimesResponse.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        let dailyWorkTime = DailyWorkTime(day: date, workTimes: workTimes)
        let viewModel = WorkTimesTableViewHeaderViewModel(userInterface: self.userInterface, dailyWorkTime: dailyWorkTime, calendar: self.calendar)
        self.calendar.isDateInTodayReturnValue = true
        //Act
        viewModel.viewConfigured()
        //Assert
        XCTAssertEqual(self.userInterface.updateViewData.dayText, "day.today".localized)
        XCTAssertEqual(self.userInterface.updateViewData.durationText, "3h")
    }
    
    func testViewConfiguredWithYesterdayDate() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 11, day: 20)
        let date = try Calendar.current.date(from: components).unwrap()
        let data = try self.json(from: WorkTimesResponse.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        let dailyWorkTime = DailyWorkTime(day: date, workTimes: workTimes)
        let viewModel = WorkTimesTableViewHeaderViewModel(userInterface: self.userInterface, dailyWorkTime: dailyWorkTime, calendar: self.calendar)
        self.calendar.isDateInYesterdayReturnValue = true
        //Act
        viewModel.viewConfigured()
        //Assert
        XCTAssertEqual(self.userInterface.updateViewData.dayText, "day.yesterday".localized)
        XCTAssertEqual(self.userInterface.updateViewData.durationText, "3h")
    }
    
    func testViewConfiguredWithOtherDateThanTodayAndYesterday() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 11, day: 20)
        let date = try Calendar.current.date(from: components).unwrap()
        let data = try self.json(from: WorkTimesResponse.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        let dailyWorkTime = DailyWorkTime(day: date, workTimes: workTimes)
        let viewModel = WorkTimesTableViewHeaderViewModel(userInterface: self.userInterface, dailyWorkTime: dailyWorkTime, calendar: self.calendar)
        //Act
        viewModel.viewConfigured()
        //Assert
        XCTAssertEqual(self.userInterface.updateViewData.dayText, DateFormatter.localizedString(from: dailyWorkTime.day, dateStyle: .medium, timeStyle: .none))
        XCTAssertEqual(self.userInterface.updateViewData.durationText, "3h")
    }
}

private class WorkTimesTableViewHeaderViewMock: WorkTimesTableViewHeaderViewModelOutput {
    
    private(set) var updateViewData: (dayText: String?, durationText: String?) = (nil, nil)
    func updateView(dayText: String?, durationText: String?) {
        self.updateViewData.dayText = dayText
        self.updateViewData.durationText = durationText
    }
}
