//
//  WorkTimesParametersTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
import Restler
@testable import TimeTable

class WorkTimesParametersTests: XCTestCase {
    private var queryEncoder: Restler.QueryEncoder {
        Restler.QueryEncoder(jsonEncoder: self.encoder)
    }
}

// MARK: - RestlerQueryEncodable
extension WorkTimesParametersTests {
    func testEncoding_fullModel() throws {
        //Arrange
        let projectIdentifier = 3
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 3600))
        let fromDate = try self.buildDate(timeZone: timeZone, year: 2018, month: 11, day: 22, hour: 10, minute: 30)
        let toDate = try self.buildDate(timeZone: timeZone, year: 2018, month: 11, day: 22, hour: 12, minute: 0)
        let sut = WorkTimesParameters(fromDate: fromDate, toDate: toDate, projectId: projectIdentifier)
        //Act
        let queryItems = try self.queryEncoder.encode(sut)
        //Assert
        XCTAssertEqual(queryItems.count, 3)
        XCTAssert(queryItems.contains(.init(name: "from", value: "2018-11-22T10:30:00.000+0100")))
        XCTAssert(queryItems.contains(.init(name: "to", value: "2018-11-22T12:00:00.000+0100")))
        XCTAssert(queryItems.contains(.init(name: "project_id", value: "\(projectIdentifier)")))
    }
    
    func testEncoding_nilProjectId() throws {
        //Arrange
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 3600))
        let fromDate = try self.buildDate(timeZone: timeZone, year: 2018, month: 11, day: 22, hour: 10, minute: 30)
        let toDate = try self.buildDate(timeZone: timeZone, year: 2018, month: 11, day: 22, hour: 12, minute: 0)
        let sut = WorkTimesParameters(fromDate: fromDate, toDate: toDate, projectId: nil)
        //Act
        let queryItems = try self.queryEncoder.encode(sut)
        //Assert
        XCTAssertEqual(queryItems.count, 2)
        XCTAssert(queryItems.contains(.init(name: "from", value: "2018-11-22T10:30:00.000+0100")))
        XCTAssert(queryItems.contains(.init(name: "to", value: "2018-11-22T12:00:00.000+0100")))
    }

    func testEncoding_nilFrom() throws {
        //Arrange
        let projectIdentifier = 3
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 3600))
        let toDate = try self.buildDate(timeZone: timeZone, year: 2018, month: 11, day: 22, hour: 12, minute: 0)
        let sut = WorkTimesParameters(fromDate: nil, toDate: toDate, projectId: projectIdentifier)
        //Act
        let queryItems = try self.queryEncoder.encode(sut)
        //Assert
        XCTAssertEqual(queryItems.count, 2)
        XCTAssert(queryItems.contains(.init(name: "to", value: "2018-11-22T12:00:00.000+0100")))
        XCTAssert(queryItems.contains(.init(name: "project_id", value: "\(projectIdentifier)")))
    }

    func testEncoding_nilTo() throws {
        //Arrange
        let projectIdentifier = 3
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 3600))
        let fromDate = try self.buildDate(timeZone: timeZone, year: 2018, month: 11, day: 22, hour: 10, minute: 30)
        let sut = WorkTimesParameters(fromDate: fromDate, toDate: nil, projectId: projectIdentifier)
        //Act
        let queryItems = try self.queryEncoder.encode(sut)
        //Assert
        XCTAssertEqual(queryItems.count, 2)
        XCTAssert(queryItems.contains(.init(name: "from", value: "2018-11-22T10:30:00.000+0100")))
        XCTAssert(queryItems.contains(.init(name: "project_id", value: "\(projectIdentifier)")))
    }
}

// MARK: - Equatable
extension WorkTimesParametersTests {
    func testWorkTimesAreEquatableWhileAllParametersAreNil() {
        //Arrange
        let sut1 = WorkTimesParameters(fromDate: nil, toDate: nil, projectId: nil)
        let sut2 = WorkTimesParameters(fromDate: nil, toDate: nil, projectId: nil)
        //Assert
        XCTAssertEqual(sut1, sut2)
    }
    
    func testWorkTimesAreEquatableWhileProjectIsTheSame() {
        //Arrange
        let sut1 = WorkTimesParameters(fromDate: nil, toDate: nil, projectId: 1)
        let sut2 = WorkTimesParameters(fromDate: nil, toDate: nil, projectId: 1)
        //Assert
        XCTAssertEqual(sut1, sut2)
    }
    
    func testWorkTimesAreNotEquatableWhileProjectIsNotTheSame() {
        //Arrange
        let sut1 = WorkTimesParameters(fromDate: nil, toDate: nil, projectId: 1)
        let sut2 = WorkTimesParameters(fromDate: nil, toDate: nil, projectId: 2)
        //Assert
        XCTAssertNotEqual(sut1, sut2)
    }
    
    func testWorkTimesAreEquatableWhileFromIsTheSame() throws {
        //Arrange
        let fromDate = try self.getFromDate()
        let sut1 = WorkTimesParameters(fromDate: fromDate, toDate: nil, projectId: nil)
        let sut2 = WorkTimesParameters(fromDate: fromDate, toDate: nil, projectId: nil)
        //Assert
        XCTAssertEqual(sut1, sut2)
    }
    
    func testWorkTimesAreNotEquatableWhileFromIsNotTheSame() throws {
        //Arrange
        let fromDate = try self.getFromDate()
        let sut1 = WorkTimesParameters(fromDate: fromDate, toDate: nil, projectId: nil)
        let sut2 = WorkTimesParameters(fromDate: nil, toDate: nil, projectId: nil)
        //Assert
        XCTAssertNotEqual(sut1, sut2)
    }
    
    func testWorkTimesAreEquatableWhileToDateIsTheSame() throws {
        //Arrange
        let toDate = try self.getToDate()
        let sut1 = WorkTimesParameters(fromDate: nil, toDate: toDate, projectId: nil)
        let sut2 = WorkTimesParameters(fromDate: nil, toDate: toDate, projectId: nil)
        //Assert
        XCTAssertEqual(sut1, sut2)
    }
    
    func testWorkTimesAreNotEquatableWhileToDateIsNotTheSame() throws {
        //Arrange
        let toDate = try self.getToDate()
        let sut1 = WorkTimesParameters(fromDate: nil, toDate: toDate, projectId: nil)
        let sut2 = WorkTimesParameters(fromDate: nil, toDate: nil, projectId: nil)
        //Assert
        XCTAssertNotEqual(sut1, sut2)
    }
    
    func testWorkTimesAreEquatableWhileAllParametersAreTheSame() throws {
        //Arrange
        let fromDate = try self.getFromDate()
        let toDate = try self.getToDate()
        let sut1 = WorkTimesParameters(fromDate: fromDate, toDate: toDate, projectId: 1)
        let sut2 = WorkTimesParameters(fromDate: fromDate, toDate: toDate, projectId: 1)
        //Assert
        XCTAssertEqual(sut1, sut2)
    }
    
    func testWorkTimesAreNotEquatableWithDifferentParameters() throws {
        //Arrange
        let fromDate = try self.getFromDate()
        let toDate = try self.getToDate()
        let sut1 = WorkTimesParameters(fromDate: fromDate, toDate: toDate, projectId: 1)
        let sut2 = WorkTimesParameters(fromDate: nil, toDate: nil, projectId: nil)
        //Assert
        XCTAssertNotEqual(sut1, sut2)
    }
}

// MARK: - Private
extension WorkTimesParametersTests {
    private func getFromDate() throws -> Date {
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 3600))
        return try self.buildDate(timeZone: timeZone, year: 2018, month: 11, day: 22, hour: 10, minute: 30)
    }
    
    private func getToDate() throws -> Date {
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 3600))
        return try self.buildDate(timeZone: timeZone, year: 2018, month: 11, day: 22, hour: 11, minute: 30)
    }
}
