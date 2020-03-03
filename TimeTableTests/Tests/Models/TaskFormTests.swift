//
//  TaskFormTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 16/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class TaskFormTests: XCTestCase {
    private var url: URL = URL(string: "www.example.com")!
    
    private var timeZoneString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "Z"
        return formatter.string(from: Date())
    }
}

// MARK: - title: String
extension TaskFormTests {
    func testTitle_withoutProject() {
        //Arrange
        let sut = TaskForm(
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
        let sut = TaskForm(
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

// MARK: - allowsTask: Bool
extension TaskFormTests {
    func testAllowTask_withoutProject() {
        //Arrange
        let sut = TaskForm(
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
        let sut = TaskForm(
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

// MARK: - isProjectTaggable: Bool
extension TaskFormTests {
    func testIsTaggable_withoutProject() throws {
        //Arrange
        let sut = TaskForm(
            workTimeIdentifier: nil,
            project: nil,
            body: "body",
            url: nil,
            day: nil,
            startsAt: nil,
            endsAt: nil,
            tag: .development)
        //Act
        let isTaggable = sut.isProjectTaggable
        //Assert
        XCTAssertFalse(isTaggable)
    }
    
    func testIsTaggable_withTaggableProject() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectWithIsTaggableTrueResponse)
        let project = try self.decoder.decode(ProjectDecoder.self, from: data)
        let sut = TaskForm(
            workTimeIdentifier: nil,
            project: project,
            body: "body",
            url: nil,
            day: nil,
            startsAt: nil,
            endsAt: nil,
            tag: .development)
        //Act
        let isTaggable = sut.isProjectTaggable
        //Assert
        XCTAssertTrue(isTaggable)
    }
    
    func testIsTaggable_withNotTaggableProject() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectWithIsTaggableFalseResponse)
        let project = try self.decoder.decode(ProjectDecoder.self, from: data)
        let sut = TaskForm(
            workTimeIdentifier: nil,
            project: project,
            body: "body",
            url: nil,
            day: nil,
            startsAt: nil,
            endsAt: nil,
            tag: .development)
        //Act
        let isTaggable = sut.isProjectTaggable
        //Assert
        XCTAssertFalse(isTaggable)
    }
}

// MARK: - projectType: ProjectType?
extension TaskFormTests {
    func testType_withoutProject() {
        //Arrange
        let sut = TaskForm(
            workTimeIdentifier: nil,
            project: nil,
            body: "body",
            url: nil,
            day: nil,
            startsAt: nil,
            endsAt: nil,
            tag: .development)
        //Act
        let type = sut.projectType
        //Assert
        XCTAssertNil(type)
    }
    
    func testType_projectWithStandardType() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: data)
        let sut = TaskForm(
            workTimeIdentifier: nil,
            project: projectDecoder,
            body: "body",
            url: nil,
            day: nil,
            startsAt: nil,
            endsAt: nil,
            tag: .development)
        //Act
        let type = try XCTUnwrap(sut.projectType)
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
        let sut = TaskForm(
            workTimeIdentifier: nil,
            project: projectDecoder,
            body: "body",
            url: nil,
            day: nil,
            startsAt: nil,
            endsAt: nil,
            tag: .development)
        //Act
        let type = try XCTUnwrap(sut.projectType)
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
        let sut = TaskForm(
            workTimeIdentifier: nil,
            project: projectDecoder,
            body: "body",
            url: nil,
            day: nil,
            startsAt: nil,
            endsAt: nil,
            tag: .development)
        //Act
        let type = try XCTUnwrap(sut.projectType)
        //Assert
        switch type {
        case .lunch(let timeInterval):
            XCTAssertEqual(timeInterval, TimeInterval(60 * 30))
        default: XCTFail()
        }
    }
}

// MARK: - generateEncodableRepresentation()
extension TaskFormTests {
    func testGenerateEncodableRepresentation_fullData() throws {
        //Arrange
        let projectData = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: projectData)
        let body = "body"
        let tag = ProjectTag.development
        let day = try self.buildDate(year: 2018, month: 2, day: 2, hour: 1, minute: 2, second: 33)
        let startsAt = try self.buildDate(year: 2019, month: 11, day: 12, hour: 9, minute: 8, second: 57)
        let endsAt = try self.buildDate(year: 2019, month: 11, day: 12, hour: 10, minute: 8, second: 57)
        let sut = TaskForm(
            workTimeIdentifier: 1,
            project: projectDecoder,
            body: body,
            url: self.url,
            day: day,
            startsAt: startsAt,
            endsAt: endsAt,
            tag: tag)
        //Act
        let task = try sut.generateEncodableRepresentation()
        //Assert
        XCTAssertEqual(task.project, projectDecoder)
        XCTAssertEqual(task.body, body)
        XCTAssertEqual(task.url, self.url)
        XCTAssertEqual(task.startsAt, try self.buildDate(year: 2018, month: 2, day: 2, hour: 9, minute: 8, second: 0))
        XCTAssertEqual(task.endsAt, try self.buildDate(year: 2018, month: 2, day: 2, hour: 10, minute: 8, second: 0))
        XCTAssertEqual(task.tag, tag)
    }
    
    func testGenerateEncodableRepresentation_lunchFullData() throws {
        //Arrange
        let projectData = try self.json(from: SimpleProjectJSONResource.simpleProjectWithALunchTrueResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: projectData)
        let body = ""
        let tag = ProjectTag.development
        let day = try self.buildDate(year: 2018, month: 2, day: 2, hour: 1, minute: 2, second: 33)
        let startsAt = try self.buildDate(year: 2019, month: 11, day: 12, hour: 9, minute: 8, second: 57)
        let endsAt = try self.buildDate(year: 2019, month: 11, day: 12, hour: 10, minute: 8, second: 57)
        let sut = TaskForm(
            workTimeIdentifier: 1,
            project: projectDecoder,
            body: body,
            url: nil,
            day: day,
            startsAt: startsAt,
            endsAt: endsAt,
            tag: tag)
        //Act
        let task = try sut.generateEncodableRepresentation()
        //Assert
        XCTAssertEqual(task.project, projectDecoder)
        XCTAssertEqual(task.body, body)
        XCTAssertNil(task.url)
        XCTAssertEqual(task.startsAt, try self.buildDate(year: 2018, month: 2, day: 2, hour: 9, minute: 8, second: 0))
        XCTAssertEqual(task.endsAt, try self.buildDate(year: 2018, month: 2, day: 2, hour: 10, minute: 8, second: 0))
        XCTAssertEqual(task.tag, tag)
    }
    
    func testGenerateEncodableRepresentation_nilProject() throws {
        //Arrange
        let sut = TaskForm(body: "")
        //Act
        //Assert
        XCTAssertThrowsError(try sut.generateEncodableRepresentation()) { error in
            XCTAssertEqual(error as? TaskForm.ValidationError, TaskForm.ValidationError.projectIsNil)
        }
    }
    
    func testGenerateEncodableRepresentation_emptyBody() throws {
        //Arrange
        let projectData = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: projectData)
        let sut = TaskForm(
            project: projectDecoder,
            body: "")
        //Act
        //Assert
        XCTAssertThrowsError(try sut.generateEncodableRepresentation()) { error in
            XCTAssertEqual(error as? TaskForm.ValidationError, TaskForm.ValidationError.bodyIsEmpty)
        }
    }
    
    func testGenerateEncodableRepresentation_nilURL() throws {
        //Arrange
        let projectData = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: projectData)
        let body = "body"
        let tag = ProjectTag.development
        let day = try self.buildDate(year: 2018, month: 2, day: 2, hour: 1, minute: 2, second: 33)
        let startsAt = try self.buildDate(year: 2019, month: 11, day: 12, hour: 9, minute: 8, second: 57)
        let endsAt = try self.buildDate(year: 2019, month: 11, day: 12, hour: 10, minute: 8, second: 57)
        let sut = TaskForm(
            workTimeIdentifier: 1,
            project: projectDecoder,
            body: body,
            url: nil,
            day: day,
            startsAt: startsAt,
            endsAt: endsAt,
            tag: tag)
        //Act
        let task = try sut.generateEncodableRepresentation()
        //Assert
        XCTAssertEqual(task.project, projectDecoder)
        XCTAssertEqual(task.body, body)
        XCTAssertNil(task.url)
        XCTAssertEqual(task.startsAt, try self.buildDate(year: 2018, month: 2, day: 2, hour: 9, minute: 8, second: 0))
        XCTAssertEqual(task.endsAt, try self.buildDate(year: 2018, month: 2, day: 2, hour: 10, minute: 8, second: 0))
        XCTAssertEqual(task.tag, tag)
    }
    
    func testGenerateEncodableRepresentation_nilDay() throws {
        //Arrange
        let projectData = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: projectData)
        let sut = TaskForm(
            project: projectDecoder,
            body: "body",
            url: self.url,
            startsAt: nil)
        //Act
        //Assert
        XCTAssertThrowsError(try sut.generateEncodableRepresentation()) { error in
            XCTAssertEqual(error as? TaskForm.ValidationError, TaskForm.ValidationError.dayIsNil)
        }
    }
    
    func testGenerateEncodableRepresentation_nilStartsAt() throws {
        //Arrange
        let projectData = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: projectData)
        let day = try self.buildDate(year: 2019, month: 11, day: 12, hour: 9, minute: 8, second: 57)
        let sut = TaskForm(
            project: projectDecoder,
            body: "body",
            url: self.url,
            day: day,
            startsAt: nil)
        //Act
        //Assert
        XCTAssertThrowsError(try sut.generateEncodableRepresentation()) { error in
            XCTAssertEqual(error as? TaskForm.ValidationError, TaskForm.ValidationError.startsAtIsNil)
        }
    }
    
    func testGenerateEncodableRepresentation_nilEndsAt() throws {
        //Arrange
        let projectData = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: projectData)
        let startsAt = try self.buildDate(year: 2019, month: 11, day: 12, hour: 9, minute: 8, second: 57)
        let sut = TaskForm(
            workTimeIdentifier: 1,
            project: projectDecoder,
            body: "body",
            url: self.url,
            day: startsAt,
            startsAt: startsAt,
            endsAt: nil)
        //Act
        //Assert
        XCTAssertThrowsError(try sut.generateEncodableRepresentation()) { error in
            XCTAssertEqual(error as? TaskForm.ValidationError, TaskForm.ValidationError.endsAtIsNil)
        }
    }
}
