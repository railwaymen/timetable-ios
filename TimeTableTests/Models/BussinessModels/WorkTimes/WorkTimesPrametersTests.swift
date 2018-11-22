//
//  WorkTimesPrametersTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class WorkTimesPrametersTests: XCTestCase {

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
        let workTimesParameters = WorkTimesPrameters(fromDate: fromDate, toDate: toDate, projectIdentifier: projectIdentifier)
        //Act
        let data = try encoder.encode(workTimesParameters)
        let requestDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyHashable: Any]
        //Assert
        XCTAssertEqual(try (requestDictionary?["project_id"] as? Int).unwrap(), projectIdentifier)
        let expectedFromDateString = try (requestDictionary?["from"] as? String).unwrap()
        let expectedFromDate = try dateFormatter.date(from: expectedFromDateString).unwrap()
        XCTAssertEqual(expectedFromDate, fromDate)
        let expectedToDateString = try (requestDictionary?["to"] as? String).unwrap()
        let expectedToDate = try dateFormatter.date(from: expectedToDateString).unwrap()
        XCTAssertEqual(expectedToDate, toDate)
    }
    
    func testWorkTimeRequestNullPorjectIdentifier() throws {
        //Arrange
        var components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 22, hour: 10, minute: 30)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        components.hour = 12
        components.minute = 0
        let toDate = try Calendar.current.date(from: components).unwrap()
        let workTimesParameters = WorkTimesPrameters(fromDate: fromDate, toDate: toDate, projectIdentifier: nil)
        //Act
        let data = try encoder.encode(workTimesParameters)
        let requestDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyHashable: Any]
        //Assert
        XCTAssertNil(requestDictionary?["project_id"] as? Int)
        let expectedFromDateString = try (requestDictionary?["from"] as? String).unwrap()
        let expectedFromDate = try dateFormatter.date(from: expectedFromDateString).unwrap()
        XCTAssertEqual(expectedFromDate, fromDate)
        let expectedToDateString = try (requestDictionary?["to"] as? String).unwrap()
        let expectedToDate = try dateFormatter.date(from: expectedToDateString).unwrap()
        XCTAssertEqual(expectedToDate, toDate)
    }

    func testWorkTimeRequestNullFrom() throws {
        //Arrange
        let projectIdentifier = 3
        let components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 22, hour: 12, minute: 0)
        let toDate = try Calendar.current.date(from: components).unwrap()
        let workTimesParameters = WorkTimesPrameters(fromDate: nil, toDate: toDate, projectIdentifier: projectIdentifier)
        //Act
        let data = try encoder.encode(workTimesParameters)
        let requestDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyHashable: Any]
        //Assert
        XCTAssertEqual(try (requestDictionary?["project_id"] as? Int).unwrap(), projectIdentifier)
        XCTAssertNil(requestDictionary?["from"] as? String)
        let expectedToDateString = try (requestDictionary?["to"] as? String).unwrap()
        let expectedToDate = try dateFormatter.date(from: expectedToDateString).unwrap()
        XCTAssertEqual(expectedToDate, toDate)
    }
    
    func testWorkTimeRequestNullTo() throws {
        //Arrange
        let projectIdentifier = 3
        let components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 22, hour: 10, minute: 30)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        let workTimesParameters = WorkTimesPrameters(fromDate: fromDate, toDate: nil, projectIdentifier: projectIdentifier)
        //Act
        let data = try encoder.encode(workTimesParameters)
        let requestDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyHashable: Any]
        //Assert
        XCTAssertEqual(try (requestDictionary?["project_id"] as? Int).unwrap(), projectIdentifier)
        let expectedFromDateString = try (requestDictionary?["from"] as? String).unwrap()
        let expectedFromDate = try dateFormatter.date(from: expectedFromDateString).unwrap()
        XCTAssertEqual(expectedFromDate, fromDate)
        XCTAssertNil(requestDictionary?["to"] as? String)
    }
}
