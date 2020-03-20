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
        XCTAssertEqual(sut.updatedAt, try self.createdAt())
        XCTAssertEqual(sut.projectName.previous, "Misc")
        XCTAssertEqual(sut.projectName.current, "TimeTable")
        XCTAssertEqual(sut.body.previous, "old task body")
        XCTAssertEqual(sut.body.current, "new task body")
        XCTAssertEqual(sut.startsAt.previous, try self.previousStartsAt())
        XCTAssertEqual(sut.startsAt.current, try self.currentStartsAt())
        XCTAssertEqual(sut.endsAt.previous, try self.previousEndsAt())
        XCTAssertEqual(sut.endsAt.current, try self.currentEndsAt())
        XCTAssertEqual(sut.tag.previous, .development)
        XCTAssertEqual(sut.tag.current, .internalMeeting)
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
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
        XCTAssertEqual(sut.updatedAt, try self.createdAt())
        XCTAssertEqual(sut.projectName.previous, "Misc")
        XCTAssertEqual(sut.projectName.current, "TimeTable")
        XCTAssertEqual(sut.body.previous, "old task body")
        XCTAssertEqual(sut.body.current, "new task body")
        XCTAssertEqual(sut.startsAt.previous, try self.previousStartsAt())
        XCTAssertEqual(sut.startsAt.current, try self.currentStartsAt())
        XCTAssertEqual(sut.endsAt.previous, try self.previousEndsAt())
        XCTAssertEqual(sut.endsAt.current, try self.currentEndsAt())
        XCTAssertEqual(sut.tag.previous, .development)
        XCTAssertEqual(sut.tag.current, .internalMeeting)
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    func testDecoding_nullEvent() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionNullEvent)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertNil(sut.event)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.updatedAt, try self.createdAt())
        XCTAssertEqual(sut.projectName.previous, "Misc")
        XCTAssertEqual(sut.projectName.current, "TimeTable")
        XCTAssertEqual(sut.body.previous, "old task body")
        XCTAssertEqual(sut.body.current, "new task body")
        XCTAssertEqual(sut.startsAt.previous, try self.previousStartsAt())
        XCTAssertEqual(sut.startsAt.current, try self.currentStartsAt())
        XCTAssertEqual(sut.endsAt.previous, try self.previousEndsAt())
        XCTAssertEqual(sut.endsAt.current, try self.currentEndsAt())
        XCTAssertEqual(sut.tag.previous, .development)
        XCTAssertEqual(sut.tag.current, .internalMeeting)
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    func testDecoding_missingEventKey() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionMissingEventKey)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertNil(sut.event)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.updatedAt, try self.createdAt())
        XCTAssertEqual(sut.projectName.previous, "Misc")
        XCTAssertEqual(sut.projectName.current, "TimeTable")
        XCTAssertEqual(sut.body.previous, "old task body")
        XCTAssertEqual(sut.body.current, "new task body")
        XCTAssertEqual(sut.startsAt.previous, try self.previousStartsAt())
        XCTAssertEqual(sut.startsAt.current, try self.currentStartsAt())
        XCTAssertEqual(sut.endsAt.previous, try self.previousEndsAt())
        XCTAssertEqual(sut.endsAt.current, try self.currentEndsAt())
        XCTAssertEqual(sut.tag.previous, .development)
        XCTAssertEqual(sut.tag.current, .internalMeeting)
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    // MARK: Project name
    func testDecoding_nullPreviousProjectName() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionNullPreviousProjectName)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.updatedAt, try self.createdAt())
        XCTAssertNil(sut.projectName.previous)
        XCTAssertEqual(sut.projectName.current, "TimeTable")
        XCTAssertEqual(sut.body.previous, "old task body")
        XCTAssertEqual(sut.body.current, "new task body")
        XCTAssertEqual(sut.startsAt.previous, try self.previousStartsAt())
        XCTAssertEqual(sut.startsAt.current, try self.currentStartsAt())
        XCTAssertEqual(sut.endsAt.previous, try self.previousEndsAt())
        XCTAssertEqual(sut.endsAt.current, try self.currentEndsAt())
        XCTAssertEqual(sut.tag.previous, .development)
        XCTAssertEqual(sut.tag.current, .internalMeeting)
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    func testDecoding_missingPreviousProjectNameKey() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionMissingPreviousProjectNameKey)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.updatedAt, try self.createdAt())
        XCTAssertNil(sut.projectName.previous)
        XCTAssertEqual(sut.projectName.current, "TimeTable")
        XCTAssertEqual(sut.body.previous, "old task body")
        XCTAssertEqual(sut.body.current, "new task body")
        XCTAssertEqual(sut.startsAt.previous, try self.previousStartsAt())
        XCTAssertEqual(sut.startsAt.current, try self.currentStartsAt())
        XCTAssertEqual(sut.endsAt.previous, try self.previousEndsAt())
        XCTAssertEqual(sut.endsAt.current, try self.currentEndsAt())
        XCTAssertEqual(sut.tag.previous, .development)
        XCTAssertEqual(sut.tag.current, .internalMeeting)
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    func testDecoding_nullCurrentProjectName() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionNullCurrentProjectName)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.updatedAt, try self.createdAt())
        XCTAssertEqual(sut.projectName.previous, "Misc")
        XCTAssertNil(sut.projectName.current)
        XCTAssertEqual(sut.body.previous, "old task body")
        XCTAssertEqual(sut.body.current, "new task body")
        XCTAssertEqual(sut.startsAt.previous, try self.previousStartsAt())
        XCTAssertEqual(sut.startsAt.current, try self.currentStartsAt())
        XCTAssertEqual(sut.endsAt.previous, try self.previousEndsAt())
        XCTAssertEqual(sut.endsAt.current, try self.currentEndsAt())
        XCTAssertEqual(sut.tag.previous, .development)
        XCTAssertEqual(sut.tag.current, .internalMeeting)
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    func testDecoding_missingCurrentProjectNameKey() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionMissingCurrentProjectNameKey)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.updatedAt, try self.createdAt())
        XCTAssertEqual(sut.projectName.previous, "Misc")
        XCTAssertNil(sut.projectName.current)
        XCTAssertEqual(sut.body.previous, "old task body")
        XCTAssertEqual(sut.body.current, "new task body")
        XCTAssertEqual(sut.startsAt.previous, try self.previousStartsAt())
        XCTAssertEqual(sut.startsAt.current, try self.currentStartsAt())
        XCTAssertEqual(sut.endsAt.previous, try self.previousEndsAt())
        XCTAssertEqual(sut.endsAt.current, try self.currentEndsAt())
        XCTAssertEqual(sut.tag.previous, .development)
        XCTAssertEqual(sut.tag.current, .internalMeeting)
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    func testDecoding_nullProjectName() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionNullProjectName)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.updatedAt, try self.createdAt())
        XCTAssertNil(sut.projectName.previous)
        XCTAssertNil(sut.projectName.current)
        XCTAssertEqual(sut.body.previous, "old task body")
        XCTAssertEqual(sut.body.current, "new task body")
        XCTAssertEqual(sut.startsAt.previous, try self.previousStartsAt())
        XCTAssertEqual(sut.startsAt.current, try self.currentStartsAt())
        XCTAssertEqual(sut.endsAt.previous, try self.previousEndsAt())
        XCTAssertEqual(sut.endsAt.current, try self.currentEndsAt())
        XCTAssertEqual(sut.tag.previous, .development)
        XCTAssertEqual(sut.tag.current, .internalMeeting)
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    func testDecoding_missingProjectNameKeys() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionMissingProjectNameKeys)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.updatedAt, try self.createdAt())
        XCTAssertNil(sut.projectName.previous)
        XCTAssertNil(sut.projectName.current)
        XCTAssertEqual(sut.body.previous, "old task body")
        XCTAssertEqual(sut.body.current, "new task body")
        XCTAssertEqual(sut.startsAt.previous, try self.previousStartsAt())
        XCTAssertEqual(sut.startsAt.current, try self.currentStartsAt())
        XCTAssertEqual(sut.endsAt.previous, try self.previousEndsAt())
        XCTAssertEqual(sut.endsAt.current, try self.currentEndsAt())
        XCTAssertEqual(sut.tag.previous, .development)
        XCTAssertEqual(sut.tag.current, .internalMeeting)
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    // MARK: Body
    func testDecoding_nullPreviousBody() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionNullPreviousBody)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.updatedAt, try self.createdAt())
        XCTAssertEqual(sut.projectName.previous, "Misc")
        XCTAssertEqual(sut.projectName.current, "TimeTable")
        XCTAssertNil(sut.body.previous)
        XCTAssertEqual(sut.body.current, "new task body")
        XCTAssertEqual(sut.startsAt.previous, try self.previousStartsAt())
        XCTAssertEqual(sut.startsAt.current, try self.currentStartsAt())
        XCTAssertEqual(sut.endsAt.previous, try self.previousEndsAt())
        XCTAssertEqual(sut.endsAt.current, try self.currentEndsAt())
        XCTAssertEqual(sut.tag.previous, .development)
        XCTAssertEqual(sut.tag.current, .internalMeeting)
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    func testDecoding_missingPreviousBodyKey() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionMissingPreviousBodyKey)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.updatedAt, try self.createdAt())
        XCTAssertEqual(sut.projectName.previous, "Misc")
        XCTAssertEqual(sut.projectName.current, "TimeTable")
        XCTAssertNil(sut.body.previous)
        XCTAssertEqual(sut.body.current, "new task body")
        XCTAssertEqual(sut.startsAt.previous, try self.previousStartsAt())
        XCTAssertEqual(sut.startsAt.current, try self.currentStartsAt())
        XCTAssertEqual(sut.endsAt.previous, try self.previousEndsAt())
        XCTAssertEqual(sut.endsAt.current, try self.currentEndsAt())
        XCTAssertEqual(sut.tag.previous, .development)
        XCTAssertEqual(sut.tag.current, .internalMeeting)
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    func testDecoding_nullCurrentBody() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionNullCurrentBody)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.updatedAt, try self.createdAt())
        XCTAssertEqual(sut.projectName.previous, "Misc")
        XCTAssertEqual(sut.projectName.current, "TimeTable")
        XCTAssertEqual(sut.body.previous, "old task body")
        XCTAssertNil(sut.body.current)
        XCTAssertEqual(sut.startsAt.previous, try self.previousStartsAt())
        XCTAssertEqual(sut.startsAt.current, try self.currentStartsAt())
        XCTAssertEqual(sut.endsAt.previous, try self.previousEndsAt())
        XCTAssertEqual(sut.endsAt.current, try self.currentEndsAt())
        XCTAssertEqual(sut.tag.previous, .development)
        XCTAssertEqual(sut.tag.current, .internalMeeting)
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    func testDecoding_missingCurrentBodyKey() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionMissingCurrentBodyKey)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.updatedAt, try self.createdAt())
        XCTAssertEqual(sut.projectName.previous, "Misc")
        XCTAssertEqual(sut.projectName.current, "TimeTable")
        XCTAssertEqual(sut.body.previous, "old task body")
        XCTAssertNil(sut.body.current)
        XCTAssertEqual(sut.startsAt.previous, try self.previousStartsAt())
        XCTAssertEqual(sut.startsAt.current, try self.currentStartsAt())
        XCTAssertEqual(sut.endsAt.previous, try self.previousEndsAt())
        XCTAssertEqual(sut.endsAt.current, try self.currentEndsAt())
        XCTAssertEqual(sut.tag.previous, .development)
        XCTAssertEqual(sut.tag.current, .internalMeeting)
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    // MARK: Starts at
    func testDecoding_nullPreviousStartsAt() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionNullPreviousStartsAt)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.updatedAt, try self.createdAt())
        XCTAssertEqual(sut.projectName.previous, "Misc")
        XCTAssertEqual(sut.projectName.current, "TimeTable")
        XCTAssertEqual(sut.body.previous, "old task body")
        XCTAssertEqual(sut.body.current, "new task body")
        XCTAssertNil(sut.startsAt.previous)
        XCTAssertEqual(sut.startsAt.current, try self.currentStartsAt())
        XCTAssertEqual(sut.endsAt.previous, try self.previousEndsAt())
        XCTAssertEqual(sut.endsAt.current, try self.currentEndsAt())
        XCTAssertEqual(sut.tag.previous, .development)
        XCTAssertEqual(sut.tag.current, .internalMeeting)
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    func testDecoding_missingPreviousStartsAtKey() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionMissingPreviousStartsAtKey)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.updatedAt, try self.createdAt())
        XCTAssertEqual(sut.projectName.previous, "Misc")
        XCTAssertEqual(sut.projectName.current, "TimeTable")
        XCTAssertEqual(sut.body.previous, "old task body")
        XCTAssertEqual(sut.body.current, "new task body")
        XCTAssertNil(sut.startsAt.previous)
        XCTAssertEqual(sut.startsAt.current, try self.currentStartsAt())
        XCTAssertEqual(sut.endsAt.previous, try self.previousEndsAt())
        XCTAssertEqual(sut.endsAt.current, try self.currentEndsAt())
        XCTAssertEqual(sut.tag.previous, .development)
        XCTAssertEqual(sut.tag.current, .internalMeeting)
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    func testDecoding_nullCurrentStartsAt() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionNullCurrentStartsAt)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.updatedAt, try self.createdAt())
        XCTAssertEqual(sut.projectName.previous, "Misc")
        XCTAssertEqual(sut.projectName.current, "TimeTable")
        XCTAssertEqual(sut.body.previous, "old task body")
        XCTAssertEqual(sut.body.current, "new task body")
        XCTAssertEqual(sut.startsAt.previous, try self.previousStartsAt())
        XCTAssertNil(sut.startsAt.current)
        XCTAssertEqual(sut.endsAt.previous, try self.previousEndsAt())
        XCTAssertEqual(sut.endsAt.current, try self.currentEndsAt())
        XCTAssertEqual(sut.tag.previous, .development)
        XCTAssertEqual(sut.tag.current, .internalMeeting)
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    func testDecoding_missingCurrentStartsAtKey() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionMissingCurrentStartsAtKey)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.updatedAt, try self.createdAt())
        XCTAssertEqual(sut.projectName.previous, "Misc")
        XCTAssertEqual(sut.projectName.current, "TimeTable")
        XCTAssertEqual(sut.body.previous, "old task body")
        XCTAssertEqual(sut.body.current, "new task body")
        XCTAssertEqual(sut.startsAt.previous, try self.previousStartsAt())
        XCTAssertNil(sut.startsAt.current)
        XCTAssertEqual(sut.endsAt.previous, try self.previousEndsAt())
        XCTAssertEqual(sut.endsAt.current, try self.currentEndsAt())
        XCTAssertEqual(sut.tag.previous, .development)
        XCTAssertEqual(sut.tag.current, .internalMeeting)
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    // MARK: Ends at
    func testDecoding_nullPreviousEndsAt() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionNullPreviousEndsAt)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.updatedAt, try self.createdAt())
        XCTAssertEqual(sut.projectName.previous, "Misc")
        XCTAssertEqual(sut.projectName.current, "TimeTable")
        XCTAssertEqual(sut.body.previous, "old task body")
        XCTAssertEqual(sut.body.current, "new task body")
        XCTAssertEqual(sut.startsAt.previous, try self.previousStartsAt())
        XCTAssertEqual(sut.startsAt.current, try self.currentStartsAt())
        XCTAssertNil(sut.endsAt.previous)
        XCTAssertEqual(sut.endsAt.current, try self.currentEndsAt())
        XCTAssertEqual(sut.tag.previous, .development)
        XCTAssertEqual(sut.tag.current, .internalMeeting)
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    func testDecoding_missingPreviousEndsAtKey() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionMissingPreviousEndsAtKey)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.updatedAt, try self.createdAt())
        XCTAssertEqual(sut.projectName.previous, "Misc")
        XCTAssertEqual(sut.projectName.current, "TimeTable")
        XCTAssertEqual(sut.body.previous, "old task body")
        XCTAssertEqual(sut.body.current, "new task body")
        XCTAssertEqual(sut.startsAt.previous, try self.previousStartsAt())
        XCTAssertEqual(sut.startsAt.current, try self.currentStartsAt())
        XCTAssertNil(sut.endsAt.previous)
        XCTAssertEqual(sut.endsAt.current, try self.currentEndsAt())
        XCTAssertEqual(sut.tag.previous, .development)
        XCTAssertEqual(sut.tag.current, .internalMeeting)
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    func testDecoding_nullCurrentEndsAt() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionNullCurrentEndsAt)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.updatedAt, try self.createdAt())
        XCTAssertEqual(sut.projectName.previous, "Misc")
        XCTAssertEqual(sut.projectName.current, "TimeTable")
        XCTAssertEqual(sut.body.previous, "old task body")
        XCTAssertEqual(sut.body.current, "new task body")
        XCTAssertEqual(sut.startsAt.previous, try self.previousStartsAt())
        XCTAssertEqual(sut.startsAt.current, try self.currentStartsAt())
        XCTAssertEqual(sut.endsAt.previous, try self.previousEndsAt())
        XCTAssertNil(sut.endsAt.current)
        XCTAssertEqual(sut.tag.previous, .development)
        XCTAssertEqual(sut.tag.current, .internalMeeting)
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    func testDecoding_missingCurrentEndsAtKey() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionMissingCurrentEndsAtKey)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.updatedAt, try self.createdAt())
        XCTAssertEqual(sut.projectName.previous, "Misc")
        XCTAssertEqual(sut.projectName.current, "TimeTable")
        XCTAssertEqual(sut.body.previous, "old task body")
        XCTAssertEqual(sut.body.current, "new task body")
        XCTAssertEqual(sut.startsAt.previous, try self.previousStartsAt())
        XCTAssertEqual(sut.startsAt.current, try self.currentStartsAt())
        XCTAssertEqual(sut.endsAt.previous, try self.previousEndsAt())
        XCTAssertNil(sut.endsAt.current)
        XCTAssertEqual(sut.tag.previous, .development)
        XCTAssertEqual(sut.tag.current, .internalMeeting)
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    // MARK: Tag
    func testDecoding_nullPreviousTag() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionNullPreviousTag)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.updatedAt, try self.createdAt())
        XCTAssertEqual(sut.projectName.previous, "Misc")
        XCTAssertEqual(sut.projectName.current, "TimeTable")
        XCTAssertEqual(sut.body.previous, "old task body")
        XCTAssertEqual(sut.body.current, "new task body")
        XCTAssertEqual(sut.startsAt.previous, try self.previousStartsAt())
        XCTAssertEqual(sut.startsAt.current, try self.currentStartsAt())
        XCTAssertEqual(sut.endsAt.previous, try self.previousEndsAt())
        XCTAssertEqual(sut.endsAt.current, try self.currentEndsAt())
        XCTAssertNil(sut.tag.previous)
        XCTAssertEqual(sut.tag.current, .internalMeeting)
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    func testDecoding_missingPreviousTagKey() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionMissingPreviousTagKey)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.updatedAt, try self.createdAt())
        XCTAssertEqual(sut.projectName.previous, "Misc")
        XCTAssertEqual(sut.projectName.current, "TimeTable")
        XCTAssertEqual(sut.body.previous, "old task body")
        XCTAssertEqual(sut.body.current, "new task body")
        XCTAssertEqual(sut.startsAt.previous, try self.previousStartsAt())
        XCTAssertEqual(sut.startsAt.current, try self.currentStartsAt())
        XCTAssertEqual(sut.endsAt.previous, try self.previousEndsAt())
        XCTAssertEqual(sut.endsAt.current, try self.currentEndsAt())
        XCTAssertNil(sut.tag.previous)
        XCTAssertEqual(sut.tag.current, .internalMeeting)
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    func testDecoding_nullCurrentTag() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionNullCurrentTag)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.updatedAt, try self.createdAt())
        XCTAssertEqual(sut.projectName.previous, "Misc")
        XCTAssertEqual(sut.projectName.current, "TimeTable")
        XCTAssertEqual(sut.body.previous, "old task body")
        XCTAssertEqual(sut.body.current, "new task body")
        XCTAssertEqual(sut.startsAt.previous, try self.previousStartsAt())
        XCTAssertEqual(sut.startsAt.current, try self.currentStartsAt())
        XCTAssertEqual(sut.endsAt.previous, try self.previousEndsAt())
        XCTAssertEqual(sut.endsAt.current, try self.currentEndsAt())
        XCTAssertEqual(sut.tag.previous, .development)
        XCTAssertNil(sut.tag.current)
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    func testDecoding_missingCurrentTagKey() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionMissingCurrentTagKey)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.updatedAt, try self.createdAt())
        XCTAssertEqual(sut.projectName.previous, "Misc")
        XCTAssertEqual(sut.projectName.current, "TimeTable")
        XCTAssertEqual(sut.body.previous, "old task body")
        XCTAssertEqual(sut.body.current, "new task body")
        XCTAssertEqual(sut.startsAt.previous, try self.previousStartsAt())
        XCTAssertEqual(sut.startsAt.current, try self.currentStartsAt())
        XCTAssertEqual(sut.endsAt.previous, try self.previousEndsAt())
        XCTAssertEqual(sut.endsAt.current, try self.currentEndsAt())
        XCTAssertEqual(sut.tag.previous, .development)
        XCTAssertNil(sut.tag.current)
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    // MARK: Duration
    func testDecoding_nullPreviousDuration() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionNullPreviousDuration)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.updatedAt, try self.createdAt())
        XCTAssertEqual(sut.projectName.previous, "Misc")
        XCTAssertEqual(sut.projectName.current, "TimeTable")
        XCTAssertEqual(sut.body.previous, "old task body")
        XCTAssertEqual(sut.body.current, "new task body")
        XCTAssertEqual(sut.startsAt.previous, try self.previousStartsAt())
        XCTAssertEqual(sut.startsAt.current, try self.currentStartsAt())
        XCTAssertEqual(sut.endsAt.previous, try self.previousEndsAt())
        XCTAssertEqual(sut.endsAt.current, try self.currentEndsAt())
        XCTAssertEqual(sut.tag.previous, .development)
        XCTAssertEqual(sut.tag.current, .internalMeeting)
        XCTAssertNil(sut.duration.previous)
        XCTAssertEqual(sut.duration.current, 1800)
    }

    func testDecoding_missingPreviousDurationKey() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionMissingPreviousDurationKey)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.updatedAt, try self.createdAt())
        XCTAssertEqual(sut.projectName.previous, "Misc")
        XCTAssertEqual(sut.projectName.current, "TimeTable")
        XCTAssertEqual(sut.body.previous, "old task body")
        XCTAssertEqual(sut.body.current, "new task body")
        XCTAssertEqual(sut.startsAt.previous, try self.previousStartsAt())
        XCTAssertEqual(sut.startsAt.current, try self.currentStartsAt())
        XCTAssertEqual(sut.endsAt.previous, try self.previousEndsAt())
        XCTAssertEqual(sut.endsAt.current, try self.currentEndsAt())
        XCTAssertEqual(sut.tag.previous, .development)
        XCTAssertEqual(sut.tag.current, .internalMeeting)
        XCTAssertNil(sut.duration.previous)
        XCTAssertEqual(sut.duration.current, 1800)
    }

    func testDecoding_nullCurrentDuration() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionNullCurrentDuration)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.updatedAt, try self.createdAt())
        XCTAssertEqual(sut.projectName.previous, "Misc")
        XCTAssertEqual(sut.projectName.current, "TimeTable")
        XCTAssertEqual(sut.body.previous, "old task body")
        XCTAssertEqual(sut.body.current, "new task body")
        XCTAssertEqual(sut.startsAt.previous, try self.previousStartsAt())
        XCTAssertEqual(sut.startsAt.current, try self.currentStartsAt())
        XCTAssertEqual(sut.endsAt.previous, try self.previousEndsAt())
        XCTAssertEqual(sut.endsAt.current, try self.currentEndsAt())
        XCTAssertEqual(sut.tag.previous, .development)
        XCTAssertEqual(sut.tag.current, .internalMeeting)
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertNil(sut.duration.current)
    }
    
    func testDecoding_missingCurrentDurationKey() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionMissingCurrentDurationKey)
        //Act
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Assert
        XCTAssertEqual(sut.event, .update)
        XCTAssertEqual(sut.updatedBy, "Some Developer")
        XCTAssertEqual(sut.updatedAt, try self.createdAt())
        XCTAssertEqual(sut.projectName.previous, "Misc")
        XCTAssertEqual(sut.projectName.current, "TimeTable")
        XCTAssertEqual(sut.body.previous, "old task body")
        XCTAssertEqual(sut.body.current, "new task body")
        XCTAssertEqual(sut.startsAt.previous, try self.previousStartsAt())
        XCTAssertEqual(sut.startsAt.current, try self.currentStartsAt())
        XCTAssertEqual(sut.endsAt.previous, try self.previousEndsAt())
        XCTAssertEqual(sut.endsAt.current, try self.currentEndsAt())
        XCTAssertEqual(sut.tag.previous, .development)
        XCTAssertEqual(sut.tag.current, .internalMeeting)
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertNil(sut.duration.current)
    }
}

// MARK: - Private
extension TaskVersionTests {
    private func createdAt() throws -> Date {
        return try self.buildDate(timeZone: try self.utcTimeZone(), year: 2020, month: 3, day: 17, hour: 9, minute: 15, second: 4)
    }
    
    private func previousStartsAt() throws -> Date {
        return try self.buildDate(timeZone: try self.utcTimeZone(), year: 2020, month: 3, day: 17, hour: 9, minute: 0, second: 0)
    }
    
    private func currentStartsAt() throws -> Date {
        return try self.buildDate(timeZone: try self.utcTimeZone(), year: 2020, month: 3, day: 17, hour: 8, minute: 50, second: 0)
    }
    
    private func previousEndsAt() throws -> Date {
        return try self.buildDate(timeZone: try self.utcTimeZone(), year: 2020, month: 3, day: 17, hour: 9, minute: 10, second: 0)
    }
    
    private func currentEndsAt() throws -> Date {
        return try self.buildDate(timeZone: try self.utcTimeZone(), year: 2020, month: 3, day: 17, hour: 9, minute: 20, second: 0)
    }
    
    private func utcTimeZone() throws -> TimeZone {
        return try XCTUnwrap(TimeZone(secondsFromGMT: 0))
    }
}
// swiftlint:disable:this file_length