//
//  WorkTimeValidationErrorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 14/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class WorkTimeValidationErrorTests: XCTestCase {}

// MARK: - Decodable
extension WorkTimeValidationErrorTests {
    func testDecoding_emptyResponse() throws {
        //Arrange
        let data = try self.json(from: WorkTimeValidationErrorResponse.workTimeValidationErrorEmptyResponse)
        //Act
        let sut = try self.decoder.decode(WorkTimeValidationError.self, from: data)
        //Assert
        XCTAssert(sut.body.isEmpty)
        XCTAssert(sut.task.isEmpty)
        XCTAssert(sut.startsAt.isEmpty)
        XCTAssert(sut.duration.isEmpty)
        XCTAssert(sut.projectID.isEmpty)
    }
    
    func testDecoding_bodyOrTaskBlank() throws {
        //Arrange
        let data = try self.json(from: WorkTimeValidationErrorResponse.workTimeValidationErrorBodyOrTaskBlank)
        //Act
        let sut = try self.decoder.decode(WorkTimeValidationError.self, from: data)
        //Assert
        XCTAssertEqual(sut.body.count, 1)
        XCTAssert(sut.body.contains(.bodyOrTaskBlank))
        XCTAssert(sut.task.isEmpty)
        XCTAssert(sut.startsAt.isEmpty)
        XCTAssert(sut.duration.isEmpty)
        XCTAssert(sut.projectID.isEmpty)
    }
    
    func testDecoding_taskInvalidURI() throws {
        //Arrange
        let data = try self.json(from: WorkTimeValidationErrorResponse.workTimeValidationErrorTaskInvalidURI)
        //Act
        let sut = try self.decoder.decode(WorkTimeValidationError.self, from: data)
        //Assert
        XCTAssert(sut.body.isEmpty)
        XCTAssertEqual(sut.task.count, 1)
        XCTAssert(sut.task.contains(.invalidURI))
        XCTAssert(sut.startsAt.isEmpty)
        XCTAssert(sut.duration.isEmpty)
        XCTAssert(sut.projectID.isEmpty)
    }
    
    func testDecoding_taskInvalidExternal() throws {
        //Arrange
        let data = try self.json(from: WorkTimeValidationErrorResponse.workTimeValidationErrorTaskInvalidExternal)
        //Act
        let sut = try self.decoder.decode(WorkTimeValidationError.self, from: data)
        //Assert
        XCTAssert(sut.body.isEmpty)
        XCTAssertEqual(sut.task.count, 1)
        XCTAssert(sut.task.contains(.invalidExternal))
        XCTAssert(sut.startsAt.isEmpty)
        XCTAssert(sut.duration.isEmpty)
        XCTAssert(sut.projectID.isEmpty)
    }
    
    func testDecoding_startsAtOverlap() throws {
        //Arrange
        let data = try self.json(from: WorkTimeValidationErrorResponse.workTimeValidationErrorStartsAtOverlap)
        //Act
        let sut = try self.decoder.decode(WorkTimeValidationError.self, from: data)
        //Assert
        XCTAssert(sut.body.isEmpty)
        XCTAssert(sut.task.isEmpty)
        XCTAssertEqual(sut.startsAt.count, 1)
        XCTAssert(sut.startsAt.contains(.overlap))
        XCTAssert(sut.duration.isEmpty)
        XCTAssert(sut.projectID.isEmpty)
    }
    
    func testDecoding_startsAtTooOld() throws {
        //Arrange
        let data = try self.json(from: WorkTimeValidationErrorResponse.workTimeValidationErrorStartsAtTooOld)
        //Act
        let sut = try self.decoder.decode(WorkTimeValidationError.self, from: data)
        //Assert
        XCTAssert(sut.body.isEmpty)
        XCTAssert(sut.task.isEmpty)
        XCTAssertEqual(sut.startsAt.count, 1)
        XCTAssert(sut.startsAt.contains(.tooOld))
        XCTAssert(sut.duration.isEmpty)
        XCTAssert(sut.projectID.isEmpty)
    }
    
    func testDecoding_startsAtOverlapMidnight() throws {
        //Arrange
        let data = try self.json(from: WorkTimeValidationErrorResponse.workTimeValidationErrorStartsAtOverlapMidnight)
        //Act
        let sut = try self.decoder.decode(WorkTimeValidationError.self, from: data)
        //Assert
        XCTAssert(sut.body.isEmpty)
        XCTAssert(sut.task.isEmpty)
        XCTAssertEqual(sut.startsAt.count, 1)
        XCTAssert(sut.startsAt.contains(.overlapMidnight))
        XCTAssert(sut.duration.isEmpty)
        XCTAssert(sut.projectID.isEmpty)
    }
    
    func testDecoding_startsAtNoGapsToFill() throws {
        //Arrange
        let data = try self.json(from: WorkTimeValidationErrorResponse.workTimeValidationErrorStartsAtNoGapsToFill)
        //Act
        let sut = try self.decoder.decode(WorkTimeValidationError.self, from: data)
        //Assert
        XCTAssert(sut.body.isEmpty)
        XCTAssert(sut.task.isEmpty)
        XCTAssertEqual(sut.startsAt.count, 1)
        XCTAssert(sut.startsAt.contains(.noGapsToFill))
        XCTAssert(sut.duration.isEmpty)
        XCTAssert(sut.projectID.isEmpty)
    }
    
    func testDecoding_durationGreaterThan() throws {
        //Arrange
        let data = try self.json(from: WorkTimeValidationErrorResponse.workTimeValidationErrorDurationGreaterThan)
        //Act
        let sut = try self.decoder.decode(WorkTimeValidationError.self, from: data)
        //Assert
        XCTAssert(sut.body.isEmpty)
        XCTAssert(sut.task.isEmpty)
        XCTAssert(sut.startsAt.isEmpty)
        XCTAssertEqual(sut.duration.count, 1)
        XCTAssert(sut.duration.contains(.greaterThan))
        XCTAssert(sut.projectID.isEmpty)
    }
    
    func testDecoding_projectIDBlank() throws {
        //Arrange
        let data = try self.json(from: WorkTimeValidationErrorResponse.workTimeValidationErrorProjectIDBlank)
        //Act
        let sut = try self.decoder.decode(WorkTimeValidationError.self, from: data)
        //Assert
        XCTAssert(sut.body.isEmpty)
        XCTAssert(sut.task.isEmpty)
        XCTAssert(sut.startsAt.isEmpty)
        XCTAssert(sut.duration.isEmpty)
        XCTAssertEqual(sut.projectID.count, 1)
        XCTAssert(sut.projectID.contains(.blank))
    }
    
    func testDecoding_fullModel() throws {
        //Arrange
        let data = try self.json(from: WorkTimeValidationErrorResponse.workTimeValidationErrorFullModel)
        //Act
        let sut = try self.decoder.decode(WorkTimeValidationError.self, from: data)
        //Assert
        XCTAssertEqual(sut.body.count, 1)
        XCTAssert(sut.body.contains(.bodyOrTaskBlank))
        XCTAssertEqual(sut.task.count, 2)
        XCTAssert(sut.task.contains(.invalidExternal))
        XCTAssert(sut.task.contains(.invalidURI))
        XCTAssertEqual(sut.startsAt.count, 4)
        XCTAssert(sut.startsAt.contains(.noGapsToFill))
        XCTAssert(sut.startsAt.contains(.overlap))
        XCTAssert(sut.startsAt.contains(.overlapMidnight))
        XCTAssert(sut.startsAt.contains(.tooOld))
        XCTAssertEqual(sut.duration.count, 1)
        XCTAssert(sut.duration.contains(.greaterThan))
        XCTAssertEqual(sut.projectID.count, 1)
        XCTAssert(sut.projectID.contains(.blank))
    }
}

// MARK: - isEmpty
extension WorkTimeValidationErrorTests {
    func testIsEmpty_emptyResponse() throws {
        //Arrange
        let sut = try self.buildSUT(type: .workTimeValidationErrorEmptyResponse)
        //Assert
        XCTAssert(sut.isEmpty)
    }
    
    func testIsEmpty_bodyOrTaskBlank() throws {
        //Arrange
        let sut = try self.buildSUT(type: .workTimeValidationErrorBodyOrTaskBlank)
        //Assert
        XCTAssertFalse(sut.isEmpty)
    }
    
    func testIsEmpty_taskInvalidURI() throws {
        //Arrange
        let sut = try self.buildSUT(type: .workTimeValidationErrorTaskInvalidURI)
        //Assert
        XCTAssertFalse(sut.isEmpty)
    }
    
    func testIsEmpty_taskInvalidExternal() throws {
        //Arrange
        let sut = try self.buildSUT(type: .workTimeValidationErrorTaskInvalidExternal)
        //Assert
        XCTAssertFalse(sut.isEmpty)
    }
    
    func testIsEmpty_startsAtOverlap() throws {
        //Arrange
        let sut = try self.buildSUT(type: .workTimeValidationErrorStartsAtOverlap)
        //Assert
        XCTAssertFalse(sut.isEmpty)
    }
    
    func testIsEmpty_startsAtTooOld() throws {
        //Arrange
        let sut = try self.buildSUT(type: .workTimeValidationErrorStartsAtTooOld)
        //Assert
        XCTAssertFalse(sut.isEmpty)
    }
    
    func testIsEmpty_startsAtOverlapMidnight() throws {
        //Arrange
        let sut = try self.buildSUT(type: .workTimeValidationErrorStartsAtOverlapMidnight)
        //Assert
        XCTAssertFalse(sut.isEmpty)
    }
    
    func testIsEmpty_startsAtNoGapsToFill() throws {
        //Arrange
        let sut = try self.buildSUT(type: .workTimeValidationErrorStartsAtNoGapsToFill)
        //Assert
        XCTAssertFalse(sut.isEmpty)
    }
    
    func testIsEmpty_durationGreaterThan() throws {
        //Arrange
        let sut = try self.buildSUT(type: .workTimeValidationErrorDurationGreaterThan)
        //Assert
        XCTAssertFalse(sut.isEmpty)
    }
    
    func testIsEmpty_projectIDBlank() throws {
        //Arrange
        let sut = try self.buildSUT(type: .workTimeValidationErrorProjectIDBlank)
        //Assert
        XCTAssertFalse(sut.isEmpty)
    }
    
    func testIsEmpty_fullModel() throws {
        //Arrange
        let sut = try self.buildSUT(type: .workTimeValidationErrorFullModel)
        //Assert
        XCTAssertFalse(sut.isEmpty)
    }
}

// MARK: - localizedDescription
extension WorkTimeValidationErrorTests {
    func testLocalizedDescription_emptyResponse() throws {
        //Arrange
        let sut = try self.buildSUT(type: .workTimeValidationErrorEmptyResponse)
        //Assert
        XCTAssertEqual(sut.localizedDescription, "")
    }
    
    func testLocalizedDescription_bodyOrTaskBlank() throws {
        //Arrange
        let sut = try self.buildSUT(type: .workTimeValidationErrorBodyOrTaskBlank)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.worktimeform_error_body_or_task_blank())
    }
    
    func testLocalizedDescription_taskInvalidURI() throws {
        //Arrange
        let sut = try self.buildSUT(type: .workTimeValidationErrorTaskInvalidURI)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.worktimeform_error_invalid_uri())
    }
    
    func testLocalizedDescription_taskInvalidExternal() throws {
        //Arrange
        let sut = try self.buildSUT(type: .workTimeValidationErrorTaskInvalidExternal)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.worktimeform_error_invalid_external())
    }
    
    func testLocalizedDescription_startsAtOverlap() throws {
        //Arrange
        let sut = try self.buildSUT(type: .workTimeValidationErrorStartsAtOverlap)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.worktimeform_error_overlap())
    }
    
    func testLocalizedDescription_startsAtTooOld() throws {
        //Arrange
        let sut = try self.buildSUT(type: .workTimeValidationErrorStartsAtTooOld)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.worktimeform_error_too_old())
    }
    
    func testLocalizedDescription_startsAtOverlapMidnight() throws {
        //Arrange
        let sut = try self.buildSUT(type: .workTimeValidationErrorStartsAtOverlapMidnight)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.worktimeform_error_overlap_midnight())
    }
    
    func testLocalizedDescription_startsAtNoGapsToFill() throws {
        //Arrange
        let sut = try self.buildSUT(type: .workTimeValidationErrorStartsAtNoGapsToFill)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.worktimeform_error_no_gaps_to_fill())
    }
    
    func testLocalizedDescription_durationGreaterThan() throws {
        //Arrange
        let sut = try self.buildSUT(type: .workTimeValidationErrorDurationGreaterThan)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.worktimeform_error_greater_than())
    }
    
    func testLocalizedDescription_projectIDBlank() throws {
        //Arrange
        let sut = try self.buildSUT(type: .workTimeValidationErrorProjectIDBlank)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.worktimeform_error_blank())
    }
    
    func testLocalizedDescription_fullModel() throws {
        //Arrange
        let sut = try self.buildSUT(type: .workTimeValidationErrorFullModel)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.worktimeform_error_body_or_task_blank())
    }
}

// MARK: - Private
extension WorkTimeValidationErrorTests {
    private func buildSUT(type: WorkTimeValidationErrorResponse) throws -> WorkTimeValidationError {
        let data = try self.json(from: type)
        return try self.decoder.decode(WorkTimeValidationError.self, from: data)
    }
}
