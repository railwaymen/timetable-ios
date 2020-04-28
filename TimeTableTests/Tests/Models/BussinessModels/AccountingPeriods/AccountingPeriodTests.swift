//
//  AccountingPeriodTests.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 27/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class AccountingPeriodTests: XCTestCase {}

// MARK: - Decoding
extension AccountingPeriodTests {
    func testDecoding_fullModel() throws {
        //Arrange
        let data = try self.json(from: AccountingPeriodsJSONResource.accountingPeriodFullResponse)
        //Act
        let sut = try self.decoder.decode(AccountingPeriod.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 114)
        XCTAssertEqual(sut.startsAt, try self.startsAt())
        XCTAssertEqual(sut.endsAt, try self.endsAt(), accuracy: 0.001)
        XCTAssertEqual(sut.countedDuration, 3600)
        XCTAssertEqual(sut.duration, 576000)
        XCTAssertFalse(sut.isClosed)
        XCTAssertEqual(sut.note, "Note")
        XCTAssert(sut.isFullTime)
    }
    
    func testDecoding_startsAtNull() throws {
        //Arrange
        let data = try self.json(from: AccountingPeriodsJSONResource.accountingPeriodStartsAtNullValue)
        //Act
        let sut = try self.decoder.decode(AccountingPeriod.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 114)
        XCTAssertNil(sut.startsAt)
        XCTAssertEqual(sut.endsAt, try self.endsAt(), accuracy: 0.001)
        XCTAssertEqual(sut.countedDuration, 3600)
        XCTAssertEqual(sut.duration, 576000)
        XCTAssertFalse(sut.isClosed)
        XCTAssertEqual(sut.note, "Note")
        XCTAssert(sut.isFullTime)
    }

    func testDecoding_missingStartsAtKey() throws {
        //Arrange
        let data = try self.json(from: AccountingPeriodsJSONResource.accountingPeriodMissingStartsAtKey)
        //Act
        let sut = try self.decoder.decode(AccountingPeriod.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 114)
        XCTAssertNil(sut.startsAt)
        XCTAssertEqual(sut.endsAt, try self.endsAt(), accuracy: 0.001)
        XCTAssertEqual(sut.countedDuration, 3600)
        XCTAssertEqual(sut.duration, 576000)
        XCTAssertFalse(sut.isClosed)
        XCTAssertEqual(sut.note, "Note")
        XCTAssert(sut.isFullTime)
    }

    func testDecoding_endsAtNull() throws {
        //Arrange
        let data = try self.json(from: AccountingPeriodsJSONResource.accountingPeriodEndsAtNullValue)
        //Act
        let sut = try self.decoder.decode(AccountingPeriod.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 114)
        XCTAssertEqual(sut.startsAt, try self.startsAt())
        XCTAssertNil(sut.endsAt)
        XCTAssertEqual(sut.countedDuration, 3600)
        XCTAssertEqual(sut.duration, 576000)
        XCTAssertFalse(sut.isClosed)
        XCTAssertEqual(sut.note, "Note")
        XCTAssert(sut.isFullTime)
    }

    func testDecoding_missingEndsAtKey() throws {
        //Arrange
        let data = try self.json(from: AccountingPeriodsJSONResource.accountingPeriodMissingEndsAtKey)
        //Act
        let sut = try self.decoder.decode(AccountingPeriod.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 114)
        XCTAssertEqual(sut.startsAt, try self.startsAt())
        XCTAssertNil(sut.endsAt)
        XCTAssertEqual(sut.countedDuration, 3600)
        XCTAssertEqual(sut.duration, 576000)
        XCTAssertFalse(sut.isClosed)
        XCTAssertEqual(sut.note, "Note")
        XCTAssert(sut.isFullTime)
    }
    
    func testDecoding_countedDurationNull() throws {
        //Arrange
        let data = try self.json(from: AccountingPeriodsJSONResource.accountingPeriodCountedDurationNullValue)
        //Act
        let sut = try self.decoder.decode(AccountingPeriod.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 114)
        XCTAssertEqual(sut.startsAt, try self.startsAt())
        XCTAssertEqual(sut.endsAt, try self.endsAt(), accuracy: 0.001)
        XCTAssertEqual(sut.countedDuration, 0)
        XCTAssertEqual(sut.duration, 576000)
        XCTAssertFalse(sut.isClosed)
        XCTAssertEqual(sut.note, "Note")
        XCTAssert(sut.isFullTime)
    }
    
    func testDecoding_missingCountedDurationKey() throws {
        //Arrange
        let data = try self.json(from: AccountingPeriodsJSONResource.accountingPeriodMissingCountedDurationKey)
        //Act
        let sut = try self.decoder.decode(AccountingPeriod.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 114)
        XCTAssertEqual(sut.startsAt, try self.startsAt())
        XCTAssertEqual(sut.endsAt, try self.endsAt(), accuracy: 0.001)
        XCTAssertEqual(sut.countedDuration, 0)
        XCTAssertEqual(sut.duration, 576000)
        XCTAssertFalse(sut.isClosed)
        XCTAssertEqual(sut.note, "Note")
        XCTAssert(sut.isFullTime)
    }
    
    func testDecoding_noteNull() throws {
        //Arrange
        let data = try self.json(from: AccountingPeriodsJSONResource.accountingPeriodNoteNullValue)
        //Act
        let sut = try self.decoder.decode(AccountingPeriod.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 114)
        XCTAssertEqual(sut.startsAt, try self.startsAt())
        XCTAssertEqual(sut.endsAt, try self.endsAt(), accuracy: 0.001)
        XCTAssertEqual(sut.countedDuration, 3600)
        XCTAssertEqual(sut.duration, 576000)
        XCTAssertFalse(sut.isClosed)
        XCTAssertNil(sut.note)
        XCTAssert(sut.isFullTime)
    }
    
    func testDecoding_missingNoteKey() throws {
        //Arrange
        let data = try self.json(from: AccountingPeriodsJSONResource.accountingPeriodMissingNoteKey)
        //Act
        let sut = try self.decoder.decode(AccountingPeriod.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 114)
        XCTAssertEqual(sut.startsAt, try self.startsAt())
        XCTAssertEqual(sut.endsAt, try self.endsAt(), accuracy: 0.001)
        XCTAssertEqual(sut.countedDuration, 3600)
        XCTAssertEqual(sut.duration, 576000)
        XCTAssertFalse(sut.isClosed)
        XCTAssertNil(sut.note)
        XCTAssert(sut.isFullTime)
    }
}

// MARK: - Private
extension AccountingPeriodTests {
    private func startsAt() throws -> Date {
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 3600))
        return try self.buildDate(timeZone: timeZone, year: 2026, month: 02, day: 1)
    }
    
    private func endsAt() throws -> Date {
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 3600))
        return try self.buildDate(
            timeZone: timeZone,
            year: 2026,
            month: 02,
            day: 28,
            hour: 23,
            minute: 59,
            second: 59,
            milisecond: 999)
    }
}
