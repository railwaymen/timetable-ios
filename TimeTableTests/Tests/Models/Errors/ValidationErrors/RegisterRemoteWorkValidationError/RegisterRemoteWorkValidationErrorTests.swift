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

// MARK: - uiErrors
extension RegisterRemoteWorkValidationErrorTests {
    func testUIErrors_emptyStartsAtAndEndsAt() throws {
        //Arrange
        let data = try self.json(from: RegisterRemoteWorkValidationResponse.registerRemoteEmptyStartsAtAndEndsAtResponse)
        let sut = try self.decoder.decode(RegisterRemoteWorkValidationError.self, from: data)
        //Assert
        XCTAssertEqual(sut.uiErrors.count, 0)
    }
    
    func testUIErrors_startsAtFullModel() throws {
        //Arrange
        let data = try self.json(from: RegisterRemoteWorkValidationResponse.registerRemoteStartsAtFullModelResponse)
        let sut = try self.decoder.decode(RegisterRemoteWorkValidationError.self, from: data)
        //Assert
        XCTAssertEqual(sut.uiErrors.count, 4)
        XCTAssert(sut.uiErrors.contains(.remoteWorkStartsAtOvelap))
        XCTAssert(sut.uiErrors.contains(.remoteWorkStartsAtTooOld))
        XCTAssert(sut.uiErrors.contains(.remoteWorkStartsAtEmpty))
        XCTAssert(sut.uiErrors.contains(.remoteWorkStartsAtIncorrectHours))
    }
    
    func testUIErrors_endsAtFullModel() throws {
        //Arrange
        let data = try self.json(from: RegisterRemoteWorkValidationResponse.registerRemoteEndsAtFullModelResponse)
        let sut = try self.decoder.decode(RegisterRemoteWorkValidationError.self, from: data)
        //Assert
        XCTAssertEqual(sut.uiErrors.count, 1)
        XCTAssert(sut.uiErrors.contains(.remoteWorkEndsAtEmpty))
    }
    
    func testUIErrors_fullModelResponse() throws {
        //Arrange
        let data = try self.json(from: RegisterRemoteWorkValidationResponse.registerRemoteFullModelResponse)
        let sut = try self.decoder.decode(RegisterRemoteWorkValidationError.self, from: data)
        //Assert
        XCTAssertEqual(sut.uiErrors.count, 5)
        XCTAssert(sut.uiErrors.contains(.remoteWorkStartsAtOvelap))
        XCTAssert(sut.uiErrors.contains(.remoteWorkStartsAtTooOld))
        XCTAssert(sut.uiErrors.contains(.remoteWorkStartsAtEmpty))
        XCTAssert(sut.uiErrors.contains(.remoteWorkStartsAtIncorrectHours))
        XCTAssert(sut.uiErrors.contains(.remoteWorkEndsAtEmpty))
    }
}
