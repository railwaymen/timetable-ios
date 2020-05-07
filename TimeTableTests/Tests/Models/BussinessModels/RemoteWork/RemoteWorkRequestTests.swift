//
//  RemoteWorkRequestTests.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 07/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class RemoteWorkRequestTests: XCTestCase {
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SSSZ"
        return formatter
    }()
}

// MARK: - Encodable
extension RemoteWorkRequestTests {
    func testEncoding_fullModel() throws {
        //Arrange
        let note = "some note"
        let startsAt = try self.startsAt()
        let endsAt = try self.endsAt()
        let sut = RemoteWorkRequest(note: note, startsAt: startsAt, endsAt: endsAt)
        //Act
        let data = try self.encoder.encode(sut)
        //Assert
        let dict = try XCTUnwrap(JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any])
        XCTAssertEqual(dict["note"] as? String, note)
        XCTAssertEqual(try self.convertToDate(dict["starts_at"] as? String), startsAt, accuracy: 0.0001)
        XCTAssertEqual(try self.convertToDate(dict["ends_at"] as? String), endsAt, accuracy: 0.0001)
    }
}

// MARK: - Private
extension RemoteWorkRequestTests {
    private func startsAt() throws -> Date {
        try self.buildDate(
            year: 2020,
            month: 2,
            day: 14,
            hour: 15,
            minute: 39,
            second: 12,
            milisecond: 778)
    }
    
    private func endsAt() throws -> Date {
        try self.buildDate(
            year: 2020,
            month: 4,
            day: 1,
            hour: 7,
            minute: 28,
            second: 11,
            milisecond: 415)
    }
    
    private func convertToDate(_ optionalString: String?) throws -> Date {
        let string = try XCTUnwrap(optionalString)
        let date = self.dateFormatter.date(from: string)
        return try XCTUnwrap(date)
    }
}
