//
//  WorkTimesParametersTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class WorkTimesParametersTests: XCTestCase {

    private lazy var dateFormatter: DateFormatter = {
        return DateFormatter(type: .dateAndTimeExtended)
    }()
    
    func testWorkTimeRequest() throws {
        //Arrange
        let projectIdentifier = 3
        var components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 22, hour: 10, minute: 30)
        let fromDate = try XCTUnwrap(Calendar.current.date(from: components))
        components.hour = 12
        components.minute = 0
        let toDate = try XCTUnwrap(Calendar.current.date(from: components))
        let sut = WorkTimesParameters(fromDate: fromDate, toDate: toDate, projectIdentifier: projectIdentifier)
        //Act
        let data = try self.encoder.encode(sut)
        let requestDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyHashable: Any]
        //Assert
        XCTAssertEqual(try XCTUnwrap(requestDictionary?["project_id"] as? Int), projectIdentifier)
        let expectedFromDateString = try XCTUnwrap(requestDictionary?["from"] as? String)
        let expectedFromDate = try XCTUnwrap(self.dateFormatter.date(from: expectedFromDateString))
        XCTAssertEqual(expectedFromDate, fromDate)
        let expectedToDateString = try XCTUnwrap(requestDictionary?["to"] as? String)
        let expectedToDate = try XCTUnwrap(self.dateFormatter.date(from: expectedToDateString))
        XCTAssertEqual(expectedToDate, toDate)
    }
    
    func testWorkTimeRequestNullPorjectIdentifier() throws {
        //Arrange
        var components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 22, hour: 10, minute: 30)
        let fromDate = try XCTUnwrap(Calendar.current.date(from: components))
        components.hour = 12
        components.minute = 0
        let toDate = try XCTUnwrap(Calendar.current.date(from: components))
        let sut = WorkTimesParameters(fromDate: fromDate, toDate: toDate, projectIdentifier: nil)
        //Act
        let data = try self.encoder.encode(sut)
        let requestDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyHashable: Any]
        //Assert
        XCTAssertNil(requestDictionary?["project_id"] as? Int)
        let expectedFromDateString = try XCTUnwrap(requestDictionary?["from"] as? String)
        let expectedFromDate = try XCTUnwrap(self.dateFormatter.date(from: expectedFromDateString))
        XCTAssertEqual(expectedFromDate, fromDate)
        let expectedToDateString = try XCTUnwrap(requestDictionary?["to"] as? String)
        let expectedToDate = try XCTUnwrap(self.dateFormatter.date(from: expectedToDateString))
        XCTAssertEqual(expectedToDate, toDate)
    }

    func testWorkTimeRequestNullFrom() throws {
        //Arrange
        let projectIdentifier = 3
        let components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 22, hour: 12, minute: 0)
        let toDate = try XCTUnwrap(Calendar.current.date(from: components))
        let sut = WorkTimesParameters(fromDate: nil, toDate: toDate, projectIdentifier: projectIdentifier)
        //Act
        let data = try self.encoder.encode(sut)
        let requestDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyHashable: Any]
        //Assert
        XCTAssertEqual(try XCTUnwrap(requestDictionary?["project_id"] as? Int), projectIdentifier)
        XCTAssertNil(requestDictionary?["from"] as? String)
        let expectedToDateString = try XCTUnwrap(requestDictionary?["to"] as? String)
        let expectedToDate = try XCTUnwrap(self.dateFormatter.date(from: expectedToDateString))
        XCTAssertEqual(expectedToDate, toDate)
    }
    
    func testWorkTimeRequestNullTo() throws {
        //Arrange
        let projectIdentifier = 3
        let components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 22, hour: 10, minute: 30)
        let fromDate = try XCTUnwrap(Calendar.current.date(from: components))
        let sut = WorkTimesParameters(fromDate: fromDate, toDate: nil, projectIdentifier: projectIdentifier)
        //Act
        let data = try self.encoder.encode(sut)
        let requestDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyHashable: Any]
        //Assert
        XCTAssertEqual(try XCTUnwrap(requestDictionary?["project_id"] as? Int), projectIdentifier)
        let expectedFromDateString = try XCTUnwrap(requestDictionary?["from"] as? String)
        let expectedFromDate = try XCTUnwrap(self.dateFormatter.date(from: expectedFromDateString))
        XCTAssertEqual(expectedFromDate, fromDate)
        XCTAssertNil(requestDictionary?["to"] as? String)
    }
    
    func testWorkTimesAreEquatableWhileAllParametersAreNil() {
        //Arrange
        let sut1 = WorkTimesParameters(fromDate: nil, toDate: nil, projectIdentifier: nil)
        let sut2 = WorkTimesParameters(fromDate: nil, toDate: nil, projectIdentifier: nil)
        //Assert
        XCTAssertEqual(sut1, sut2)
    }
    
    func testWorkTimesAreEquatableWhileProjectIsTheSame() {
        //Arrange
        let sut1 = WorkTimesParameters(fromDate: nil, toDate: nil, projectIdentifier: 1)
        let sut2 = WorkTimesParameters(fromDate: nil, toDate: nil, projectIdentifier: 1)
        //Assert
        XCTAssertEqual(sut1, sut2)
    }
    
    func testWorkTimesAreNotEquatableWhileProjectIsNotTheSame() {
        //Arrange
        let sut1 = WorkTimesParameters(fromDate: nil, toDate: nil, projectIdentifier: 1)
        let sut2 = WorkTimesParameters(fromDate: nil, toDate: nil, projectIdentifier: 2)
        //Assert
        XCTAssertNotEqual(sut1, sut2)
    }
    
    func testWorkTimesAreEquatableWhileFromIsTheSame() throws {
        //Arrange
        let components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 22, hour: 10, minute: 30)
        let fromDate = try XCTUnwrap(Calendar.current.date(from: components))
        let sut1 = WorkTimesParameters(fromDate: fromDate, toDate: nil, projectIdentifier: nil)
        let sut2 = WorkTimesParameters(fromDate: fromDate, toDate: nil, projectIdentifier: nil)
        //Assert
        XCTAssertEqual(sut1, sut2)
    }
    
    func testWorkTimesAreNotEquatableWhileFromIsNotTheSame() throws {
        //Arrange
        let components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 22, hour: 10, minute: 30)
        let fromDate = try XCTUnwrap(Calendar.current.date(from: components))
        let sut1 = WorkTimesParameters(fromDate: fromDate, toDate: nil, projectIdentifier: nil)
        let sut2 = WorkTimesParameters(fromDate: nil, toDate: nil, projectIdentifier: nil)
        //Assert
        XCTAssertNotEqual(sut1, sut2)
    }
    
    func testWorkTimesAreEquatableWhileToDateIsTheSame() throws {
        //Arrange
        let components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 22, hour: 10, minute: 30)
        let toDate = try XCTUnwrap(Calendar.current.date(from: components))
        let sut1 = WorkTimesParameters(fromDate: nil, toDate: toDate, projectIdentifier: nil)
        let sut2 = WorkTimesParameters(fromDate: nil, toDate: toDate, projectIdentifier: nil)
        //Assert
        XCTAssertEqual(sut1, sut2)
    }
    
    func testWorkTimesAreNotEquatableWhileToDateIsNotTheSame() throws {
        //Arrange
        let components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 22, hour: 10, minute: 30)
        let toDate = try XCTUnwrap(Calendar.current.date(from: components))
        let sut1 = WorkTimesParameters(fromDate: nil, toDate: toDate, projectIdentifier: nil)
        let sut2 = WorkTimesParameters(fromDate: nil, toDate: nil, projectIdentifier: nil)
        //Assert
        XCTAssertNotEqual(sut1, sut2)
    }
    
    func testWorkTimesAreEquatableWhileAllParametersAreTheSame() throws {
        //Arrange
        var components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 22, hour: 10, minute: 30)
        let fromDate = try XCTUnwrap(Calendar.current.date(from: components))
        components.hour = 11
        let toDate = try XCTUnwrap(Calendar.current.date(from: components))
        let sut1 = WorkTimesParameters(fromDate: fromDate, toDate: toDate, projectIdentifier: 1)
        let sut2 = WorkTimesParameters(fromDate: fromDate, toDate: toDate, projectIdentifier: 1)
        //Assert
        XCTAssertEqual(sut1, sut2)
    }
    
    func testWorkTimesAreNotEquatableWithDifferentParameters() throws {
        //Arrange
        var components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 22, hour: 10, minute: 30)
        let fromDate = try XCTUnwrap(Calendar.current.date(from: components))
        components.hour = 11
        let toDate = try XCTUnwrap(Calendar.current.date(from: components))
        let sut1 = WorkTimesParameters(fromDate: fromDate, toDate: toDate, projectIdentifier: 1)
        let sut2 = WorkTimesParameters(fromDate: nil, toDate: nil, projectIdentifier: nil)
        //Assert
        XCTAssertNotEqual(sut1, sut2)
    }
}
