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

// MARK: - changes
extension TaskVersionTests {
    func testChanges_unchanged() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskUnchangedResponse)
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Act
        let changes = sut.changes
        //Assert
        XCTAssert(changes.isEmpty)
    }
    
    func testChanges_changedProject() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskChangedProjectResponse)
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Act
        let changes = sut.changes
        //Assert
        XCTAssertEqual(changes.count, 1)
        XCTAssert(changes.contains(.projectName))
    }
    
    func testChanges_changedBody() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskChangedBodyResponse)
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Act
        let changes = sut.changes
        //Assert
        XCTAssertEqual(changes.count, 1)
        XCTAssert(changes.contains(.body))
    }
    
    func testChanges_changedStartsAt() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskChangedStartsAtResponse)
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Act
        let changes = sut.changes
        //Assert
        XCTAssertEqual(changes.count, 1)
        XCTAssert(changes.contains(.startsAt))
    }
    
    func testChanges_changedEndsAt() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskChangedEndsAtResponse)
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Act
        let changes = sut.changes
        //Assert
        XCTAssertEqual(changes.count, 1)
        XCTAssert(changes.contains(.endsAt))
    }
    
    func testChanges_changedTag() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskChangedTagResponse)
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Act
        let changes = sut.changes
        //Assert
        XCTAssertEqual(changes.count, 1)
        XCTAssert(changes.contains(.tag))
    }
    
    func testChanges_changedDuration() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskChangedDurationResponse)
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Act
        let changes = sut.changes
        //Assert
        XCTAssertEqual(changes.count, 1)
        XCTAssert(changes.contains(.duration))
    }
    
    func testChanges_changedTask() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskChangedTaskResponse)
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Act
        let changes = sut.changes
        //Assert
        XCTAssertEqual(changes.count, 1)
        XCTAssert(changes.contains(.task))
    }
    
    func testChange_changedTaskPreview() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskChangedTaskPreviewResponse)
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Act
        let changes = sut.changes
        //Assert
        XCTAssertEqual(changes.count, 1)
        XCTAssert(changes.contains(.task))
    }
    
    func testChanges_changedAll() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionFullModel)
        let sut = try self.decoder.decode(TaskVersion.self, from: data)
        //Act
        let changes = sut.changes
        //Assert
        XCTAssertEqual(changes.count, 7)
        XCTAssert(changes.contains(.projectName))
        XCTAssert(changes.contains(.body))
        XCTAssert(changes.contains(.startsAt))
        XCTAssert(changes.contains(.endsAt))
        XCTAssert(changes.contains(.tag))
        XCTAssert(changes.contains(.duration))
        XCTAssert(changes.contains(.task))
    }
}

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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    // MARK: Task
    func testDecoding_nullPreviousTask() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionNullPreviousTask)
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
        XCTAssertNil(sut.task.previous)
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    func testDecoding_missingPreviousTaskKey() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionMissingPreviousTaskKey)
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
        XCTAssertNil(sut.task.previous)
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    func testDecoding_nullCurrentTask() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionNullCurrentTask)
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertNil(sut.task.current)
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    func testDecoding_missingCurrentTaskKey() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionMissingCurrentTaskKey)
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertNil(sut.task.current)
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    // MARK: - Task Preview
    func testDecoding_nullPreviousTaskPreview() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionNullPreviousTaskPreview)
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertNil(sut.taskPreview.previous)
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    func testDecoding_missingPreviousTaskPreviewKey() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionMissingPreviousTaskPreviewKey)
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertNil(sut.taskPreview.previous)
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    func testDecoding_nullCurrentTaskPreview() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionNullCurrentTaskPreview)
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertNil(sut.taskPreview.current)
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertEqual(sut.duration.current, 1800)
    }
    
    func testDecoding_missingCurrentTaskPreviewKey() throws {
        //Arrange
        let data = try self.json(from: TaskVersionJSONResource.taskVersionMissingCurrentTaskPreviewKey)
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertNil(sut.taskPreview.current)
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
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
        XCTAssertEqual(sut.task.previous, "TIM-70")
        XCTAssertEqual(sut.task.current, "TIM-71")
        XCTAssertEqual(sut.taskPreview.previous, "TIM-147")
        XCTAssertEqual(sut.taskPreview.current, "TIM-148")
        XCTAssertEqual(sut.duration.previous, 600)
        XCTAssertNil(sut.duration.current)
    }
}

// MARK: - Private
extension TaskVersionTests {
    private func createdAt() throws -> Date {
        return try self.buildDate(timeZone: self.utcTimeZone(), year: 2020, month: 3, day: 17, hour: 9, minute: 15, second: 4)
    }
    
    private func previousStartsAt() throws -> Date {
        return try self.buildDate(timeZone: self.utcTimeZone(), year: 2020, month: 3, day: 17, hour: 9, minute: 0, second: 0)
    }
    
    private func currentStartsAt() throws -> Date {
        return try self.buildDate(timeZone: self.utcTimeZone(), year: 2020, month: 3, day: 17, hour: 8, minute: 50, second: 0)
    }
    
    private func previousEndsAt() throws -> Date {
        return try self.buildDate(timeZone: self.utcTimeZone(), year: 2020, month: 3, day: 17, hour: 9, minute: 10, second: 0)
    }
    
    private func currentEndsAt() throws -> Date {
        return try self.buildDate(timeZone: self.utcTimeZone(), year: 2020, month: 3, day: 17, hour: 9, minute: 20, second: 0)
    }
    
    private func utcTimeZone() throws -> TimeZone {
        return try XCTUnwrap(TimeZone(secondsFromGMT: 0))
    }
}
// swiftlint:disable:this file_length
