//
//  WorkTimesTableViewHeaderViewModelTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 27/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class WorkTimesTableViewHeaderViewModel: XCTestCase {
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
        userInterface = WorkTimesTableViewHeaderViewMock()
        calendar = CalendarMock()
        
        super.setUp()
    }
    
    func testViewConfiguredWithTodayDate() throws {
        //Arrange
        let data = try self.json(from: WorkTimesResponse.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        let dailyWorkTime = DailyWorkTime(day: <#T##Date#>, workTimes: workTimes)
        //Act
        //Assert
    }
    
    func testViewConfiguredWithYesterdayDate() {
        //Arrange
        //Act
        //Assert
    }
    
    func testViewConfiguredWithOtherDateThanTodayAndYesterday() {
        //Arrange
        //Act
        //Assert
    }
}

private class WorkTimesTableViewHeaderViewMock: WorkTimesTableViewHeaderViewModelOutput {
    func updateView(dayText: String?, durationText: String?) {}
}
