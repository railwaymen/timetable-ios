//
//  RemoteWorkFormTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 07/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class RemoteWorkFormTests: XCTestCase {}

// MARK: - func convertToEncoder()
extension RemoteWorkFormTests {
    func testConvertToEncoder_equalDates_throwsError() throws {
        //Arrange
        let date = try self.buildDate(hour: 9, minute: 0)
        let sut = RemoteWorkForm(startsAt: date, endsAt: date)
        //Act
        XCTAssertThrowsError(try sut.convertToEncoder()) { error in
            //Assert
            XCTAssertEqual(error as? UIError, UIError.remoteWorkTimeGreaterThan)
        }
    }
    
    func testConvertToEncoder_startsAtGreaterThanEndsAt_throwsError() throws {
        //Arrange
        let startsAt = try self.buildDate(hour: 9, minute: 0)
        let endsAt = try self.buildDate(hour: 8, minute: 30)
        let sut = RemoteWorkForm(startsAt: startsAt, endsAt: endsAt)
        //Act
        XCTAssertThrowsError(try sut.convertToEncoder()) { error in
            //Assert
            XCTAssertEqual(error as? UIError, UIError.remoteWorkTimeGreaterThan)
        }
    }
    
    func testConvertToEncoder_correctModel() throws {
        //Arrange
        let startsAt = try self.buildDate(hour: 8, minute: 0)
        let endsAt = try self.buildDate(hour: 9, minute: 30)
        let sut = RemoteWorkForm(startsAt: startsAt, endsAt: endsAt)
        //Act
        let encoder = try sut.convertToEncoder()
        //Assert
        XCTAssertEqual(encoder.startsAt, sut.startsAt)
        XCTAssertEqual(encoder.endsAt, sut.endsAt)
        XCTAssertEqual(encoder.note, sut.note)
    }
}

// MARK: - Private
extension RemoteWorkFormTests {
    private func buildDate(hour: Int, minute: Int) throws -> Date {
        try self.buildDate(
            year: 2020,
            month: 2,
            day: 14,
            hour: hour,
            minute: minute)
    }
}
