//
//  RemoteWorkTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 06/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class RemoteWorkTests: XCTestCase {}

// MARK: - Decodable
extension RemoteWorkTests {
    func testDecoding_fullModel() throws {
        //Arrange
        let startsAt = try self.buildDate(hour: 8)
        let endsAt = try self.buildDate(hour: 10)
        let data = try self.json(from: RemoteWorkJSONResource.remoteWorkFullModel)
        //Act
        let sut = try self.decoder.decode(RemoteWork.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 1)
        XCTAssertEqual(sut.creatorID, 2)
        XCTAssertEqual(sut.startsAt, startsAt)
        XCTAssertEqual(sut.endsAt, endsAt)
        XCTAssertEqual(sut.duration, 604800)
        XCTAssertEqual(sut.note, "string")
        XCTAssertFalse(sut.updatedByAdmin)
        XCTAssertEqual(sut.userID, 3)
    }
    
    func testDecoding_nullNote() throws {
        //Arrange
        let startsAt = try self.buildDate(hour: 8)
        let endsAt = try self.buildDate(hour: 10)
        let data = try self.json(from: RemoteWorkJSONResource.remoteWorkNull)
        //Act
        let sut = try self.decoder.decode(RemoteWork.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 1)
        XCTAssertEqual(sut.creatorID, 2)
        XCTAssertEqual(sut.startsAt, startsAt)
        XCTAssertEqual(sut.endsAt, endsAt)
        XCTAssertEqual(sut.duration, 604800)
        XCTAssertNil(sut.note)
        XCTAssertFalse(sut.updatedByAdmin)
        XCTAssertEqual(sut.userID, 3)
    }
}

// MARK: - Private
extension RemoteWorkTests {
    private func buildDate(hour: Int) throws -> Date {
        return try self.buildDate(
            timeZone: TimeZone(secondsFromGMT: 0)!,
            year: 2020,
            month: 3,
            day: 4,
            hour: hour)
    }
}
