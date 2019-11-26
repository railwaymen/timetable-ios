//
//  TaskTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 16/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class TaskTests: XCTestCase {
    private var url: URL = URL(string: "www.example.com")!
    
    private var timeZoneString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "Z"
        return formatter.string(from: Date())
    }
    
    func testTitleForProjectNoneType() {
        //Arrange
        let sut = Task(
            workTimeIdentifier: nil,
            project: nil,
            body: "body",
            url: nil,
            day: nil,
            startsAt: nil,
            endsAt: nil,
            tag: .development)
        //Act
        let title = sut.title
        //Assert
        XCTAssertEqual(title, "work_time.text_field.select_project".localized)
    }
    
    func testTitleForProjectSomeType() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: data)
        let sut = Task(
            workTimeIdentifier: nil,
            project: projectDecoder,
            body: "body",
            url: nil,
            day: nil,
            startsAt: nil,
            endsAt: nil,
            tag: .development)
        //Act
        let title = sut.title
        //Assert
        XCTAssertEqual(title, "asdsa")
    }
    
    func testAllowTaskForProjectNoneType() {
        //Arrange
        let sut = Task(
            workTimeIdentifier: nil,
            project: nil,
            body: "body",
            url: nil,
            day: nil,
            startsAt: nil,
            endsAt: nil,
            tag: .development)
        //Act
        let allowsTask = sut.allowsTask
        //Assert
        XCTAssertTrue(allowsTask)
    }
    
    func testAllowTaskForProjectSomeType() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: data)
        let sut = Task(
            workTimeIdentifier: nil,
            project: projectDecoder,
            body: "body",
            url: nil,
            day: nil,
            startsAt: nil,
            endsAt: nil,
            tag: .development)
        //Act
        let allowsTask = sut.allowsTask
        //Assert
        XCTAssertTrue(allowsTask)
    }
    
    func testTypeForProjectNoneType() {
        //Arrange
        let sut = Task(
            workTimeIdentifier: nil,
            project: nil,
            body: "body",
            url: nil,
            day: nil,
            startsAt: nil,
            endsAt: nil,
            tag: .development)
        //Act
        let type = sut.type
        //Assert
        XCTAssertNil(type)
    }
    
    func testTypeForProjectWithStandardType() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: data)
        let sut = Task(
            workTimeIdentifier: nil,
            project: projectDecoder,
            body: "body",
            url: nil,
            day: nil,
            startsAt: nil,
            endsAt: nil,
            tag: .development)
        //Act
        let type = try XCTUnwrap(sut.type)
        //Assert
        switch type {
        case .standard: break
        default: XCTFail()
        }
    }
    
    func testTypeForProjectWithFullDayType() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectWithAutofillTrueResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: data)
        let sut = Task(
            workTimeIdentifier: nil,
            project: projectDecoder,
            body: "body",
            url: nil,
            day: nil,
            startsAt: nil,
            endsAt: nil,
            tag: .development)
        //Act
        let type = try XCTUnwrap(sut.type)
        //Assert
        switch type {
        case .fullDay(let timeInterval):
            XCTAssertEqual(timeInterval, TimeInterval(60  * 60 * 8))
        default: XCTFail()
        }
    }
    
    func testTypeForProjectWithLunchType() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectWithALunchTrueResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: data)
        let sut = Task(
            workTimeIdentifier: nil,
            project: projectDecoder,
            body: "body",
            url: nil,
            day: nil,
            startsAt: nil,
            endsAt: nil,
            tag: .development)
        //Act
        let type = try XCTUnwrap(sut.type)
        //Assert
        switch type {
        case .lunch(let timeInterval):
            XCTAssertEqual(timeInterval, TimeInterval(60 * 30))
        default: XCTFail()
        }
    }
    
    func testEncodingThrowsErrorWhileProjectIsNil() throws {
        //Arrange
        let sut = Task(
            workTimeIdentifier: nil,
            project: nil,
            body: "body",
            url: nil,
            day: nil,
            startsAt: nil,
            endsAt: nil,
            tag: .development)
        var thrownError: Error?
        //Act
        do {
            _ = try self.encoder.encode(sut)
        } catch {
            thrownError = error
        }
        //Assert
        XCTAssertNotNil(thrownError)
    }
    
    func testEncodingProject() throws {
        //Arrange
        let projectData = try self.json(from: SimpleProjectJSONResource.simpleProjectWithALunchTrueResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: projectData)
        let startsAt = try XCTUnwrap(self.createDate(year: 2019, month: 11, day: 12, hour: 9, minute: 8, second: 57))
        let endsAt = try XCTUnwrap(self.createDate(year: 2019, month: 11, day: 12, hour: 10, minute: 8, second: 57))
        let sut = Task(
            workTimeIdentifier: 1,
            project: projectDecoder,
            body: "body",
            url: self.url,
            day: startsAt,
            startsAt: startsAt,
            endsAt: endsAt,
            tag: .development)
        //Act
        let data = try? self.encoder.encode(sut)
        //Assert
        let task = try XCTUnwrap(JSONSerialization.jsonObject(with: try XCTUnwrap(data), options: .allowFragments) as? [String: Any])
        XCTAssertEqual(task["project_id"] as? Int64, 11)
        XCTAssertEqual(task["body"] as? String, "body")
        XCTAssertEqual(task["task"] as? String, "www.example.com")
        XCTAssertEqual(task["starts_at"] as? String, "2019-11-12T09:08:00.000\(self.timeZoneString)")
        XCTAssertEqual(task["ends_at"] as? String, "2019-11-12T10:08:00.000\(self.timeZoneString)")
        XCTAssertEqual(task["tag"] as? String, "dev")
    }
}

// MARK: - Private
extension TaskTests {
    private func createDate(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) -> Date? {
        let components = DateComponents(
            calendar: Calendar(identifier: .gregorian),
            timeZone: TimeZone.current,
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second)
        return components.date
    }
}
