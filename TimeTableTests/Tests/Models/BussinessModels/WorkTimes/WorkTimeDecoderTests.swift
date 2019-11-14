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
        let worksTime = try self.decoder.decode(WorkTimeDecoder.self, from: data)
        //Assert
        XCTAssertEqual(worksTime.identifier, 16239)
        XCTAssertFalse(worksTime.updatedByAdmin)
        XCTAssertEqual(worksTime.projectIdentifier, 3)
        XCTAssertEqual(worksTime.startsAt, startsAt)
        XCTAssertEqual(worksTime.endsAt, endsAt)
        XCTAssertEqual(worksTime.duration, 3600)
        XCTAssertEqual(worksTime.body, "Bracket - v2")
        XCTAssertEqual(worksTime.task, "https://www.example.com/task1")
        XCTAssertEqual(worksTime.taskPreview, "task1")
        XCTAssertEqual(worksTime.userIdentifier, 11)
        XCTAssertEqual(worksTime.date, date)
        XCTAssertEqual(worksTime.project, project)
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
        let worksTime = try self.decoder.decode(WorkTimeDecoder.self, from: data)
        //Assert
        XCTAssertEqual(worksTime.identifier, 16239)
        XCTAssertFalse(worksTime.updatedByAdmin)
        XCTAssertEqual(worksTime.projectIdentifier, 3)
        XCTAssertEqual(worksTime.startsAt, startsAt)
        XCTAssertEqual(worksTime.endsAt, endsAt)
        XCTAssertEqual(worksTime.duration, 3600)
        XCTAssertNil(worksTime.body)
        XCTAssertEqual(worksTime.task, "https://www.example.com/task1")
        XCTAssertEqual(worksTime.taskPreview, "task1")
        XCTAssertEqual(worksTime.userIdentifier, 11)
        XCTAssertEqual(worksTime.date, date)
        XCTAssertEqual(worksTime.project, project)
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
        let worksTime = try self.decoder.decode(WorkTimeDecoder.self, from: data)
        //Assert
        XCTAssertEqual(worksTime.identifier, 16239)
        XCTAssertFalse(worksTime.updatedByAdmin)
        XCTAssertEqual(worksTime.projectIdentifier, 3)
        XCTAssertEqual(worksTime.startsAt, startsAt)
        XCTAssertEqual(worksTime.endsAt, endsAt)
        XCTAssertEqual(worksTime.duration, 3600)
        XCTAssertNil(worksTime.body)
        XCTAssertEqual(worksTime.task, "https://www.example.com/task1")
        XCTAssertEqual(worksTime.taskPreview, "task1")
        XCTAssertEqual(worksTime.userIdentifier, 11)
        XCTAssertEqual(worksTime.date, date)
        XCTAssertEqual(worksTime.project, project)
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
        let worksTime = try self.decoder.decode(WorkTimeDecoder.self, from: data)
        //Assert
        XCTAssertEqual(worksTime.identifier, 16239)
        XCTAssertFalse(worksTime.updatedByAdmin)
        XCTAssertEqual(worksTime.projectIdentifier, 3)
        XCTAssertEqual(worksTime.startsAt, startsAt)
        XCTAssertEqual(worksTime.endsAt, endsAt)
        XCTAssertEqual(worksTime.duration, 3600)
        XCTAssertEqual(worksTime.body, "Bracket - v2")
        XCTAssertNil(worksTime.task)
        XCTAssertEqual(worksTime.taskPreview, "task1")
        XCTAssertEqual(worksTime.userIdentifier, 11)
        XCTAssertEqual(worksTime.date, date)
        XCTAssertEqual(worksTime.project, project)
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
        let worksTime = try self.decoder.decode(WorkTimeDecoder.self, from: data)
        //Assert
        XCTAssertEqual(worksTime.identifier, 16239)
        XCTAssertFalse(worksTime.updatedByAdmin)
        XCTAssertEqual(worksTime.projectIdentifier, 3)
        XCTAssertEqual(worksTime.startsAt, startsAt)
        XCTAssertEqual(worksTime.endsAt, endsAt)
        XCTAssertEqual(worksTime.duration, 3600)
        XCTAssertEqual(worksTime.body, "Bracket - v2")
        XCTAssertNil(worksTime.task)
        XCTAssertEqual(worksTime.taskPreview, "task1")
        XCTAssertEqual(worksTime.userIdentifier, 11)
        XCTAssertEqual(worksTime.date, date)
        XCTAssertEqual(worksTime.project, project)
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
        let worksTime = try self.decoder.decode(WorkTimeDecoder.self, from: data)
        //Assert
        XCTAssertEqual(worksTime.identifier, 16239)
        XCTAssertFalse(worksTime.updatedByAdmin)
        XCTAssertEqual(worksTime.projectIdentifier, 3)
        XCTAssertEqual(worksTime.startsAt, startsAt)
        XCTAssertEqual(worksTime.endsAt, endsAt)
        XCTAssertEqual(worksTime.duration, 3600)
        XCTAssertEqual(worksTime.body, "Bracket - v2")
        XCTAssertEqual(worksTime.task, "https://www.example.com/task1")
        XCTAssertNil(worksTime.taskPreview)
        XCTAssertEqual(worksTime.userIdentifier, 11)
        XCTAssertEqual(worksTime.date, date)
        XCTAssertEqual(worksTime.project, project)
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
        let worksTime = try self.decoder.decode(WorkTimeDecoder.self, from: data)
        //Assert
        XCTAssertEqual(worksTime.identifier, 16239)
        XCTAssertFalse(worksTime.updatedByAdmin)
        XCTAssertEqual(worksTime.projectIdentifier, 3)
        XCTAssertEqual(worksTime.startsAt, startsAt)
        XCTAssertEqual(worksTime.endsAt, endsAt)
        XCTAssertEqual(worksTime.duration, 3600)
        XCTAssertEqual(worksTime.body, "Bracket - v2")
        XCTAssertEqual(worksTime.task, "https://www.example.com/task1")
        XCTAssertNil(worksTime.taskPreview)
        XCTAssertEqual(worksTime.userIdentifier, 11)
        XCTAssertEqual(worksTime.date, date)
        XCTAssertEqual(worksTime.project, project)
    }
}
