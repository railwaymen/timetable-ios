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
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter(type: .dateAndTimeExtended))
        return decoder
    }()
    
    func testWorkTimeResponse() throws {
        //Arrange
        var components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 21, hour: 15)
        let startsAt = try Calendar.current.date(from: components).unwrap()
        components.hour = 16
        let endsAt = try Calendar.current.date(from: components).unwrap()
        components.hour = 0
        let date = try Calendar.current.date(from: components).unwrap()
        
        let project = ProjectDecoder(identifier: 3, name: "Lorem Ipsum",
                                     color: UIColor(hexString: "fe0404"),
                                     autofill: nil, countDuration: nil,
                                     isActive: nil, isInternal: nil,
                                     isLunch: false, workTimesAllowsTask: false)
        let data = try self.json(from: WorkTimesJSONResource.workTimeResponse)
        //Act
        let sut = try self.decoder.decode(WorkTimeDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 16239)
        XCTAssertFalse(sut.updatedByAdmin)
        XCTAssertEqual(sut.projectIdentifier, 3)
        XCTAssertEqual(sut.startsAt, startsAt)
        XCTAssertEqual(sut.endsAt, endsAt)
        XCTAssertEqual(sut.duration, 3600)
        XCTAssertEqual(sut.body, "Bracket - v2")
        XCTAssertEqual(sut.task, "https://www.example.com/task1")
        XCTAssertEqual(sut.taskPreview, "task1")
        XCTAssertEqual(sut.userIdentifier, 11)
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
        var components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 21, hour: 15)
        let startsAt = try Calendar.current.date(from: components).unwrap()
        components.hour = 16
        let endsAt = try Calendar.current.date(from: components).unwrap()
        components.hour = 0
        let date = try Calendar.current.date(from: components).unwrap()
        let project = ProjectDecoder(identifier: 3, name: "Lorem Ipsum",
                                     color: UIColor(hexString: "fe0404"),
                                     autofill: nil, countDuration: nil,
                                     isActive: nil, isInternal: nil,
                                     isLunch: false, workTimesAllowsTask: false)
        let data = try self.json(from: WorkTimesJSONResource.workTimeBodyNull)
        //Act
        let sut = try self.decoder.decode(WorkTimeDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 16239)
        XCTAssertFalse(sut.updatedByAdmin)
        XCTAssertEqual(sut.projectIdentifier, 3)
        XCTAssertEqual(sut.startsAt, startsAt)
        XCTAssertEqual(sut.endsAt, endsAt)
        XCTAssertEqual(sut.duration, 3600)
        XCTAssertNil(sut.body)
        XCTAssertEqual(sut.task, "https://www.example.com/task1")
        XCTAssertEqual(sut.taskPreview, "task1")
        XCTAssertEqual(sut.userIdentifier, 11)
        XCTAssertEqual(sut.date, date)
        XCTAssertEqual(sut.project, project)
    }
    
    func testWorkTimeMissingBodyKey() throws {
        //Arrange
        var components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 21, hour: 15)
        let startsAt = try Calendar.current.date(from: components).unwrap()
        components.hour = 16
        let endsAt = try Calendar.current.date(from: components).unwrap()
        components.hour = 0
        let date = try Calendar.current.date(from: components).unwrap()
        let project = ProjectDecoder(identifier: 3, name: "Lorem Ipsum",
                                     color: UIColor(hexString: "fe0404"),
                                     autofill: nil, countDuration: nil,
                                     isActive: nil, isInternal: nil,
                                     isLunch: false, workTimesAllowsTask: false)
        let data = try self.json(from: WorkTimesJSONResource.workTimeMissingBodyKey)
        //Act
        let sut = try self.decoder.decode(WorkTimeDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 16239)
        XCTAssertFalse(sut.updatedByAdmin)
        XCTAssertEqual(sut.projectIdentifier, 3)
        XCTAssertEqual(sut.startsAt, startsAt)
        XCTAssertEqual(sut.endsAt, endsAt)
        XCTAssertEqual(sut.duration, 3600)
        XCTAssertNil(sut.body)
        XCTAssertEqual(sut.task, "https://www.example.com/task1")
        XCTAssertEqual(sut.taskPreview, "task1")
        XCTAssertEqual(sut.userIdentifier, 11)
        XCTAssertEqual(sut.date, date)
        XCTAssertEqual(sut.project, project)
    }
    
    func testWorkTimeNullTask() throws {
        //Arrange
        var components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 21, hour: 15)
        let startsAt = try Calendar.current.date(from: components).unwrap()
        components.hour = 16
        let endsAt = try Calendar.current.date(from: components).unwrap()
        components.hour = 0
        let date = try Calendar.current.date(from: components).unwrap()
        let project = ProjectDecoder(identifier: 3, name: "Lorem Ipsum",
                                     color: UIColor(hexString: "fe0404"),
                                     autofill: nil, countDuration: nil,
                                     isActive: nil, isInternal: nil,
                                     isLunch: false, workTimesAllowsTask: false)
        let data = try self.json(from: WorkTimesJSONResource.workTimeNullTask)
        //Act
        let sut = try self.decoder.decode(WorkTimeDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 16239)
        XCTAssertFalse(sut.updatedByAdmin)
        XCTAssertEqual(sut.projectIdentifier, 3)
        XCTAssertEqual(sut.startsAt, startsAt)
        XCTAssertEqual(sut.endsAt, endsAt)
        XCTAssertEqual(sut.duration, 3600)
        XCTAssertEqual(sut.body, "Bracket - v2")
        XCTAssertNil(sut.task)
        XCTAssertEqual(sut.taskPreview, "task1")
        XCTAssertEqual(sut.userIdentifier, 11)
        XCTAssertEqual(sut.date, date)
        XCTAssertEqual(sut.project, project)
    }
    
    func testWorkTimeMissingTaskKey() throws {
        //Arrange
        var components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 21, hour: 15)
        let startsAt = try Calendar.current.date(from: components).unwrap()
        components.hour = 16
        let endsAt = try Calendar.current.date(from: components).unwrap()
        components.hour = 0
        let date = try Calendar.current.date(from: components).unwrap()
        let project = ProjectDecoder(identifier: 3, name: "Lorem Ipsum",
                                     color: UIColor(hexString: "fe0404"),
                                     autofill: nil, countDuration: nil,
                                     isActive: nil, isInternal: nil,
                                     isLunch: false, workTimesAllowsTask: false)
        let data = try self.json(from: WorkTimesJSONResource.workTimeMissingTaskKey)
        //Act
        let sut = try self.decoder.decode(WorkTimeDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 16239)
        XCTAssertFalse(sut.updatedByAdmin)
        XCTAssertEqual(sut.projectIdentifier, 3)
        XCTAssertEqual(sut.startsAt, startsAt)
        XCTAssertEqual(sut.endsAt, endsAt)
        XCTAssertEqual(sut.duration, 3600)
        XCTAssertEqual(sut.body, "Bracket - v2")
        XCTAssertNil(sut.task)
        XCTAssertEqual(sut.taskPreview, "task1")
        XCTAssertEqual(sut.userIdentifier, 11)
        XCTAssertEqual(sut.date, date)
        XCTAssertEqual(sut.project, project)
    }

    func testWorkTimeNullTaskPreview() throws {
        //Arrange
        var components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 21, hour: 15)
        let startsAt = try Calendar.current.date(from: components).unwrap()
        components.hour = 16
        let endsAt = try Calendar.current.date(from: components).unwrap()
        components.hour = 0
        let date = try Calendar.current.date(from: components).unwrap()
        let project = ProjectDecoder(identifier: 3, name: "Lorem Ipsum",
                                     color: UIColor(hexString: "fe0404"),
                                     autofill: nil, countDuration: nil,
                                     isActive: nil, isInternal: nil,
                                     isLunch: false, workTimesAllowsTask: false)
        let data = try self.json(from: WorkTimesJSONResource.workTimeNullTaskPreview)
        //Act
        let sut = try self.decoder.decode(WorkTimeDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 16239)
        XCTAssertFalse(sut.updatedByAdmin)
        XCTAssertEqual(sut.projectIdentifier, 3)
        XCTAssertEqual(sut.startsAt, startsAt)
        XCTAssertEqual(sut.endsAt, endsAt)
        XCTAssertEqual(sut.duration, 3600)
        XCTAssertEqual(sut.body, "Bracket - v2")
        XCTAssertEqual(sut.task, "https://www.example.com/task1")
        XCTAssertNil(sut.taskPreview)
        XCTAssertEqual(sut.userIdentifier, 11)
        XCTAssertEqual(sut.date, date)
        XCTAssertEqual(sut.project, project)
    }
    
    func testWorkTimesMissingTaskPreviewKey() throws {
        //Arrange
        var components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 21, hour: 15)
        let startsAt = try Calendar.current.date(from: components).unwrap()
        components.hour = 16
        let endsAt = try Calendar.current.date(from: components).unwrap()
        components.hour = 0
        let date = try Calendar.current.date(from: components).unwrap()
        let project = ProjectDecoder(identifier: 3, name: "Lorem Ipsum",
                                     color: UIColor(hexString: "fe0404"),
                                     autofill: nil, countDuration: nil,
                                     isActive: nil, isInternal: nil,
                                     isLunch: false, workTimesAllowsTask: false)
        let data = try self.json(from: WorkTimesJSONResource.workTimeMissingTaskPreviewKey)
        //Act
        let sut = try self.decoder.decode(WorkTimeDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 16239)
        XCTAssertFalse(sut.updatedByAdmin)
        XCTAssertEqual(sut.projectIdentifier, 3)
        XCTAssertEqual(sut.startsAt, startsAt)
        XCTAssertEqual(sut.endsAt, endsAt)
        XCTAssertEqual(sut.duration, 3600)
        XCTAssertEqual(sut.body, "Bracket - v2")
        XCTAssertEqual(sut.task, "https://www.example.com/task1")
        XCTAssertNil(sut.taskPreview)
        XCTAssertEqual(sut.userIdentifier, 11)
        XCTAssertEqual(sut.date, date)
        XCTAssertEqual(sut.project, project)
    }
}
