//
//  TaskTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 16/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

// swiftlint:disable file_length
class TaskTests: XCTestCase {
    private var url: URL = URL(string: "www.example.com")!
    
    private var timeZoneString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "Z"
        return formatter.string(from: Date())
    }
}

// MARK: - title
extension TaskTests {
    func testTitle_withoutProject() {
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
    
    func testTitle_withProject() throws {
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
}

// MARK: - allowsTask
extension TaskTests {
    func testAllowTask_withoutProject() {
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
    
    func testAllowTask_withProject() throws {
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
}

// MARK: - isTaggable
extension TaskTests {
    func testIsTaggable_withoutProject() throws {
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
        let isTaggable = sut.isTaggable
        //Assert
        XCTAssertFalse(isTaggable)
    }
    
    func testIsTaggable_withTaggableProject() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectWithIsTaggableTrueResponse)
        let project = try self.decoder.decode(ProjectDecoder.self, from: data)
        let sut = Task(
            workTimeIdentifier: nil,
            project: project,
            body: "body",
            url: nil,
            day: nil,
            startsAt: nil,
            endsAt: nil,
            tag: .development)
        //Act
        let isTaggable = sut.isTaggable
        //Assert
        XCTAssertTrue(isTaggable)
    }
    
    func testIsTaggable_withNotTaggableProject() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectWithIsTaggableFalseResponse)
        let project = try self.decoder.decode(ProjectDecoder.self, from: data)
        let sut = Task(
            workTimeIdentifier: nil,
            project: project,
            body: "body",
            url: nil,
            day: nil,
            startsAt: nil,
            endsAt: nil,
            tag: .development)
        //Act
        let isTaggable = sut.isTaggable
        //Assert
        XCTAssertFalse(isTaggable)
    }
}

// MARK: - type
extension TaskTests {
    func testType_withoutProject() {
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
    
    func testType_projectWithStandardType() throws {
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
    
    func testType_projectWithFullDayType() throws {
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
    
    func testType_projectWithLunchType() throws {
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
}

// MARK: - validate()
extension TaskTests {
    func testValidate_fullData() throws {
        //Arrange
        let projectData = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: projectData)
        let startsAt = try self.buildDate(year: 2019, month: 11, day: 12, hour: 9, minute: 8, second: 57)
        let endsAt = try self.buildDate(year: 2019, month: 11, day: 12, hour: 10, minute: 8, second: 57)
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
        //Assert
        XCTAssertNoThrow(try sut.validate())
    }
    
    func testValidate_lunchFullData() throws {
        //Arrange
        let projectData = try self.json(from: SimpleProjectJSONResource.simpleProjectWithALunchTrueResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: projectData)
        let startsAt = try self.buildDate(year: 2019, month: 11, day: 12, hour: 9, minute: 8, second: 57)
        let endsAt = try self.buildDate(year: 2019, month: 11, day: 12, hour: 10, minute: 8, second: 57)
        let sut = Task(
            workTimeIdentifier: 1,
            project: projectDecoder,
            body: "",
            url: nil,
            day: startsAt,
            startsAt: startsAt,
            endsAt: endsAt,
            tag: .development)
        //Act
        //Assert
        XCTAssertNoThrow(try sut.validate())
    }
    
    func testValidate_nilProject() throws {
        //Arrange
        let sut = Task(body: "")
        //Act
        //Assert
        XCTAssertThrowsError(try sut.validate()) { error in
            XCTAssertEqual(error as? TaskValidationError, TaskValidationError.projectIsNil)
        }
    }
    
    func testValidate_emptyBody() throws {
        //Arrange
        let projectData = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: projectData)
        let sut = Task(
            project: projectDecoder,
            body: "")
        //Act
        //Assert
        XCTAssertThrowsError(try sut.validate()) { error in
            XCTAssertEqual(error as? TaskValidationError, TaskValidationError.bodyIsEmpty)
        }
    }
    
    func testValidate_nilURL() throws {
        //Arrange
        let projectData = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: projectData)
        let sut = Task(
            project: projectDecoder,
            body: "body",
            url: nil)
        //Act
        //Assert
        XCTAssertThrowsError(try sut.validate()) { error in
            XCTAssertEqual(error as? TaskValidationError, TaskValidationError.urlIsNil)
        }
    }
    
    func testValidate_nilStartsAt() throws {
        //Arrange
        let projectData = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: projectData)
        let sut = Task(
            project: projectDecoder,
            body: "body",
            url: self.url,
            startsAt: nil)
        //Act
        //Assert
        XCTAssertThrowsError(try sut.validate()) { error in
            XCTAssertEqual(error as? TaskValidationError, TaskValidationError.startsAtIsNil)
        }
    }
    
    func testValidate_nilEndsAt() throws {
        //Arrange
        let projectData = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: projectData)
        let startsAt = try self.buildDate(year: 2019, month: 11, day: 12, hour: 9, minute: 8, second: 57)
        let sut = Task(
            workTimeIdentifier: 1,
            project: projectDecoder,
            body: "body",
            url: self.url,
            day: startsAt,
            startsAt: startsAt,
            endsAt: nil)
        //Act
        //Assert
        XCTAssertThrowsError(try sut.validate()) { error in
            XCTAssertEqual(error as? TaskValidationError, TaskValidationError.endsAtIsNil)
        }
    }
}

// MARK: - encode
extension TaskTests {
    func testEncoding_fullModel() throws {
        //Arrange
        let projectData = try self.json(from: SimpleProjectJSONResource.simpleProjectWithALunchTrueResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: projectData)
        let startsAt = try self.buildDate(year: 2019, month: 11, day: 12, hour: 9, minute: 8, second: 57)
        let endsAt = try self.buildDate(year: 2019, month: 11, day: 12, hour: 10, minute: 8, second: 57)
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
        let data = try self.encoder.encode(sut)
        //Assert
        let task = try XCTUnwrap(JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any])
        XCTAssertEqual(task["project_id"] as? Int64, 11)
        XCTAssertEqual(task["body"] as? String, "body")
        XCTAssertEqual(task["task"] as? String, "www.example.com")
        XCTAssertEqual(task["starts_at"] as? String, "2019-11-12T09:08:00.000\(self.timeZoneString)")
        XCTAssertEqual(task["ends_at"] as? String, "2019-11-12T10:08:00.000\(self.timeZoneString)")
        XCTAssertEqual(task["tag"] as? String, "dev")
    }
    
    func testEncoding_forTaggableProject() throws {
        //Arrange
        let projectData = try self.json(from: SimpleProjectJSONResource.simpleProjectWithIsTaggableTrueResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: projectData)
        let startsAt = try self.buildDate(year: 2019, month: 11, day: 12, hour: 9, minute: 8, second: 57)
        let endsAt = try self.buildDate(year: 2019, month: 11, day: 12, hour: 10, minute: 8, second: 57)
        let sut = Task(
            workTimeIdentifier: 1,
            project: projectDecoder,
            body: "body",
            url: self.url,
            day: startsAt,
            startsAt: startsAt,
            endsAt: endsAt,
            tag: .internalMeeting)
        //Act
        let data = try self.encoder.encode(sut)
        //Assert
        let task = try XCTUnwrap(JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any])
        XCTAssertEqual(task["project_id"] as? Int64, 11)
        XCTAssertEqual(task["body"] as? String, "body")
        XCTAssertEqual(task["task"] as? String, "www.example.com")
        XCTAssertEqual(task["starts_at"] as? String, "2019-11-12T09:08:00.000\(self.timeZoneString)")
        XCTAssertEqual(task["ends_at"] as? String, "2019-11-12T10:08:00.000\(self.timeZoneString)")
        XCTAssertEqual(task["tag"] as? String, "im")
    }
    
    func testEncoding_forNotTaggableProject() throws {
        //Arrange
        let projectData = try self.json(from: SimpleProjectJSONResource.simpleProjectWithIsTaggableFalseResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: projectData)
        let startsAt = try self.buildDate(year: 2019, month: 11, day: 12, hour: 9, minute: 8, second: 57)
        let endsAt = try self.buildDate(year: 2019, month: 11, day: 12, hour: 10, minute: 8, second: 57)
        let sut = Task(
            workTimeIdentifier: 1,
            project: projectDecoder,
            body: "body",
            url: self.url,
            day: startsAt,
            startsAt: startsAt,
            endsAt: endsAt,
            tag: .internalMeeting)
        //Act
        let data = try self.encoder.encode(sut)
        //Assert
        let task = try XCTUnwrap(JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any])
        XCTAssertEqual(task["project_id"] as? Int64, 11)
        XCTAssertEqual(task["body"] as? String, "body")
        XCTAssertEqual(task["task"] as? String, "www.example.com")
        XCTAssertEqual(task["starts_at"] as? String, "2019-11-12T09:08:00.000\(self.timeZoneString)")
        XCTAssertEqual(task["ends_at"] as? String, "2019-11-12T10:08:00.000\(self.timeZoneString)")
        XCTAssertEqual(task["tag"] as? String, "dev")
    }
    
    func testEncoding_withoutProject() throws {
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
}
// swiftlint:enable file_length
