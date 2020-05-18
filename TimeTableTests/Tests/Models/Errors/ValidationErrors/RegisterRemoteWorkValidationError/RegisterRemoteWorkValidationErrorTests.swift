//
//  RegisterRemoteWorkValidationErrorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 11/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class RegisterRemoteWorkValidationErrorTests: XCTestCase {}

// MARK: - Decodable
extension RegisterRemoteWorkValidationErrorTests {
    func testDecoding_emptyStartsAtAndEndsAt() throws {
        //Arrange
        let data = try self.json(from: RegisterRemoteWorkValidationResponse.registerRemoteEmptyStartsAtAndEndsAtResponse)
        //Act
        let sut = try self.decoder.decode(RegisterRemoteWorkValidationError.self, from: data)
        //Assert
        XCTAssert(sut.startsAt.isEmpty)
        XCTAssert(sut.endsAt.isEmpty)
    }
    
    func testDecoding_startsAtFullModel() throws {
        //Arrange
        let data = try self.json(from: RegisterRemoteWorkValidationResponse.registerRemoteStartsAtFullModelResponse)
        //Act
        let sut = try self.decoder.decode(RegisterRemoteWorkValidationError.self, from: data)
        //Assert
        XCTAssertEqual(sut.startsAt.count, 4)
        XCTAssert(sut.startsAt.contains(.blank))
        XCTAssert(sut.startsAt.contains(.incorrectHours))
        XCTAssert(sut.startsAt.contains(.overlap))
        XCTAssert(sut.startsAt.contains(.tooOld))
        XCTAssert(sut.endsAt.isEmpty)
    }
    
    func testDecoding_endsAtFullModel() throws {
        //Arrange
        let data = try self.json(from: RegisterRemoteWorkValidationResponse.registerRemoteEndsAtFullModelResponse)
        //Act
        let sut = try self.decoder.decode(RegisterRemoteWorkValidationError.self, from: data)
        //Assert
        XCTAssert(sut.startsAt.isEmpty)
        XCTAssertEqual(sut.endsAt.count, 1)
        XCTAssert(sut.endsAt.contains(.blank))
    }
    
    func testDecoding_fullModelResponse() throws {
        //Arrange
        let data = try self.json(from: RegisterRemoteWorkValidationResponse.registerRemoteFullModelResponse)
        //Act
        let sut = try self.decoder.decode(RegisterRemoteWorkValidationError.self, from: data)
        //Assert
        XCTAssertEqual(sut.startsAt.count, 4)
        XCTAssert(sut.startsAt.contains(.blank))
        XCTAssert(sut.startsAt.contains(.incorrectHours))
        XCTAssert(sut.startsAt.contains(.overlap))
        XCTAssert(sut.startsAt.contains(.tooOld))
        XCTAssertEqual(sut.endsAt.count, 1)
        XCTAssert(sut.endsAt.contains(.blank))
    }
}

// MARK: - isEmpty
extension RegisterRemoteWorkValidationErrorTests {
    func testIsEmpty_true() throws {
        //Arrange
        let sut = try self.buildSUT(type: .registerRemoteEmptyStartsAtAndEndsAtResponse)
        //Assert
        XCTAssert(sut.isEmpty)
    }
    
    func testIsEmpty_startsNotEmpty() throws {
        //Arrange
        let sut = try self.buildSUT(type: .registerRemoteStartsAtFullModelResponse)
        //Assert
        XCTAssertFalse(sut.isEmpty)
    }
    
    func testIsEmpty_endsNotEmpty() throws {
        //Arrange
        let sut = try self.buildSUT(type: .registerRemoteEndsAtFullModelResponse)
        //Assert
        XCTAssertFalse(sut.isEmpty)
    }
    
    func testIsEmpty_startsAtAndEndsNotEmpty() throws {
        //Arrange
        let sut = try self.buildSUT(type: .registerRemoteFullModelResponse)
        //Assert
        XCTAssertFalse(sut.isEmpty)
    }
}

// MARK: - localizedDescription
extension RegisterRemoteWorkValidationErrorTests {
    func testLocalizedDescription_emptyStartsAtAndEndsAt() throws {
        //Arrange
        let sut = try self.buildSUT(type: .registerRemoteEmptyStartsAtAndEndsAtResponse)
        //Assert
        XCTAssertEqual(sut.localizedDescription, "")
    }
    
    func testLocalizedDescription_startsAtOverlap() throws {
        //Arrange
        let sut = try self.buildSUT(type: .registerRemoteStartsAtOverlapResponse)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.registerremotework_error_startsAt_overlap())
    }
    
    func testLocalizedDescription_startsAtTooOld() throws {
        //Arrange
        let sut = try self.buildSUT(type: .registerRemoteStartsAtTooOldResponse)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.registerremotework_error_startsAt_tooOld())
    }
    
    func testLocalizedDescription_startsAtEmpty() throws {
        //Arrange
        let sut = try self.buildSUT(type: .registerRemoteStartsAtEmptyResponse)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.registerremotework_error_startsAt_empty())
    }
    
    func testLocalizedDescription_startsAtIncorrectHours() throws {
        //Arrange
        let sut = try self.buildSUT(type: .registerRemoteStartsAtIncorrectHoursResponse)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.registerremotework_error_startsAt_incorrectHours())
    }
    
    func testLocalizedDescription_endsAtEmpty() throws {
        //Arrange
        let sut = try self.buildSUT(type: .registerRemoteEndsAtFullModelResponse)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.registerremotework_error_endsAt_empty())
    }
}

// MARK: - Private
extension RegisterRemoteWorkValidationErrorTests {
    private func buildSUT(type: RegisterRemoteWorkValidationResponse) throws -> RegisterRemoteWorkValidationError {
        let data = try self.json(from: type)
        return try self.decoder.decode(RegisterRemoteWorkValidationError.self, from: data)
    }
}
