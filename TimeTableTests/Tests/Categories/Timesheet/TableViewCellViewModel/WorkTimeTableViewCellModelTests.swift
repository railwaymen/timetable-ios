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
    private let timeFormatter: DateFormatterType = DateFormatter.shortTime
    private let workTimeDecoderFactory = WorkTimeDecoderFactory()
    
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
        let startsAt = self.timeFormatter.string(from: try self.startsAt())
        let endsAt = self.timeFormatter.string(from: try self.endsAt())
        //Act
        sut.viewConfigured()
        //Assert
        self.assertUpdatedView(times: 1)
        XCTAssertEqual(self.userInterface.updateDurationParams.last?.textParameters.text, "1h")
        XCTAssertEqual(self.userInterface.updateBodyParams.last?.textParameters.text, "body")
        XCTAssertEqual(self.userInterface.updateTaskButtonParams.last?.titleParameters.title, "preview")
        XCTAssertEqual(self.userInterface.updateFromToDateLabelParams.last?.attributedText.string, "\(startsAt) - \(endsAt)")
        let edition = try XCTUnwrap(self.userInterface.updateEditionViewParams.last)
        XCTAssertNil(edition.author)
        XCTAssertNil(edition.date)
    }
    
    func testViewConfigured_callsUpdateView_fullInfo() throws {
        //Arrange
        let updatedAt = try self.updatedAt()
        let updatedBy = "The Developer"
        let workTime = try self.buildWorkTime(updatedAt: updatedAt, updatedBy: updatedBy)
        let sut = self.buildSUT(workTime: workTime)
        let startsAt = self.timeFormatter.string(from: try self.startsAt())
        let endsAt = self.timeFormatter.string(from: try self.endsAt())
        self.dateFormatterBuilder.buildReturnValue.stringReturnValue = "time"
        //Act
        sut.viewConfigured()
        //Assert
        self.assertUpdatedView(times: 1)
        XCTAssertEqual(self.userInterface.updateDurationParams.last?.textParameters.text, "1h")
        XCTAssertEqual(self.userInterface.updateBodyParams.last?.textParameters.text, "body")
        XCTAssertEqual(self.userInterface.updateTaskButtonParams.last?.titleParameters.title, "preview")
        XCTAssertEqual(self.userInterface.updateFromToDateLabelParams.last?.attributedText.string, "\(startsAt) - \(endsAt)")
        let edition = try XCTUnwrap(self.userInterface.updateEditionViewParams.last)
        XCTAssertEqual(edition.author, updatedBy)
        XCTAssertEqual(edition.date, "time")
    }
    
    func testViewConfigured_callsUpdateView_withoutUpdateAt() throws {
        //Arrange
        let workTime = try self.buildWorkTime(updatedAt: nil, updatedBy: "The Developer")
        let sut = self.buildSUT(workTime: workTime)
        let startsAt = self.timeFormatter.string(from: try self.startsAt())
        let endsAt = self.timeFormatter.string(from: try self.endsAt())
        //Act
        sut.viewConfigured()
        //Assert
        self.assertUpdatedView(times: 1)
        XCTAssertEqual(self.userInterface.updateDurationParams.last?.textParameters.text, "1h")
        XCTAssertEqual(self.userInterface.updateBodyParams.last?.textParameters.text, "body")
        XCTAssertEqual(self.userInterface.updateTaskButtonParams.last?.titleParameters.title, "preview")
        XCTAssertEqual(self.userInterface.updateFromToDateLabelParams.last?.attributedText.string, "\(startsAt) - \(endsAt)")
        let edition = try XCTUnwrap(self.userInterface.updateEditionViewParams.last)
        XCTAssertNil(edition.author)
        XCTAssertNil(edition.date)
    }
    
    func testViewConfigured_callsUpdateView_withoutUpdateBy() throws {
        //Arrange
        let updatedAt = try self.updatedAt()
        let workTime = try self.buildWorkTime(updatedAt: updatedAt, updatedBy: nil)
        let sut = self.buildSUT(workTime: workTime)
        let startsAt = self.timeFormatter.string(from: try self.startsAt())
        let endsAt = self.timeFormatter.string(from: try self.endsAt())
        //Act
        sut.viewConfigured()
        //Assert
        self.assertUpdatedView(times: 1)
        XCTAssertEqual(self.userInterface.updateDurationParams.last?.textParameters.text, "1h")
        XCTAssertEqual(self.userInterface.updateBodyParams.last?.textParameters.text, "body")
        XCTAssertEqual(self.userInterface.updateTaskButtonParams.last?.titleParameters.title, "preview")
        XCTAssertEqual(self.userInterface.updateFromToDateLabelParams.last?.attributedText.string, "\(startsAt) - \(endsAt)")
        let edition = try XCTUnwrap(self.userInterface.updateEditionViewParams.last)
        XCTAssertNil(edition.author)
        XCTAssertNil(edition.date)
    }
}

// MARK: - prepareForReuse()
extension WorkTimeTableViewCellModelTests {
    func testPrepareForReuse_updatesView() throws {
        //Arrange
        let workTime = try self.buildWorkTime()
        let sut = self.buildSUT(workTime: workTime)
        let startsAt = self.timeFormatter.string(from: try self.startsAt())
        let endsAt = self.timeFormatter.string(from: try self.endsAt())
        //Act
        sut.prepareForReuse()
        //Assert
        self.assertUpdatedView(times: 1)
        XCTAssertEqual(self.userInterface.updateDurationParams.last?.textParameters.text, "1h")
        XCTAssertEqual(self.userInterface.updateBodyParams.last?.textParameters.text, "body")
        XCTAssertEqual(self.userInterface.updateTaskButtonParams.last?.titleParameters.title, "preview")
        XCTAssertEqual(self.userInterface.updateFromToDateLabelParams.last?.attributedText.string, "\(startsAt) - \(endsAt)")
        let edition = try XCTUnwrap(self.userInterface.updateEditionViewParams.last)
        XCTAssertNil(edition.author)
        XCTAssertNil(edition.date)
    }
}

// MARK: - taskButtonTapped()
extension WorkTimeTableViewCellModelTests {
    func testTaskButtonTappedWithValidURLCallsParentOpenTask() throws {
        //Arrange
        let workTimesDecoder = try self.buildWorkTimesDecoder(id: 1)
        let workTime = WorkTimeDisplayed(workTime: workTimesDecoder)
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
    
    private func buildWorkTime(
        updatedAt: Date? = nil,
        updatedBy: String? = nil,
        changedFields: Set<TaskVersion.Change> = []
    ) throws -> WorkTimeDisplayed {
        let startsAt = try self.startsAt()
        let endsAt = try self.endsAt()
        return WorkTimeDisplayed(
            id: 0,
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
            changedFields: changedFields,
            event: .create)
    }
    
    private func buildWorkTimesDecoder(id: Int64) throws -> WorkTimeDecoder {
        let project = try SimpleProjectRecordDecoderFactory().build()
        let wrapper = WorkTimeDecoderFactory.Wrapper(
            id: id,
            body: "body",
            project: project)
        return try self.workTimeDecoderFactory.build(wrapper: wrapper)
    }
    
    private func buildDailyWorkTime() throws -> DailyWorkTime {
        let workTimes = [
            try self.buildWorkTimesDecoder(id: 1),
            try self.buildWorkTimesDecoder(id: 2)
        ]
        return DailyWorkTime(day: Date(), workTimes: workTimes)
    }
    
    private func startsAt() throws -> Date {
        return try self.buildDate(
            timeZone: TimeZone(secondsFromGMT: 0)!,
            year: 2018,
            month: 11,
            day: 21,
            hour: 12,
            minute: 0,
            second: 0)
    }
    
    private func endsAt() throws -> Date {
        return try self.buildDate(
            timeZone: TimeZone(secondsFromGMT: 0)!,
            year: 2018,
            month: 11,
            day: 21,
            hour: 14,
            minute: 0,
            second: 0)
    }
    
    private func updatedAt() throws -> Date {
        return try self.buildDate(
            timeZone: TimeZone(secondsFromGMT: 0)!,
            year: 2018,
            month: 11,
            day: 23,
            hour: 11,
            minute: 0,
            second: 0)
    }
    
    private func assertUpdatedView(times: Int, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(self.userInterface.updateEditionViewParams.count, times, file: file, line: line)
        XCTAssertEqual(self.userInterface.updateBodyParams.count, times, file: file, line: line)
        XCTAssertEqual(self.userInterface.updateProjectParams.count, times, file: file, line: line)
        XCTAssertEqual(self.userInterface.updateDayLabelParams.count, times, file: file, line: line)
        XCTAssertEqual(self.userInterface.updateFromToDateLabelParams.count, times, file: file, line: line)
        XCTAssertEqual(self.userInterface.updateDurationParams.count, times, file: file, line: line)
        XCTAssertEqual(self.userInterface.updateTaskButtonParams.count, times, file: file, line: line)
        XCTAssertEqual(self.userInterface.updateTagViewParams.count, times, file: file, line: line)
    }
}
