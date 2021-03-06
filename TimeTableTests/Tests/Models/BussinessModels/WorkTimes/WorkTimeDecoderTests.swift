//
//  WorkTimeDecoderTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 21/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class WorkTimeDecoderTests: XCTestCase {
    private let projectDecoderFactory = SimpleProjectRecordDecoderFactory()
}

// MARK: - Decodable
extension WorkTimeDecoderTests {
    func testWorkTimeResponse() throws {
        //Arrange
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 3600))
        let startsAt = try self.buildDate(timeZone: timeZone, year: 2018, month: 11, day: 21, hour: 15)
        let endsAt = try self.buildDate(timeZone: timeZone, year: 2018, month: 11, day: 21, hour: 16)
        let date = try self.buildDate(timeZone: timeZone, year: 2018, month: 11, day: 21, hour: 0)
        let project = try self.projectDecoderFactory.build(wrapper: .init(
            id: 3,
            name: "Lorem Ipsum",
            color: UIColor(hexString: "fe0404"),
            isLunch: false,
            workTimesAllowsTask: false,
            isTaggable: true))
        let data = try self.json(from: WorkTimesJSONResource.workTimeResponse)
        //Act
        let sut = try self.decoder.decode(WorkTimeDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 16239)
        XCTAssertFalse(sut.updatedByAdmin)
        XCTAssertEqual(sut.projectID, 3)
        XCTAssertEqual(sut.startsAt, startsAt)
        XCTAssertEqual(sut.endsAt, endsAt)
        XCTAssertEqual(sut.duration, 3600)
        XCTAssertEqual(sut.body, "Bracket - v2")
        XCTAssertEqual(sut.task, "https://www.example.com/task1")
        XCTAssertEqual(sut.taskPreview, "task1")
        XCTAssertEqual(sut.userID, 11)
        XCTAssertEqual(sut.date, date)
        XCTAssertEqual(sut.project, project)
    }
    
    func testWorkTimeInvalidDateFormatResponse() throws {
        //Arrange
        let data = try self.json(from: WorkTimesJSONResource.workTimeInvalidDateFormatResponse)
        //Act
        do {
            _ = try self.decoder.decode(WorkTimeDecoder.self, from: data)
        } catch {
            //Assert
            XCTAssertNotNil(error)
        }
    }
    
    func testWorkTimeBodyNull() throws {
        //Arrange
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 3600))
        let startsAt = try self.buildDate(timeZone: timeZone, year: 2018, month: 11, day: 21, hour: 15)
        let endsAt = try self.buildDate(timeZone: timeZone, year: 2018, month: 11, day: 21, hour: 16)
        let date = try self.buildDate(timeZone: timeZone, year: 2018, month: 11, day: 21, hour: 0)
        let project = try self.projectDecoderFactory.build(wrapper: .init(
            id: 3,
            name: "Lorem Ipsum",
            color: UIColor(hexString: "fe0404"),
            isLunch: false,
            workTimesAllowsTask: false,
            isTaggable: true))
        let data = try self.json(from: WorkTimesJSONResource.workTimeBodyNull)
        //Act
        let sut = try self.decoder.decode(WorkTimeDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 16239)
        XCTAssertFalse(sut.updatedByAdmin)
        XCTAssertEqual(sut.projectID, 3)
        XCTAssertEqual(sut.startsAt, startsAt)
        XCTAssertEqual(sut.endsAt, endsAt)
        XCTAssertEqual(sut.duration, 3600)
        XCTAssertNil(sut.body)
        XCTAssertEqual(sut.task, "https://www.example.com/task1")
        XCTAssertEqual(sut.taskPreview, "task1")
        XCTAssertEqual(sut.userID, 11)
        XCTAssertEqual(sut.date, date)
        XCTAssertEqual(sut.project, project)
    }
    
    func testWorkTimeMissingBodyKey() throws {
        //Arrange
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 3600))
        let startsAt = try self.buildDate(timeZone: timeZone, year: 2018, month: 11, day: 21, hour: 15)
        let endsAt = try self.buildDate(timeZone: timeZone, year: 2018, month: 11, day: 21, hour: 16)
        let date = try self.buildDate(timeZone: timeZone, year: 2018, month: 11, day: 21, hour: 0)
        let project = try self.projectDecoderFactory.build(wrapper: .init(
            id: 3,
            name: "Lorem Ipsum",
            color: UIColor(hexString: "fe0404"),
            isLunch: false,
            workTimesAllowsTask: false,
            isTaggable: true))
        let data = try self.json(from: WorkTimesJSONResource.workTimeMissingBodyKey)
        //Act
        let sut = try self.decoder.decode(WorkTimeDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 16239)
        XCTAssertFalse(sut.updatedByAdmin)
        XCTAssertEqual(sut.projectID, 3)
        XCTAssertEqual(sut.startsAt, startsAt)
        XCTAssertEqual(sut.endsAt, endsAt)
        XCTAssertEqual(sut.duration, 3600)
        XCTAssertNil(sut.body)
        XCTAssertEqual(sut.task, "https://www.example.com/task1")
        XCTAssertEqual(sut.taskPreview, "task1")
        XCTAssertEqual(sut.userID, 11)
        XCTAssertEqual(sut.date, date)
        XCTAssertEqual(sut.project, project)
    }
    
    func testWorkTimeNullTask() throws {
        //Arrange
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 3600))
        let startsAt = try self.buildDate(timeZone: timeZone, year: 2018, month: 11, day: 21, hour: 15)
        let endsAt = try self.buildDate(timeZone: timeZone, year: 2018, month: 11, day: 21, hour: 16)
        let date = try self.buildDate(timeZone: timeZone, year: 2018, month: 11, day: 21, hour: 0)
        let project = try self.projectDecoderFactory.build(wrapper: .init(
            id: 3,
            name: "Lorem Ipsum",
            color: UIColor(hexString: "fe0404"),
            isLunch: false,
            workTimesAllowsTask: false,
            isTaggable: true))
        let data = try self.json(from: WorkTimesJSONResource.workTimeNullTask)
        //Act
        let sut = try self.decoder.decode(WorkTimeDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 16239)
        XCTAssertFalse(sut.updatedByAdmin)
        XCTAssertEqual(sut.projectID, 3)
        XCTAssertEqual(sut.startsAt, startsAt)
        XCTAssertEqual(sut.endsAt, endsAt)
        XCTAssertEqual(sut.duration, 3600)
        XCTAssertEqual(sut.body, "Bracket - v2")
        XCTAssertNil(sut.task)
        XCTAssertEqual(sut.taskPreview, "task1")
        XCTAssertEqual(sut.userID, 11)
        XCTAssertEqual(sut.date, date)
        XCTAssertEqual(sut.project, project)
    }
    
    func testWorkTimeMissingTaskKey() throws {
        //Arrange
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 3600))
        let startsAt = try self.buildDate(timeZone: timeZone, year: 2018, month: 11, day: 21, hour: 15)
        let endsAt = try self.buildDate(timeZone: timeZone, year: 2018, month: 11, day: 21, hour: 16)
        let date = try self.buildDate(timeZone: timeZone, year: 2018, month: 11, day: 21, hour: 0)
        let project = try self.projectDecoderFactory.build(wrapper: .init(
            id: 3,
            name: "Lorem Ipsum",
            color: UIColor(hexString: "fe0404"),
            isLunch: false,
            workTimesAllowsTask: false,
            isTaggable: true))
        let data = try self.json(from: WorkTimesJSONResource.workTimeMissingTaskKey)
        //Act
        let sut = try self.decoder.decode(WorkTimeDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 16239)
        XCTAssertFalse(sut.updatedByAdmin)
        XCTAssertEqual(sut.projectID, 3)
        XCTAssertEqual(sut.startsAt, startsAt)
        XCTAssertEqual(sut.endsAt, endsAt)
        XCTAssertEqual(sut.duration, 3600)
        XCTAssertEqual(sut.body, "Bracket - v2")
        XCTAssertNil(sut.task)
        XCTAssertEqual(sut.taskPreview, "task1")
        XCTAssertEqual(sut.userID, 11)
        XCTAssertEqual(sut.date, date)
        XCTAssertEqual(sut.project, project)
    }

    func testWorkTimeNullTaskPreview() throws {
        //Arrange
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 3600))
        let startsAt = try self.buildDate(timeZone: timeZone, year: 2018, month: 11, day: 21, hour: 15)
        let endsAt = try self.buildDate(timeZone: timeZone, year: 2018, month: 11, day: 21, hour: 16)
        let date = try self.buildDate(timeZone: timeZone, year: 2018, month: 11, day: 21, hour: 0)
        let project = try self.projectDecoderFactory.build(wrapper: .init(
            id: 3,
            name: "Lorem Ipsum",
            color: UIColor(hexString: "fe0404"),
            isLunch: false,
            workTimesAllowsTask: false,
            isTaggable: true))
        let data = try self.json(from: WorkTimesJSONResource.workTimeNullTaskPreview)
        //Act
        let sut = try self.decoder.decode(WorkTimeDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 16239)
        XCTAssertFalse(sut.updatedByAdmin)
        XCTAssertEqual(sut.projectID, 3)
        XCTAssertEqual(sut.startsAt, startsAt)
        XCTAssertEqual(sut.endsAt, endsAt)
        XCTAssertEqual(sut.duration, 3600)
        XCTAssertEqual(sut.body, "Bracket - v2")
        XCTAssertEqual(sut.task, "https://www.example.com/task1")
        XCTAssertNil(sut.taskPreview)
        XCTAssertEqual(sut.userID, 11)
        XCTAssertEqual(sut.date, date)
        XCTAssertEqual(sut.project, project)
    }
    
    func testWorkTimesMissingTaskPreviewKey() throws {
        //Arrange
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 3600))
        let startsAt = try self.buildDate(timeZone: timeZone, year: 2018, month: 11, day: 21, hour: 15)
        let endsAt = try self.buildDate(timeZone: timeZone, year: 2018, month: 11, day: 21, hour: 16)
        let date = try self.buildDate(timeZone: timeZone, year: 2018, month: 11, day: 21, hour: 0)
        let project = try self.projectDecoderFactory.build(wrapper: .init(
            id: 3,
            name: "Lorem Ipsum",
            color: UIColor(hexString: "fe0404"),
            isLunch: false,
            workTimesAllowsTask: false,
            isTaggable: true))
        let data = try self.json(from: WorkTimesJSONResource.workTimeMissingTaskPreviewKey)
        //Act
        let sut = try self.decoder.decode(WorkTimeDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 16239)
        XCTAssertFalse(sut.updatedByAdmin)
        XCTAssertEqual(sut.projectID, 3)
        XCTAssertEqual(sut.startsAt, startsAt)
        XCTAssertEqual(sut.endsAt, endsAt)
        XCTAssertEqual(sut.duration, 3600)
        XCTAssertEqual(sut.body, "Bracket - v2")
        XCTAssertEqual(sut.task, "https://www.example.com/task1")
        XCTAssertNil(sut.taskPreview)
        XCTAssertEqual(sut.userID, 11)
        XCTAssertEqual(sut.date, date)
        XCTAssertEqual(sut.project, project)
    }
}
