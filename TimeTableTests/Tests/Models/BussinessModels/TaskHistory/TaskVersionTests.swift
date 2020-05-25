//
//  TaskVersionTests.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 17/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class TaskVersionTests: XCTestCase {}

// MARK: - Decoding
extension TaskVersionTests {
    func testDecoding_fullModel() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionFullModel)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.createdAt, try self.buildDate(hour: 14, minute: 24))
        XCTAssertEqual(sut.changeset.count, 9)
        XCTAssert(sut.changeset.contains(.projectID))
        XCTAssert(sut.changeset.contains(.startsAt))
        XCTAssert(sut.changeset.contains(.endsAt))
        XCTAssert(sut.changeset.contains(.duration))
        XCTAssert(sut.changeset.contains(.body))
        XCTAssert(sut.changeset.contains(.task))
        XCTAssert(sut.changeset.contains(.taskPreview))
        XCTAssert(sut.changeset.contains(.date))
        XCTAssert(sut.changeset.contains(.tag))
        XCTAssertEqual(sut.workTime, try self.buildWorkTime())
    }
    
    // MARK: Event
    func testDecoding_unknownEvent() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionUnknownEvent)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertNil(sut.event)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.createdAt, try self.buildDate(hour: 14, minute: 24))
        XCTAssertEqual(sut.changeset.count, 9)
        XCTAssert(sut.changeset.contains(.projectID))
        XCTAssert(sut.changeset.contains(.startsAt))
        XCTAssert(sut.changeset.contains(.endsAt))
        XCTAssert(sut.changeset.contains(.duration))
        XCTAssert(sut.changeset.contains(.body))
        XCTAssert(sut.changeset.contains(.task))
        XCTAssert(sut.changeset.contains(.taskPreview))
        XCTAssert(sut.changeset.contains(.date))
        XCTAssert(sut.changeset.contains(.tag))
        XCTAssertEqual(sut.workTime, try self.buildWorkTime())
    }
    
    func testDecoding_updateEvent() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionUpdateEvent)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.createdAt, try self.buildDate(hour: 14, minute: 24))
        XCTAssertEqual(sut.changeset.count, 9)
        XCTAssert(sut.changeset.contains(.projectID))
        XCTAssert(sut.changeset.contains(.startsAt))
        XCTAssert(sut.changeset.contains(.endsAt))
        XCTAssert(sut.changeset.contains(.duration))
        XCTAssert(sut.changeset.contains(.body))
        XCTAssert(sut.changeset.contains(.task))
        XCTAssert(sut.changeset.contains(.taskPreview))
        XCTAssert(sut.changeset.contains(.date))
        XCTAssert(sut.changeset.contains(.tag))
        XCTAssertEqual(sut.workTime, try self.buildWorkTime())
    }
    
    func testDecoding_createEvent() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionCreateEvent)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .create)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.createdAt, try self.buildDate(hour: 14, minute: 24))
        XCTAssertEqual(sut.changeset.count, 9)
        XCTAssert(sut.changeset.contains(.projectID))
        XCTAssert(sut.changeset.contains(.startsAt))
        XCTAssert(sut.changeset.contains(.endsAt))
        XCTAssert(sut.changeset.contains(.duration))
        XCTAssert(sut.changeset.contains(.body))
        XCTAssert(sut.changeset.contains(.task))
        XCTAssert(sut.changeset.contains(.taskPreview))
        XCTAssert(sut.changeset.contains(.date))
        XCTAssert(sut.changeset.contains(.tag))
        XCTAssertEqual(sut.workTime, try self.buildWorkTime())
    }
    
    func testDecoding_nullEvent() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionNullEvent)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertNil(sut.event)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.createdAt, try self.buildDate(hour: 14, minute: 24))
        XCTAssertEqual(sut.changeset.count, 9)
        XCTAssert(sut.changeset.contains(.projectID))
        XCTAssert(sut.changeset.contains(.startsAt))
        XCTAssert(sut.changeset.contains(.endsAt))
        XCTAssert(sut.changeset.contains(.duration))
        XCTAssert(sut.changeset.contains(.body))
        XCTAssert(sut.changeset.contains(.task))
        XCTAssert(sut.changeset.contains(.taskPreview))
        XCTAssert(sut.changeset.contains(.date))
        XCTAssert(sut.changeset.contains(.tag))
        XCTAssertEqual(sut.workTime, try self.buildWorkTime())
    }
    
    func testDecoding_missingEventKey() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionMissingEventKey)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertNil(sut.event)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.createdAt, try self.buildDate(hour: 14, minute: 24))
        XCTAssertEqual(sut.changeset.count, 9)
        XCTAssert(sut.changeset.contains(.projectID))
        XCTAssert(sut.changeset.contains(.startsAt))
        XCTAssert(sut.changeset.contains(.endsAt))
        XCTAssert(sut.changeset.contains(.duration))
        XCTAssert(sut.changeset.contains(.body))
        XCTAssert(sut.changeset.contains(.task))
        XCTAssert(sut.changeset.contains(.taskPreview))
        XCTAssert(sut.changeset.contains(.date))
        XCTAssert(sut.changeset.contains(.tag))
        XCTAssertEqual(sut.workTime, try self.buildWorkTime())
    }
    
    // MARK: Changeset
    func testDecoding_changesetProjectChanged() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionChangesetProjectChanged)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.createdAt, try self.buildDate(hour: 14, minute: 24))
        XCTAssertEqual(sut.changeset.count, 1)
        XCTAssert(sut.changeset.contains(.projectID))
        XCTAssertEqual(sut.workTime, try self.buildWorkTime())
    }
    
    func testDecoding_changesetStartsAtChanged() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionChangesetStartsAtChanged)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.createdAt, try self.buildDate(hour: 14, minute: 24))
        XCTAssertEqual(sut.changeset.count, 1)
        XCTAssert(sut.changeset.contains(.startsAt))
        XCTAssertEqual(sut.workTime, try self.buildWorkTime())
    }
    
    func testDecoding_changesetEndsAtChanged() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionChangesetEndsAtChanged)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.createdAt, try self.buildDate(hour: 14, minute: 24))
        XCTAssertEqual(sut.changeset.count, 1)
        XCTAssert(sut.changeset.contains(.endsAt))
        XCTAssertEqual(sut.workTime, try self.buildWorkTime())
    }
    
    func testDecoding_changesetDurationChanged() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionChangesetDurationChanged)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.createdAt, try self.buildDate(hour: 14, minute: 24))
        XCTAssertEqual(sut.changeset.count, 1)
        XCTAssert(sut.changeset.contains(.duration))
        XCTAssertEqual(sut.workTime, try self.buildWorkTime())
    }
    
    func testDecoding_changesetBodyChanged() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionChangesetBodyChanged)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.createdAt, try self.buildDate(hour: 14, minute: 24))
        XCTAssertEqual(sut.changeset.count, 1)
        XCTAssert(sut.changeset.contains(.body))
        XCTAssertEqual(sut.workTime, try self.buildWorkTime())
    }
    
    func testDecoding_changesetTaskChanged() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionChangesetTaskChanged)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.createdAt, try self.buildDate(hour: 14, minute: 24))
        XCTAssertEqual(sut.changeset.count, 1)
        XCTAssert(sut.changeset.contains(.task))
        XCTAssertEqual(sut.workTime, try self.buildWorkTime())
    }
    
    func testDecoding_changesetTaskPreviewChanged() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionChangesetTaskPreviewChanged)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.createdAt, try self.buildDate(hour: 14, minute: 24))
        XCTAssertEqual(sut.changeset.count, 1)
        XCTAssert(sut.changeset.contains(.taskPreview))
        XCTAssertEqual(sut.workTime, try self.buildWorkTime())
    }
    
    func testDecoding_changesetDateChanged() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionChangesetDateChanged)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.createdAt, try self.buildDate(hour: 14, minute: 24))
        XCTAssertEqual(sut.changeset.count, 1)
        XCTAssert(sut.changeset.contains(.date))
        XCTAssertEqual(sut.workTime, try self.buildWorkTime())
    }
    
    func testDecoding_changesetTagChanged() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionChangesetTagChanged)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.createdAt, try self.buildDate(hour: 14, minute: 24))
        XCTAssertEqual(sut.changeset.count, 1)
        XCTAssert(sut.changeset.contains(.tag))
        XCTAssertEqual(sut.workTime, try self.buildWorkTime())
    }
    
    func testDecoding_changesetEmpty() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionChangesetEmpty)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.createdAt, try self.buildDate(hour: 14, minute: 24))
        XCTAssert(sut.changeset.isEmpty)
        XCTAssertEqual(sut.workTime, try self.buildWorkTime())
    }
    
    func testDecoding_changesetUnknownValue() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionChangesetUnknownValue)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.createdAt, try self.buildDate(hour: 14, minute: 24))
        XCTAssert(sut.changeset.isEmpty)
        XCTAssertEqual(sut.workTime, try self.buildWorkTime())
    }
}

// MARK: - Private
extension TaskVersionTests {
    private func buildWorkTime() throws -> WorkTimeDecoder {
        let wrapper = WorkTimeDecoderFactory.Wrapper(
            id: 1,
            updatedByAdmin: false,
            projectID: 2,
            startsAt: try self.buildDate(hour: 8),
            endsAt: try self.buildDate(hour: 10),
            duration: 7200,
            body: "My work",
            task: "https//jira.com/TASK-123",
            taskPreview: "TASK-123",
            userID: 3,
            project: try self.buildProject(),
            date: try self.buildDate(hour: 12, minute: 24),
            tag: .development,
            versions: [])
        return try WorkTimeDecoderFactory().build(wrapper: wrapper)
    }
    
    private func buildProject() throws -> SimpleProjectRecordDecoder {
        let wrapper = SimpleProjectRecordDecoderFactory.Wrapper(
            id: 2,
            name: "Foo",
            color: UIColor(hexString: "08e51a")!,
            countDuration: true,
            isLunch: false,
            workTimesAllowsTask: true,
            isTaggable: true)
        return try SimpleProjectRecordDecoderFactory().build(wrapper: wrapper)
    }
    
    private func buildDate(hour: Int, minute: Int = 0) throws -> Date {
        try self.buildDate(
            year: 2020,
            month: 5,
            day: 21,
            hour: hour,
            minute: minute)
    }
}
