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

    private var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter(type: .dateAndTimeExtended))
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        return DateFormatter(type: .dateAndTimeExtended)
    }()
    
    func testWorkTimeRequest() throws {
        //Arrange
        let projectIdentifier = 3
        var components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 22, hour: 10, minute: 30)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        components.hour = 12
        components.minute = 0
        let toDate = try Calendar.current.date(from: components).unwrap()
        let workTimesParameters = WorkTimesParameters(fromDate: fromDate, toDate: toDate, projectIdentifier: projectIdentifier)
        //Act
        let data = try self.encoder.encode(workTimesParameters)
        let requestDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyHashable: Any]
        //Assert
        XCTAssertEqual(try (requestDictionary?["project_id"] as? Int).unwrap(), projectIdentifier)
        let expectedFromDateString = try (requestDictionary?["from"] as? String).unwrap()
        let expectedFromDate = try self.dateFormatter.date(from: expectedFromDateString).unwrap()
        XCTAssertEqual(expectedFromDate, fromDate)
        let expectedToDateString = try (requestDictionary?["to"] as? String).unwrap()
        let expectedToDate = try self.dateFormatter.date(from: expectedToDateString).unwrap()
        XCTAssertEqual(expectedToDate, toDate)
    }
    
    func testWorkTimeRequestNullPorjectIdentifier() throws {
        //Arrange
        var components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 22, hour: 10, minute: 30)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        components.hour = 12
        components.minute = 0
        let toDate = try Calendar.current.date(from: components).unwrap()
        let workTimesParameters = WorkTimesParameters(fromDate: fromDate, toDate: toDate, projectIdentifier: nil)
        //Act
        let data = try self.encoder.encode(workTimesParameters)
        let requestDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyHashable: Any]
        //Assert
        XCTAssertNil(requestDictionary?["project_id"] as? Int)
        let expectedFromDateString = try (requestDictionary?["from"] as? String).unwrap()
        let expectedFromDate = try self.dateFormatter.date(from: expectedFromDateString).unwrap()
        XCTAssertEqual(expectedFromDate, fromDate)
        let expectedToDateString = try (requestDictionary?["to"] as? String).unwrap()
        let expectedToDate = try self.dateFormatter.date(from: expectedToDateString).unwrap()
        XCTAssertEqual(expectedToDate, toDate)
    }

    func testWorkTimeRequestNullFrom() throws {
        //Arrange
        let projectIdentifier = 3
        let components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 22, hour: 12, minute: 0)
        let toDate = try Calendar.current.date(from: components).unwrap()
        let workTimesParameters = WorkTimesParameters(fromDate: nil, toDate: toDate, projectIdentifier: projectIdentifier)
        //Act
        let data = try self.encoder.encode(workTimesParameters)
        let requestDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyHashable: Any]
        //Assert
        XCTAssertEqual(try (requestDictionary?["project_id"] as? Int).unwrap(), projectIdentifier)
        XCTAssertNil(requestDictionary?["from"] as? String)
        let expectedToDateString = try (requestDictionary?["to"] as? String).unwrap()
        let expectedToDate = try self.dateFormatter.date(from: expectedToDateString).unwrap()
        XCTAssertEqual(expectedToDate, toDate)
    }
    
    func testWorkTimeRequestNullTo() throws {
        //Arrange
        let projectIdentifier = 3
        let components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 22, hour: 10, minute: 30)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        let workTimesParameters = WorkTimesParameters(fromDate: fromDate, toDate: nil, projectIdentifier: projectIdentifier)
        //Act
        let data = try self.encoder.encode(workTimesParameters)
        let requestDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyHashable: Any]
        //Assert
        XCTAssertEqual(try (requestDictionary?["project_id"] as? Int).unwrap(), projectIdentifier)
        let expectedFromDateString = try (requestDictionary?["from"] as? String).unwrap()
        let expectedFromDate = try self.dateFormatter.date(from: expectedFromDateString).unwrap()
        XCTAssertEqual(expectedFromDate, fromDate)
        XCTAssertNil(requestDictionary?["to"] as? String)
    }
    
    func testWorkTimesAreEquatbleWhileAllPrametersAreNil() {
        //Arrange
        let firstWorkTime = WorkTimesParameters(fromDate: nil, toDate: nil, projectIdentifier: nil)
        let secondWorkTime = WorkTimesParameters(fromDate: nil, toDate: nil, projectIdentifier: nil)
        //Assert
        XCTAssertEqual(firstWorkTime, secondWorkTime)
    }
    
    func testWorkTimesAreEquatbleWhileProjectIsThisSame() {
        //Arrange
        let firstWorkTime = WorkTimesParameters(fromDate: nil, toDate: nil, projectIdentifier: 1)
        let secondWorkTime = WorkTimesParameters(fromDate: nil, toDate: nil, projectIdentifier: 1)
        //Assert
        XCTAssertEqual(firstWorkTime, secondWorkTime)
    }
    
    func testWorkTimesAreNotEquatbleWhileProjectIsNotThisSame() {
        //Arrange
        let firstWorkTime = WorkTimesParameters(fromDate: nil, toDate: nil, projectIdentifier: 1)
        let secondWorkTime = WorkTimesParameters(fromDate: nil, toDate: nil, projectIdentifier: 2)
        //Assert
        XCTAssertNotEqual(firstWorkTime, secondWorkTime)
    }
    
    func testWorkTimesAreEquatbleWhileFromIsThisSame() throws {
        //Arrange
        let components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 22, hour: 10, minute: 30)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        let firstWorkTime = WorkTimesParameters(fromDate: fromDate, toDate: nil, projectIdentifier: nil)
        let secondWorkTime = WorkTimesParameters(fromDate: fromDate, toDate: nil, projectIdentifier: nil)
        //Assert
        XCTAssertEqual(firstWorkTime, secondWorkTime)
    }
    
    func testWorkTimesAreNotEquatbleWhileFromIsNotThisSame() throws {
        //Arrange
        let components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 22, hour: 10, minute: 30)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        let firstWorkTime = WorkTimesParameters(fromDate: fromDate, toDate: nil, projectIdentifier: nil)
        let secondWorkTime = WorkTimesParameters(fromDate: nil, toDate: nil, projectIdentifier: nil)
        //Assert
        XCTAssertNotEqual(firstWorkTime, secondWorkTime)
    }
    
    func testWorkTimesAreEquatbleWhileToDateIsThisSame() throws {
        //Arrange
        let components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 22, hour: 10, minute: 30)
        let toDate = try Calendar.current.date(from: components).unwrap()
        let firstWorkTime = WorkTimesParameters(fromDate: nil, toDate: toDate, projectIdentifier: nil)
        let secondWorkTime = WorkTimesParameters(fromDate: nil, toDate: toDate, projectIdentifier: nil)
        //Assert
        XCTAssertEqual(firstWorkTime, secondWorkTime)
    }
    
    func testWorkTimesAreNotEquatbleWhileToDateIsNotThisSame() throws {
        //Arrange
        let components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 22, hour: 10, minute: 30)
        let toDate = try Calendar.current.date(from: components).unwrap()
        let firstWorkTime = WorkTimesParameters(fromDate: nil, toDate: toDate, projectIdentifier: nil)
        let secondWorkTime = WorkTimesParameters(fromDate: nil, toDate: nil, projectIdentifier: nil)
        //Assert
        XCTAssertNotEqual(firstWorkTime, secondWorkTime)
    }
    
    func testWorkTimesAreEquatbleWhileAllParametersAreThisSame() throws {
        //Arrange
        var components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 22, hour: 10, minute: 30)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        components.hour = 11
        let toDate = try Calendar.current.date(from: components).unwrap()
        let firstWorkTime = WorkTimesParameters(fromDate: fromDate, toDate: toDate, projectIdentifier: 1)
        let secondWorkTime = WorkTimesParameters(fromDate: fromDate, toDate: toDate, projectIdentifier: 1)
        //Assert
        XCTAssertEqual(firstWorkTime, secondWorkTime)
    }
    
    func testWorkTimesAreNotEquatbleWithDiffrenetParameters() throws {
        //Arrange
        var components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 22, hour: 10, minute: 30)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        components.hour = 11
        let toDate = try Calendar.current.date(from: components).unwrap()
        let firstWorkTime = WorkTimesParameters(fromDate: fromDate, toDate: toDate, projectIdentifier: 1)
        let secondWorkTime = WorkTimesParameters(fromDate: nil, toDate: nil, projectIdentifier: nil)
        //Assert
        XCTAssertNotEqual(firstWorkTime, secondWorkTime)
    }
}
