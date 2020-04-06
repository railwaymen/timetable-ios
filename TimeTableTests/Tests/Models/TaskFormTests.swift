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
    private let simpleProjectFactory = SimpleProjectRecordDecoderFactory()
    
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
        let projectDecoder = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: data)
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
        let projectDecoder = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: data)
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
        let project = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: data)
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
        let project = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: data)
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
        let projectDecoder = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: data)
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
        XCTAssertEqual(type, .standard)
    }
    
    func testType_projectWithFullDayType() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectWithAutofillTrueResponse)
        let projectDecoder = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: data)
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
        XCTAssertEqual(type, .fullDay(8 * .hour))
    }
    
    func testType_projectWithLunchType() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectWithALunchTrueResponse)
        let projectDecoder = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: data)
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
        XCTAssertEqual(type, .lunch(30 * .minute))
    }
}

// MARK: - generateEncodableRepresentation()
extension TaskFormTests {
    func testGenerateEncodableRepresentation_fullData() throws {
        //Arrange
        let projectData = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        let projectDecoder = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: projectData)
        let body = "body"
        let tag = ProjectTag.development
        let day = try self.buildDate(year: 2018, month: 2, day: 2, hour: 1, minute: 2, second: 33)
        let startsAt = try self.buildDate(year: 2019, month: 11, day: 12, hour: 9, minute: 8, second: 57)
        let endsAt = try self.buildDate(year: 2019, month: 11, day: 12, hour: 10, minute: 8, second: 57)
        let sut = TaskForm(
            workTimeIdentifier: 1,
            project: projectDecoder,
            body: body,
            url: self.exampleURL,
            day: day,
            startsAt: startsAt,
            endsAt: endsAt,
            tag: tag)
        //Act
        let task = try sut.generateEncodableRepresentation()
        //Assert
        XCTAssertEqual(task.project, projectDecoder)
        XCTAssertEqual(task.body, body)
        XCTAssertEqual(task.url, self.exampleURL)
        XCTAssertEqual(task.startsAt, try self.buildDate(year: 2018, month: 2, day: 2, hour: 9, minute: 8, second: 0))
        XCTAssertEqual(task.endsAt, try self.buildDate(year: 2018, month: 2, day: 2, hour: 10, minute: 8, second: 0))
        XCTAssertEqual(task.tag, tag)
    }
    
    func testGenerateEncodableRepresentation_lunchFullData() throws {
        //Arrange
        let projectData = try self.json(from: SimpleProjectJSONResource.simpleProjectWithALunchTrueResponse)
        let projectDecoder = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: projectData)
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
    
    func testGenerateEncodableRepresentation_allowsTask_emptyBodyAndNilURL() throws {
        //Arrange
        let projectDecoder = try self.simpleProjectFactory.build(wrapper: .init(workTimesAllowsTask: true))
        let sut = TaskForm(
            project: projectDecoder,
            body: "")
        //Act
        //Assert
        XCTAssertThrowsError(try sut.generateEncodableRepresentation()) { error in
            XCTAssertEqual(error as? TaskForm.ValidationError, TaskForm.ValidationError.bodyIsEmpty)
        }
    }
    
    func testGenerateEncodableRepresentation_allowsTask_emptyBodyAndExistingURL() throws {
        //Arrange
        let projectData = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        let projectDecoder = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: projectData)
        let tag = ProjectTag.development
        let day = try self.buildDate(year: 2018, month: 2, day: 2, hour: 1, minute: 2, second: 33)
        let startsAt = try self.buildDate(year: 2019, month: 11, day: 12, hour: 9, minute: 8, second: 57)
        let endsAt = try self.buildDate(year: 2019, month: 11, day: 12, hour: 10, minute: 8, second: 57)
        let sut = TaskForm(
            workTimeIdentifier: 1,
            project: projectDecoder,
            body: "",
            url: self.exampleURL,
            day: day,
            startsAt: startsAt,
            endsAt: endsAt,
            tag: tag)
        //Act
        let task = try sut.generateEncodableRepresentation()
        //Assert
        XCTAssertEqual(task.project, projectDecoder)
        XCTAssert(task.body.isEmpty)
        XCTAssertEqual(task.url, self.exampleURL)
        XCTAssertEqual(task.startsAt, try self.buildDate(year: 2018, month: 2, day: 2, hour: 9, minute: 8, second: 0))
        XCTAssertEqual(task.endsAt, try self.buildDate(year: 2018, month: 2, day: 2, hour: 10, minute: 8, second: 0))
        XCTAssertEqual(task.tag, tag)
    }
    
    func testGenerateEncodableRepresentation_allowsTask_existingBodyAndNilURL() throws {
        //Arrange
        let projectData = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        let projectDecoder = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: projectData)
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
    
    func testGenerateEncodableRepresentation_doesNotAllowTask_emptyBody() throws {
        //Arrange
        let projectDecoder = try self.simpleProjectFactory.build(wrapper: .init(workTimesAllowsTask: false))
        let sut = TaskForm(
            project: projectDecoder,
            body: "")
        //Act
        //Assert
        XCTAssertThrowsError(try sut.generateEncodableRepresentation()) { error in
            XCTAssertEqual(error as? TaskForm.ValidationError, TaskForm.ValidationError.bodyIsEmpty)
        }
    }
    
    func testGenerateEncodableRepresentation_nilDay() throws {
        //Arrange
        let projectData = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        let projectDecoder = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: projectData)
        let sut = TaskForm(
            project: projectDecoder,
            body: "body",
            url: self.exampleURL,
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
        let projectDecoder = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: projectData)
        let day = try self.buildDate(year: 2019, month: 11, day: 12, hour: 9, minute: 8, second: 57)
        let sut = TaskForm(
            project: projectDecoder,
            body: "body",
            url: self.exampleURL,
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
        let projectDecoder = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: projectData)
        let startsAt = try self.buildDate(year: 2019, month: 11, day: 12, hour: 9, minute: 8, second: 57)
        let sut = TaskForm(
            workTimeIdentifier: 1,
            project: projectDecoder,
            body: "body",
            url: self.exampleURL,
            day: startsAt,
            startsAt: startsAt,
            endsAt: nil)
        //Act
        //Assert
        XCTAssertThrowsError(try sut.generateEncodableRepresentation()) { error in
            XCTAssertEqual(error as? TaskForm.ValidationError, TaskForm.ValidationError.endsAtIsNil)
        }
    }
    
    func testGenerateEncodableRepresentation_endsAtEqualsStartsAt() throws {
        //Arrange
        let projectData = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        let projectDecoder = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: projectData)
        let startsAt = try self.buildDate(year: 2019, month: 11, day: 12, hour: 9, minute: 8, second: 57)
        let sut = TaskForm(
            workTimeIdentifier: 1,
            project: projectDecoder,
            body: "body",
            url: self.exampleURL,
            day: startsAt,
            startsAt: startsAt,
            endsAt: startsAt)
        //Act
        //Assert
        XCTAssertThrowsError(try sut.generateEncodableRepresentation()) { error in
            XCTAssertEqual(error as? TaskForm.ValidationError, TaskForm.ValidationError.timeRangeIsIncorrect)
        }
    }
    
    func testGenerateEncodableRepresentation_endsAtBeforeStartsAt() throws {
        //Arrange
        let projectData = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        let projectDecoder = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: projectData)
        let startsAt = try self.buildDate(year: 2019, month: 11, day: 12, hour: 9, minute: 8, second: 57)
        let sut = TaskForm(
            workTimeIdentifier: 1,
            project: projectDecoder,
            body: "body",
            url: self.exampleURL,
            day: startsAt,
            startsAt: startsAt,
            endsAt: startsAt.addingTimeInterval(-60))
        //Act
        //Assert
        XCTAssertThrowsError(try sut.generateEncodableRepresentation()) { error in
            XCTAssertEqual(error as? TaskForm.ValidationError, TaskForm.ValidationError.timeRangeIsIncorrect)
        }
    }
}

// MARK: - validationErrors()
extension TaskFormTests {
    func testValidationErrors_fullForm_returnsEmptyArray() throws {
        //Arrange
        let project = try self.simpleProjectFactory.build()
        let day = try self.buildDate(year: 2019, month: 9, day: 12)
        let startsAt = try self.buildDate(year: 2020, month: 3, day: 1, hour: 9)
        let endsAt = try self.buildDate(year: 2020, month: 3, day: 1, hour: 10)
        let sut = TaskForm(
            workTimeIdentifier: 1,
            project: project,
            body: "Body",
            url: self.exampleURL,
            day: day,
            startsAt: startsAt,
            endsAt: endsAt,
            tag: .default)
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssert(errors.isEmpty)
    }
    
    func testValidationErrors_missingProject_returnsProperError() throws {
        //Arrange
        let day = try self.buildDate(year: 2019, month: 9, day: 12)
        let startsAt = try self.buildDate(year: 2020, month: 3, day: 1, hour: 9)
        let endsAt = try self.buildDate(year: 2020, month: 3, day: 1, hour: 10)
        let sut = TaskForm(
            workTimeIdentifier: 1,
            project: nil,
            body: "Body",
            url: self.exampleURL,
            day: day,
            startsAt: startsAt,
            endsAt: endsAt,
            tag: .default)
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssertEqual(errors, [.projectIsNil])
    }
    
    func testValidationErrors_lunchProject_missingBodyAndURL_returnsEmptyArray() throws {
        //Arrange
        let project = try self.simpleProjectFactory.build(wrapper: .init(isLunch: true))
        let day = try self.buildDate(year: 2019, month: 9, day: 12)
        let startsAt = try self.buildDate(year: 2020, month: 3, day: 1, hour: 9)
        let endsAt = try self.buildDate(year: 2020, month: 3, day: 1, hour: 10)
        let sut = TaskForm(
            workTimeIdentifier: 1,
            project: project,
            body: "",
            url: nil,
            day: day,
            startsAt: startsAt,
            endsAt: endsAt,
            tag: .default)
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssert(errors.isEmpty)
    }
    
    func testValidationErrors_projectWithoutCountingDuration_missingBodyAndURL_returnsEmptyArray() throws {
        //Arrange
        let project = try self.simpleProjectFactory.build(wrapper: .init(countDuration: false))
        let day = try self.buildDate(year: 2019, month: 9, day: 12)
        let startsAt = try self.buildDate(year: 2020, month: 3, day: 1, hour: 9)
        let endsAt = try self.buildDate(year: 2020, month: 3, day: 1, hour: 10)
        let sut = TaskForm(
            workTimeIdentifier: 1,
            project: project,
            body: "",
            url: nil,
            day: day,
            startsAt: startsAt,
            endsAt: endsAt,
            tag: .default)
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssert(errors.isEmpty)
    }
    
    func testValidationErrors_doesNotAllowTask_missingBody_returnsProperError() throws {
        //Arrange
        let project = try self.simpleProjectFactory.build(wrapper: .init(workTimesAllowsTask: false))
        let day = try self.buildDate(year: 2019, month: 9, day: 12)
        let startsAt = try self.buildDate(year: 2020, month: 3, day: 1, hour: 9)
        let endsAt = try self.buildDate(year: 2020, month: 3, day: 1, hour: 10)
        let sut = TaskForm(
            workTimeIdentifier: 1,
            project: project,
            body: "",
            url: self.exampleURL,
            day: day,
            startsAt: startsAt,
            endsAt: endsAt,
            tag: .default)
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssertEqual(errors, [.bodyIsEmpty])
    }
    
    func testValidationErrors_doesNotAllowTask_missingTask_returnsEmptyArray() throws {
        //Arrange
        let project = try self.simpleProjectFactory.build(wrapper: .init(workTimesAllowsTask: false))
        let day = try self.buildDate(year: 2019, month: 9, day: 12)
        let startsAt = try self.buildDate(year: 2020, month: 3, day: 1, hour: 9)
        let endsAt = try self.buildDate(year: 2020, month: 3, day: 1, hour: 10)
        let sut = TaskForm(
            workTimeIdentifier: 1,
            project: project,
            body: "Body",
            url: nil,
            day: day,
            startsAt: startsAt,
            endsAt: endsAt,
            tag: .default)
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssert(errors.isEmpty)
    }
    
    func testValidationErrors_allowsTask_missingBodyAndTaskURL_returnsProperError() throws {
        //Arrange
        let project = try self.simpleProjectFactory.build(wrapper: .init(workTimesAllowsTask: true))
        let day = try self.buildDate(year: 2019, month: 9, day: 12)
        let startsAt = try self.buildDate(year: 2020, month: 3, day: 1, hour: 9)
        let endsAt = try self.buildDate(year: 2020, month: 3, day: 1, hour: 10)
        let sut = TaskForm(
            workTimeIdentifier: 1,
            project: project,
            body: "",
            url: nil,
            day: day,
            startsAt: startsAt,
            endsAt: endsAt,
            tag: .default)
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssertEqual(errors, [.bodyIsEmpty, .urlIsNil])
    }
    
    func testValidationErrors_allowsTask_missingBody_returnsEmptyArray() throws {
        //Arrange
        let project = try self.simpleProjectFactory.build(wrapper: .init(workTimesAllowsTask: true))
        let day = try self.buildDate(year: 2019, month: 9, day: 12)
        let startsAt = try self.buildDate(year: 2020, month: 3, day: 1, hour: 9)
        let endsAt = try self.buildDate(year: 2020, month: 3, day: 1, hour: 10)
        let sut = TaskForm(
            workTimeIdentifier: 1,
            project: project,
            body: "",
            url: self.exampleURL,
            day: day,
            startsAt: startsAt,
            endsAt: endsAt,
            tag: .default)
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssert(errors.isEmpty)
    }
    
    func testValidationErrors_allowsTask_missingTaskURL_returnsEmptyArray() throws {
        //Arrange
        let project = try self.simpleProjectFactory.build(wrapper: .init(workTimesAllowsTask: true))
        let day = try self.buildDate(year: 2019, month: 9, day: 12)
        let startsAt = try self.buildDate(year: 2020, month: 3, day: 1, hour: 9)
        let endsAt = try self.buildDate(year: 2020, month: 3, day: 1, hour: 10)
        let sut = TaskForm(
            workTimeIdentifier: 1,
            project: project,
            body: "Body",
            url: nil,
            day: day,
            startsAt: startsAt,
            endsAt: endsAt,
            tag: .default)
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssert(errors.isEmpty)
    }
    
    func testValidationErrors_missingProjectAndBody_returnsBothErrors() throws {
        //Arrange
        let day = try self.buildDate(year: 2019, month: 9, day: 12)
        let startsAt = try self.buildDate(year: 2020, month: 3, day: 1, hour: 9)
        let endsAt = try self.buildDate(year: 2020, month: 3, day: 1, hour: 10)
        let sut = TaskForm(
            workTimeIdentifier: 1,
            project: nil,
            body: "",
            url: self.exampleURL,
            day: day,
            startsAt: startsAt,
            endsAt: endsAt,
            tag: .default)
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssertEqual(errors, [.projectIsNil, .bodyIsEmpty])
    }
    
    func testValidationErrors_missingProjectAndURL_returnsBothErrors() throws {
        //Arrange
        let day = try self.buildDate(year: 2019, month: 9, day: 12)
        let startsAt = try self.buildDate(year: 2020, month: 3, day: 1, hour: 9)
        let endsAt = try self.buildDate(year: 2020, month: 3, day: 1, hour: 10)
        let sut = TaskForm(
            workTimeIdentifier: 1,
            project: nil,
            body: "Body",
            url: nil,
            day: day,
            startsAt: startsAt,
            endsAt: endsAt,
            tag: .default)
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssertEqual(errors, [.projectIsNil, .urlIsNil])
    }
    
    func testValidationErrors_missingProjectAndTaskURLAndBody_returnsAllThreeErrors() throws {
        //Arrange
        let day = try self.buildDate(year: 2019, month: 9, day: 12)
        let startsAt = try self.buildDate(year: 2020, month: 3, day: 1, hour: 9)
        let endsAt = try self.buildDate(year: 2020, month: 3, day: 1, hour: 10)
        let sut = TaskForm(
            workTimeIdentifier: 1,
            project: nil,
            body: "",
            url: nil,
            day: day,
            startsAt: startsAt,
            endsAt: endsAt,
            tag: .default)
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssertEqual(errors, [.projectIsNil, .bodyIsEmpty, .urlIsNil])
    }
    
    func testValidationErrors_missingDay_returnsProperError() throws {
        //Arrange
        let project = try self.simpleProjectFactory.build()
        let startsAt = try self.buildDate(year: 2020, month: 3, day: 1, hour: 9)
        let endsAt = try self.buildDate(year: 2020, month: 3, day: 1, hour: 10)
        let sut = TaskForm(
            workTimeIdentifier: 1,
            project: project,
            body: "Body",
            url: self.exampleURL,
            day: nil,
            startsAt: startsAt,
            endsAt: endsAt,
            tag: .default)
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssertEqual(errors, [.dayIsNil])
    }
    
    func testValidationErrors_missingStartsAt_returnsProperError() throws {
        //Arrange
        let project = try self.simpleProjectFactory.build()
        let day = try self.buildDate(year: 2019, month: 9, day: 12)
        let endsAt = try self.buildDate(year: 2020, month: 3, day: 1, hour: 10)
        let sut = TaskForm(
            workTimeIdentifier: 1,
            project: project,
            body: "Body",
            url: self.exampleURL,
            day: day,
            startsAt: nil,
            endsAt: endsAt,
            tag: .default)
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssertEqual(errors, [.startsAtIsNil])
    }

    func testValidationErrors_missingEndsAt_returnsProperError() throws {
        //Arrange
        let project = try self.simpleProjectFactory.build()
        let day = try self.buildDate(year: 2019, month: 9, day: 12)
        let startsAt = try self.buildDate(year: 2020, month: 3, day: 1, hour: 9)
        let sut = TaskForm(
            workTimeIdentifier: 1,
            project: project,
            body: "Body",
            url: self.exampleURL,
            day: day,
            startsAt: startsAt,
            endsAt: nil,
            tag: .default)
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssertEqual(errors, [.endsAtIsNil])
    }
    
    func testValidationErrors_startsAtEqualToEndsAt_returnsProperError() throws {
        //Arrange
        let project = try self.simpleProjectFactory.build()
        let day = try self.buildDate(year: 2019, month: 9, day: 12)
        let startsAt = try self.buildDate(year: 2020, month: 3, day: 1, hour: 9)
        let sut = TaskForm(
            workTimeIdentifier: 1,
            project: project,
            body: "Body",
            url: self.exampleURL,
            day: day,
            startsAt: startsAt,
            endsAt: startsAt,
            tag: .default)
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssertEqual(errors, [.timeRangeIsIncorrect])
    }
    
    func testValidationErrors_emptyForm_returnsAllValidationErrors() throws {
        //Arrange
        let sut = TaskForm(
            workTimeIdentifier: nil,
            project: nil,
            body: "",
            url: nil,
            day: nil,
            startsAt: nil,
            endsAt: nil,
            tag: .default)
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssertEqual(errors.count, 6)
        XCTAssert(errors.contains(.projectIsNil))
        XCTAssert(errors.contains(.bodyIsEmpty))
        XCTAssert(errors.contains(.urlIsNil))
        XCTAssert(errors.contains(.dayIsNil))
        XCTAssert(errors.contains(.startsAtIsNil))
        XCTAssert(errors.contains(.endsAtIsNil))
    }
}
// swiftlint:disable:this file_length
