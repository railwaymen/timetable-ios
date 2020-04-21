//
//  TaskTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 21/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
import Restler
@testable import TimeTable

class TaskTests: XCTestCase {}

// MARK: - RestlerQueryEncodable
extension TaskTests {
    func testEncoding_fullModel() throws {
        //Arrange
        let project = try self.buildProject()
        let startsAt = try self.buildStartAtDate()
        let endsAt = try self.buildEndsAtDate()
        
        let sut = Task(
            project: project,
            body: "task body",
            url: nil,
            startsAt: startsAt,
            endsAt: endsAt,
            tag: .development)
        //Act
        let data = try self.encoder.encode(sut)
        let params = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyHashable: Any]
        //Assert
        XCTAssertEqual(params?.count, 6)
        XCTAssertEqual(params?["project_id"] as? Int64, 1)
        XCTAssertEqual(params?["body"] as? String, "task body")
        XCTAssertNil(params?["task"] as? String)
        XCTAssertEqual(params?["starts_at"] as? String, DateFormatter.dateAndTimeExtended.string(from: startsAt))
        XCTAssertEqual(params?["ends_at"] as? String, DateFormatter.dateAndTimeExtended.string(from: endsAt))
        XCTAssertEqual(params?["tag"] as? String, "dev")
    }
    
    func testEncoding_nullURL() throws {
        //Arrange
        let project = try self.buildProject()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let startsAt = try self.buildStartAtDate()
        let endsAt = try self.buildEndsAtDate()
        let sut = Task(
            project: project,
            body: "task body",
            url: url,
            startsAt: startsAt,
            endsAt: endsAt,
            tag: .development)
        //Act
        let data = try self.encoder.encode(sut)
        let params = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyHashable: Any]
        //Assert
        XCTAssertEqual(params?.count, 6)
        XCTAssertEqual(params?["project_id"] as? Int64, 1)
        XCTAssertEqual(params?["body"] as? String, "task body")
        XCTAssertEqual(params?["task"] as? String, url.absoluteString)
        XCTAssertEqual(params?["starts_at"] as? String, DateFormatter.dateAndTimeExtended.string(from: startsAt))
        XCTAssertEqual(params?["ends_at"] as? String, DateFormatter.dateAndTimeExtended.string(from: endsAt))
        XCTAssertEqual(params?["tag"] as? String, "dev")
    }
}

// MARK: - Private
extension TaskTests {
    func buildProject() throws -> SimpleProjectRecordDecoder {
        return try SimpleProjectRecordDecoderFactory().build(wrapper: SimpleProjectRecordDecoderFactory.Wrapper(id: 1))
    }
    
    func buildStartAtDate() throws -> Date {
        return try self.buildDate(
            timeZone: TimeZone(secondsFromGMT: 0)!,
            year: 2020,
            month: 4,
            day: 21,
            hour: 8)
    }
    
    func buildEndsAtDate() throws -> Date {
        return try self.buildDate(
            timeZone: TimeZone(secondsFromGMT: 0)!,
            year: 2020,
            month: 4,
            day: 21,
            hour: 11,
            minute: 30)
    }
}
