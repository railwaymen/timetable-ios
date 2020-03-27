//
//  WorkTimeTableViewCellModelTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 12/12/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class WorkTimeTableViewCellModelTests: XCTestCase {
    private var userInterface: WorkTimeCellViewMock!
    private var parent: WorkTimeCellViewModelParentMock!
    private var dateFormatterBuilder: DateFormatterBuilderMock!
    private var errorHandler: ErrorHandlerMock!

    override func setUp() {
        super.setUp()
        self.userInterface = WorkTimeCellViewMock()
        self.parent = WorkTimeCellViewModelParentMock()
        self.dateFormatterBuilder = DateFormatterBuilderMock()
        self.errorHandler = ErrorHandlerMock()
    }
}

// MARK: - viewConfigured()
extension WorkTimeTableViewCellModelTests {
    func testViewConfigured_callsUpdateView_withoutUpdateInfo() throws {
        //Arrange
        let workTime = try self.buildWorkTime()
        let sut = self.buildSUT(workTime: workTime)
        self.dateFormatterBuilder.buildReturnValue.stringReturnValue = "time"
        //Act
        sut.viewConfigured()
        //Assert
        XCTAssertEqual(self.userInterface.updateViewParams.count, 1)
        XCTAssertEqual(self.userInterface.updateViewParams.last?.data.duration.text, "1h")
        XCTAssertEqual(self.userInterface.updateViewParams.last?.data.body.text, "body")
        XCTAssertEqual(self.userInterface.updateViewParams.last?.data.taskUrl.text, "preview")
        XCTAssertNil(self.userInterface.updateViewParams.last?.data.edition)
        XCTAssertEqual(self.userInterface.updateViewParams.last?.data.fromToDateText.string, "1:00 PM - 3:00 PM")
    }
    
    func testViewConfigured_callsUpdateView_fullInfo() throws {
        //Arrange
        let updatedAt = try self.updatedAt()
        let updatedBy = "The Developer"
        let workTime = try self.buildWorkTime(updatedAt: updatedAt, updatedBy: updatedBy)
        let sut = self.buildSUT(workTime: workTime)
        self.dateFormatterBuilder.buildReturnValue.stringReturnValue = "time"
        //Act
        sut.viewConfigured()
        //Assert
        XCTAssertEqual(self.userInterface.updateViewParams.count, 1)
        XCTAssertEqual(self.userInterface.updateViewParams.last?.data.duration.text, "1h")
        XCTAssertEqual(self.userInterface.updateViewParams.last?.data.body.text, "body")
        XCTAssertEqual(self.userInterface.updateViewParams.last?.data.taskUrl.text, "preview")
        XCTAssertEqual(self.userInterface.updateViewParams.last?.data.edition?.author, updatedBy)
        XCTAssertEqual(self.userInterface.updateViewParams.last?.data.edition?.date, "time")
        XCTAssertEqual(self.userInterface.updateViewParams.last?.data.fromToDateText.string, "1:00 PM - 3:00 PM")
    }
    
    func testViewConfigured_callsUpdateView_withoutUpdateAt() throws {
        //Arrange
        let workTime = try self.buildWorkTime(updatedAt: nil, updatedBy: "The Developer")
        let sut = self.buildSUT(workTime: workTime)
        self.dateFormatterBuilder.buildReturnValue.stringReturnValue = "time"
        //Act
        sut.viewConfigured()
        //Assert
        XCTAssertEqual(self.userInterface.updateViewParams.count, 1)
        XCTAssertEqual(self.userInterface.updateViewParams.last?.data.duration.text, "1h")
        XCTAssertEqual(self.userInterface.updateViewParams.last?.data.body.text, "body")
        XCTAssertEqual(self.userInterface.updateViewParams.last?.data.taskUrl.text, "preview")
        XCTAssertNil(self.userInterface.updateViewParams.last?.data.edition)
        XCTAssertEqual(self.userInterface.updateViewParams.last?.data.fromToDateText.string, "1:00 PM - 3:00 PM")
    }
    
    func testViewConfigured_callsUpdateView_withoutUpdateBy() throws {
        //Arrange
        let updatedAt = try self.updatedAt()
        let workTime = try self.buildWorkTime(updatedAt: updatedAt, updatedBy: nil)
        let sut = self.buildSUT(workTime: workTime)
        self.dateFormatterBuilder.buildReturnValue.stringReturnValue = "time"
        //Act
        sut.viewConfigured()
        //Assert
        XCTAssertEqual(self.userInterface.updateViewParams.count, 1)
        XCTAssertEqual(self.userInterface.updateViewParams.last?.data.duration.text, "1h")
        XCTAssertEqual(self.userInterface.updateViewParams.last?.data.body.text, "body")
        XCTAssertEqual(self.userInterface.updateViewParams.last?.data.taskUrl.text, "preview")
        XCTAssertNil(self.userInterface.updateViewParams.last?.data.edition)
        XCTAssertEqual(self.userInterface.updateViewParams.last?.data.fromToDateText.string, "1:00 PM - 3:00 PM")
    }
}

// MARK: - prepareForReuse()
extension WorkTimeTableViewCellModelTests {
    func testPrepareForReuse_callsUpdateView() throws {
        //Arrange
        let workTime = try self.buildWorkTime()
        let sut = self.buildSUT(workTime: workTime)
        self.dateFormatterBuilder.buildReturnValue.stringReturnValue = "time"
        //Act
        sut.prepareForReuse()
        //Assert
        XCTAssertEqual(self.userInterface.updateViewParams.count, 1)
        XCTAssertEqual(self.userInterface.updateViewParams.last?.data.duration.text, "1h")
        XCTAssertEqual(self.userInterface.updateViewParams.last?.data.body.text, "body")
        XCTAssertEqual(self.userInterface.updateViewParams.last?.data.taskUrl.text, "preview")
        XCTAssertNil(self.userInterface.updateViewParams.last?.data.edition)
        XCTAssertEqual(self.userInterface.updateViewParams.last?.data.fromToDateText.string, "1:00 PM - 3:00 PM")
    }
}

// MARK: - taskButtonTapped()
extension WorkTimeTableViewCellModelTests {
    func testTaskButtonTappedWithValidURLCallsParentOpenTask() throws {
        //Arrange
        let data = try self.json(from: WorkTimesJSONResource.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        let workTime = WorkTimeDisplayed(workTime: try XCTUnwrap(workTimes[safeIndex: 1]))
        let sut = self.buildSUT(workTime: workTime)
        //Act
        sut.taskButtonTapped()
        //Assert
        XCTAssertEqual(self.parent.openTaskParams.count, 1)
        XCTAssertEqual(self.parent.openTaskParams.last?.workTime, workTime)
    }
}

// MARK: - Private
extension WorkTimeTableViewCellModelTests {
    private func buildSUT(workTime: WorkTimeDisplayed) -> WorkTimeTableViewCellModel {
        return WorkTimeTableViewCellModel(
            userInterface: self.userInterface,
            parent: self.parent,
            dateFormatterBuilder: self.dateFormatterBuilder,
            errorHandler: self.errorHandler,
            workTime: workTime)
    }
    
    private func buildWorkTime(updatedAt: Date? = nil, updatedBy: String? = nil) throws -> WorkTimeDisplayed {
        let startsAt = try self.startsAt()
        let endsAt = try self.endsAt()
        return WorkTimeDisplayed(
            identifier: 0,
            body: "body",
            task: "https://example.com",
            taskPreview: "preview",
            projectName: "project",
            projectColor: .black,
            tag: .default,
            startsAt: startsAt,
            endsAt: endsAt,
            duration: 3600,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            changedFields: [])
    }
    
    private func startsAt() throws -> Date {
        return try self.buildDate(timeZone: TimeZone(secondsFromGMT: 0)!, year: 2018, month: 11, day: 21, hour: 12, minute: 0, second: 0)
    }
    
    private func endsAt() throws -> Date {
        return try self.buildDate(timeZone: TimeZone(secondsFromGMT: 0)!, year: 2018, month: 11, day: 21, hour: 14, minute: 0, second: 0)
    }
    
    private func updatedAt() throws -> Date {
        return try self.buildDate(timeZone: TimeZone(secondsFromGMT: 0)!, year: 2018, month: 11, day: 23, hour: 11, minute: 0, second: 0)
    }
}
