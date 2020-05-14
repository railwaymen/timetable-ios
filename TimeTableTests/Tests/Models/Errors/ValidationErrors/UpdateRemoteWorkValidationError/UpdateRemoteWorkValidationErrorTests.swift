//
//  UpdateRemoteWorkValidationErrorTests.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 14/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class UpdateRemoteWorkValidationErrorTests: XCTestCase {}

// MARK: - Decodable
extension UpdateRemoteWorkValidationErrorTests {
    func testDecoding_emptyStartsAtAndEndsAt() throws {
        //Arrange
        let data = try self.json(from: UpdateRemoteWorkValidationResource.updateRemoteEmptyStartsAtAndEndsAtResponse)
        //Act
        let sut = try self.decoder.decode(UpdateRemoteWorkValidationError.self, from: data)
        //Assert
        XCTAssert(sut.startsAt.isEmpty)
        XCTAssert(sut.endsAt.isEmpty)
        XCTAssert(sut.isEmpty)
    }
    
    func testDecoding_startsAtFullModel() throws {
        //Arrange
        let data = try self.json(from: UpdateRemoteWorkValidationResource.updateRemoteStartsAtFullModelResponse)
        //Act
        let sut = try self.decoder.decode(UpdateRemoteWorkValidationError.self, from: data)
        //Assert
        XCTAssertEqual(sut.startsAt.count, 5)
        XCTAssert(sut.startsAt.contains(.overlap))
        XCTAssert(sut.startsAt.contains(.overlapMidnight))
        XCTAssert(sut.startsAt.contains(.tooOld))
        XCTAssert(sut.startsAt.contains(.blank))
        XCTAssert(sut.startsAt.contains(.incorrectHours))
        XCTAssert(sut.endsAt.isEmpty)
    }
    
    func testDecoding_endsAtFullModel() throws {
        //Arrange
        let data = try self.json(from: UpdateRemoteWorkValidationResource.updateRemoteEndsAtFullModelResponse)
        //Act
        let sut = try self.decoder.decode(UpdateRemoteWorkValidationError.self, from: data)
        //Assert
        XCTAssert(sut.startsAt.isEmpty)
        XCTAssertEqual(sut.endsAt.count, 1)
        XCTAssert(sut.endsAt.contains(.blank))
    }
    
    func testDecoding_fullModelResponse() throws {
        //Arrange
        let data = try self.json(from: UpdateRemoteWorkValidationResource.updateRemoteFullModelResponse)
        //Act
        let sut = try self.decoder.decode(UpdateRemoteWorkValidationError.self, from: data)
        //Assert
        XCTAssertEqual(sut.startsAt.count, 5)
        XCTAssert(sut.startsAt.contains(.overlap))
        XCTAssert(sut.startsAt.contains(.overlapMidnight))
        XCTAssert(sut.startsAt.contains(.tooOld))
        XCTAssert(sut.startsAt.contains(.blank))
        XCTAssert(sut.startsAt.contains(.incorrectHours))
        XCTAssertEqual(sut.endsAt.count, 1)
        XCTAssert(sut.endsAt.contains(.blank))
    }
}

// MARK: - isEmpty
extension UpdateRemoteWorkValidationErrorTests {
    func testIsEmpty_true() throws {
        //Arrange
        let sut = try self.buildSUT(type: .updateRemoteEmptyStartsAtAndEndsAtResponse)
        //Assert
        XCTAssert(sut.isEmpty)
    }
    
    func testIsEmpty_startsNotEmpty() throws {
        //Arrange
        let sut = try self.buildSUT(type: .updateRemoteStartsAtFullModelResponse)
        //Assert
        XCTAssertFalse(sut.isEmpty)
    }
    
    func testIsEmpty_endsNotEmpty() throws {
        //Arrange
        let sut = try self.buildSUT(type: .updateRemoteEndsAtFullModelResponse)
        //Assert
        XCTAssertFalse(sut.isEmpty)
    }
    
    func testIsEmpty_startsAtAndEndsNotEmpty() throws {
        //Arrange
        let sut = try self.buildSUT(type: .updateRemoteFullModelResponse)
        //Assert
        XCTAssertFalse(sut.isEmpty)
    }
}

// MARK: - localizedDescription
extension UpdateRemoteWorkValidationErrorTests {
    func testLocalizedDescription_emptyStartsAtAndEndsAt() throws {
        //Arrange
        let sut = try self.buildSUT(type: .updateRemoteEmptyStartsAtAndEndsAtResponse)
        //Assert
        XCTAssertEqual(sut.localizedDescription, "")
    }
    
    func testLocalizedDescription_startsAtOverlap() throws {
        //Arrange
        let sut = try self.buildSUT(type: .updateRemoteStartsAtOverlapResponse)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.registerremotework_error_startsAt_overlap())
    }
    
    func testLocalizedDescription_startsAtOverlapMidnight() throws {
        //Arrange
        let sut = try self.buildSUT(type: .updateRemoteStartsAtOverlapMidnightResponse)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.registerremotework_error_startsAt_overlapMidnight())
    }
    
    func testLocalizedDescription_startsAtTooOld() throws {
        //Arrange
        let sut = try self.buildSUT(type: .updateRemoteStartsAtTooOldResponse)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.registerremotework_error_startsAt_tooOld())
    }
    
    func testLocalizedDescription_startsAtEmpty() throws {
        //Arrange
        let sut = try self.buildSUT(type: .updateRemoteStartsAtEmptyResponse)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.registerremotework_error_startsAt_empty())
    }
    
    func testLocalizedDescription_startsAtIncorrectHours() throws {
        //Arrange
        let sut = try self.buildSUT(type: .updateRemoteStartsAtIncorrectHoursResponse)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.registerremotework_error_startsAt_incorrectHours())
    }
    
    func testLocalizedDescription_endsAtEmpty() throws {
        //Arrange
        let sut = try self.buildSUT(type: .updateRemoteEndsAtFullModelResponse)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.registerremotework_error_endsAt_empty())
    }
}

// MARK: - Private
extension UpdateRemoteWorkValidationErrorTests {
    private func buildSUT(type: UpdateRemoteWorkValidationResource) throws -> UpdateRemoteWorkValidationError {
        let data = try self.json(from: type)
        return try self.decoder.decode(UpdateRemoteWorkValidationError.self, from: data)
    }
}
