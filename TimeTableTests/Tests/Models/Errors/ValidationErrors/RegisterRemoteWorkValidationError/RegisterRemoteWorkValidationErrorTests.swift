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
        let data = try self.json(from: RegisterRemoteWorkValidationResponse.registerRemoteEmptyStartsAtAndEndsAtResponse)
        let sut = try self.decoder.decode(RegisterRemoteWorkValidationError.self, from: data)
        //Assert
        XCTAssert(sut.isEmpty)
    }
    
    func testIsEmpty_startsNotEmpty() throws {
        //Arrange
        let data = try self.json(from: RegisterRemoteWorkValidationResponse.registerRemoteStartsAtFullModelResponse)
        let sut = try self.decoder.decode(RegisterRemoteWorkValidationError.self, from: data)
        //Assert
        XCTAssertFalse(sut.isEmpty)
    }
    
    func testIsEmpty_endsNotEmpty() throws {
        //Arrange
        let data = try self.json(from: RegisterRemoteWorkValidationResponse.registerRemoteEndsAtFullModelResponse)
        let sut = try self.decoder.decode(RegisterRemoteWorkValidationError.self, from: data)
        //Assert
        XCTAssertFalse(sut.isEmpty)
    }
    
    func testIsEmpty_startsAtAndEndsNotEmpty() throws {
        //Arrange
        let data = try self.json(from: RegisterRemoteWorkValidationResponse.registerRemoteFullModelResponse)
        let sut = try self.decoder.decode(RegisterRemoteWorkValidationError.self, from: data)
        //Assert
        XCTAssertFalse(sut.isEmpty)
    }
}

// MARK: - localizedDescription
extension RegisterRemoteWorkValidationErrorTests {
    func testLocalizedDescription_emptyStartsAtAndEndsAt() throws {
        //Arrange
        let data = try self.json(from: RegisterRemoteWorkValidationResponse.registerRemoteEmptyStartsAtAndEndsAtResponse)
        let sut = try self.decoder.decode(RegisterRemoteWorkValidationError.self, from: data)
        //Assert
        XCTAssertEqual(sut.localizedDescription, "")
    }
    
    func testLocalizedDescription_startsAtOverlap() throws {
        //Arrange
        let data = try self.json(from: RegisterRemoteWorkValidationResponse.registerRemoteStartsAtOverlapResponse)
        let sut = try self.decoder.decode(RegisterRemoteWorkValidationError.self, from: data)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.remotework_startsAt_overlap())
    }
    
    func testLocalizedDescription_startsAtTooOld() throws {
        //Arrange
        let data = try self.json(from: RegisterRemoteWorkValidationResponse.registerRemoteStartsAtTooOldResponse)
        let sut = try self.decoder.decode(RegisterRemoteWorkValidationError.self, from: data)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.remotework_startsAt_tooOld())
    }
    
    func testLocalizedDescription_startsAtEmpty() throws {
        //Arrange
        let data = try self.json(from: RegisterRemoteWorkValidationResponse.registerRemoteStartsAtEmptyResponse)
        let sut = try self.decoder.decode(RegisterRemoteWorkValidationError.self, from: data)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.remotework_startsAt_empty())
    }
    
    func testLocalizedDescription_startsAtIncorrectHours() throws {
        //Arrange
        let data = try self.json(from: RegisterRemoteWorkValidationResponse.registerRemoteStartsAtIncorrectHoursResponse)
        let sut = try self.decoder.decode(RegisterRemoteWorkValidationError.self, from: data)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.remotework_startsAt_incorrectHours())
    }
    
    func testLocalizedDescription_endsAtEmpty() throws {
        //Arrange
        let data = try self.json(from: RegisterRemoteWorkValidationResponse.registerRemoteEndsAtFullModelResponse)
        let sut = try self.decoder.decode(RegisterRemoteWorkValidationError.self, from: data)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.remotework_endsAt_empty())
    }
}
