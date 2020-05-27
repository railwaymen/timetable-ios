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

// MARK: - title
extension TaskFormTests {
    func testTitle_withoutProject() {
        //Arrange
        let sut = self.buildSUT(project: nil)
        //Assert
        XCTAssertEqual(sut.title, "worktimeform_select_project".localized)
    }
    
    func testTitle_withProject() throws {
        //Arrange
        let projectDecoder = try self.buildProject()
        let sut = self.buildSUT(project: projectDecoder)
        //Assert
        XCTAssertEqual(sut.title, "Foo")
    }
}

// MARK: - allowsTask
extension TaskFormTests {
    func testAllowTask_withoutProject() {
        //Arrange
        let sut = self.buildSUT(project: nil)
        //Act
        let allowsTask = sut.allowsTask
        //Assert
        XCTAssert(allowsTask)
    }
    
    func testAllowTask_withNonAllowsTaskProject() throws {
        //Arrange
        let projectDecoder = try self.buildProject(allowsTask: false)
        let sut = self.buildSUT(project: projectDecoder)
        //Assert
        XCTAssertFalse(sut.allowsTask)
    }
    
    func testAllowTask_withAllowTaskProject() throws {
        //Arrange
        let projectDecoder = try self.buildProject(allowsTask: true)
        let sut = self.buildSUT(project: projectDecoder)
        //Assert
        XCTAssert(sut.allowsTask)
    }
}

// MARK: - isProjectTaggable
extension TaskFormTests {
    func testIsTaggable_withoutProject() throws {
        //Arrange
        let sut = self.buildSUT(project: nil)
        //Assert
        XCTAssertFalse(sut.isProjectTaggable)
    }
    
    func testIsTaggable_withTaggableProject() throws {
        //Arrange
        let projectDecoder = try self.buildProject(isTaggable: true)
        let sut = self.buildSUT(project: projectDecoder)
        //Assert
        XCTAssert(sut.isProjectTaggable)
    }
    
    func testIsTaggable_withNotTaggableProject() throws {
        //Arrange
        let projectDecoder = try self.buildProject(isTaggable: false)
        let sut = self.buildSUT(project: projectDecoder)
        //Assert
        XCTAssertFalse(sut.isProjectTaggable)
    }
}

// MARK: - projectType
extension TaskFormTests {
    func testProjectType_withoutProject() {
        //Arrange
        let sut = self.buildSUT(project: nil)
        //Assert
        XCTAssertNil(sut.projectType)
    }
    
    func testProjectType_autofillNil_lunchFalse_returnsStandard() throws {
        //Arrange
        let projectDecoder = try self.buildProject(autofill: nil, isLunch: false)
        let sut = self.buildSUT(project: projectDecoder)
        //Assert
        XCTAssertEqual(sut.projectType, .standard)
    }
    
    func testProjectType_autofillFalse_lunchFalse_returnsStandard() throws {
        //Arrange
        let projectDecoder = try self.buildProject(autofill: false, isLunch: false)
        let sut = self.buildSUT(project: projectDecoder)
        //Act
        let type = try XCTUnwrap(sut.projectType)
        //Assert
        XCTAssertEqual(type, .standard)
    }
    
    func testProjectType_returnsFullDay() throws {
        //Arrange
        let projectDecoder = try self.buildProject(autofill: true, isLunch: false)
        let sut = self.buildSUT(project: projectDecoder)
        //Act
        let type = try XCTUnwrap(sut.projectType)
        //Assert
        XCTAssertEqual(type, .fullDay(8 * .hour))
    }
    
    func testProjectType_autofillNil_returnsLunch() throws {
        //Arrange
        let projectDecoder = try self.buildProject(autofill: nil, isLunch: true)
        let sut = self.buildSUT(project: projectDecoder)
        //Act
        let type = try XCTUnwrap(sut.projectType)
        //Assert
        XCTAssertEqual(type, .lunch(30 * .minute))
    }
    
    func testProjectType_autofillFalse_returnsLunch() throws {
        //Arrange
        let projectDecoder = try self.buildProject(autofill: false, isLunch: true)
        let sut = self.buildSUT(project: projectDecoder)
        //Act
        let type = try XCTUnwrap(sut.projectType)
        //Assert
        XCTAssertEqual(type, .lunch(30 * .minute))
    }
}

// MARK: - isLunch
extension TaskFormTests {
    func testIsLunch_nilProject() {
        //Arrange
        let sut = self.buildSUT(project: nil)
        //Assert
        XCTAssertFalse(sut.isLunch)
    }
    
    func testIsLunch_false() throws {
        //Arrange
        let projectDecoder = try self.buildProject(isLunch: false)
        let sut = self.buildSUT(project: projectDecoder)
        //Assert
        XCTAssertFalse(sut.isLunch)
    }
    
    func testIsLunch_true() throws {
        //Arrange
        let projectDecoder = try self.buildProject(isLunch: true)
        let sut = self.buildSUT(project: projectDecoder)
        //Assert
        XCTAssert(sut.isLunch)
    }
}

// MARK: - isTaskURLHidden
extension TaskFormTests {
    func testIsTaskURLHidden_nilProject_returnsFalse() {
        //Arrange
        let sut = self.buildSUT(project: nil)
        //Assert
        XCTAssertFalse(sut.isTaskURLHidden)
    }
    
    func testIsTaskURLHidden_allowTaskFalse_lunchFalse_returnsTrue() throws {
        //Arrange
        let projectDecoder = try self.buildProject(isLunch: false, allowsTask: false)
        let sut = self.buildSUT(project: projectDecoder)
        //Assert
        XCTAssert(sut.isTaskURLHidden)
    }
    
    func testIsTaskURLHidden_allowTaskTrue_lunchFalse_returnsTrue() throws {
        //Arrange
        let projectDecoder = try self.buildProject(isLunch: false, allowsTask: true)
        let sut = self.buildSUT(project: projectDecoder)
        //Assert
        XCTAssertFalse(sut.isTaskURLHidden)
    }
    
    func testIsTaskURLHidden_allowTaskFalse_lunchTrue_returnsTrue() throws {
        //Arrange
        let projectDecoder = try self.buildProject(isLunch: true, allowsTask: false)
        let sut = self.buildSUT(project: projectDecoder)
        //Assert
        XCTAssert(sut.isTaskURLHidden)
    }
}

// MARK: - url
extension TaskFormTests {
    func testURL_invalidURLString() {
        //Arrange
        let sut = self.buildSUT(urlString: "http://``")
        //Assert
        XCTAssertNil(sut.url)
    }
    
    func testURL() throws {
        //Arrange
        let expectedURL = try XCTUnwrap(self.exampleURL)
        let sut = self.buildSUT(urlString: self.exampleURL.absoluteString)
        //Assert
        XCTAssertEqual(sut.url, expectedURL)
    }
}

// MARK: - generateEncodableRepresentation()
extension TaskFormTests {
    func testGenerateEncodableRepresentation_fullData() throws {
        //Arrange
        let projectDecoder = try self.buildProject()
        let sut = self.buildSUT(
            project: projectDecoder,
            urlString: self.exampleURL.absoluteString,
            day: try self.buildDay(),
            startsAt: try self.buildStartsAtDay(),
            endsAt: try self.buildEndsAtDay(),
            tag: .development)
        //Act
        let task = try sut.generateEncodableRepresentation()
        //Assert
        XCTAssertEqual(task.project, projectDecoder)
        XCTAssertEqual(task.body, sut.body)
        XCTAssertEqual(task.url, self.exampleURL)
        XCTAssertEqual(task.startsAt, try self.buildDate(year: 2018, month: 2, day: 2, hour: 9, minute: 8, second: 0))
        XCTAssertEqual(task.endsAt, try self.buildDate(year: 2018, month: 2, day: 2, hour: 10, minute: 8, second: 0))
        XCTAssertEqual(task.tag, sut.tag)
    }
    
    func testGenerateEncodableRepresentation_lunchFullData() throws {
        //Arrange
        let projectDecoder = try self.buildProject(isLunch: true)
        let sut = self.buildSUT(
            project: projectDecoder,
            urlString: self.exampleURL.absoluteString,
            day: try self.buildDay(),
            startsAt: try self.buildStartsAtDay(),
            endsAt: try self.buildEndsAtDay(),
            tag: .development)
        //Act
        let task = try sut.generateEncodableRepresentation()
        //Assert
        XCTAssertEqual(task.project, projectDecoder)
        XCTAssertEqual(task.body, sut.body)
        XCTAssertEqual(task.url, self.exampleURL)
        XCTAssertEqual(task.startsAt, try self.buildDate(year: 2018, month: 2, day: 2, hour: 9, minute: 8, second: 0))
        XCTAssertEqual(task.endsAt, try self.buildDate(year: 2018, month: 2, day: 2, hour: 10, minute: 8, second: 0))
        XCTAssertEqual(task.tag, sut.tag)
    }
    
    func testGenerateEncodableRepresentation_nilProject() throws {
        //Arrange
        let sut = self.buildSUT(project: nil)
        //Assert
        XCTAssertThrowsError(try sut.generateEncodableRepresentation()) { error in
            XCTAssertEqual(error as? TaskForm.ValidationError, TaskForm.ValidationError.projectIsNil)
        }
    }
    
    func testGenerateEncodableRepresentation_allowsTask_emptyBodyAndURL() throws {
        //Arrange
        let projectDecoder = try self.buildProject(allowsTask: true)
        let sut = self.buildSUT(project: projectDecoder, body: "", urlString: "")
        //Assert
        XCTAssertThrowsError(try sut.generateEncodableRepresentation()) { error in
            XCTAssertEqual(error as? TaskForm.ValidationError, TaskForm.ValidationError.bodyIsEmpty)
        }
    }
    
    func testGenerateEncodableRepresentation_allowsTask_emptyBodyAndExistingURL() throws {
        //Arrange
        let projectDecoder = try self.buildProject(allowsTask: true)
        let sut = self.buildSUT(
            project: projectDecoder,
            body: "",
            urlString: self.exampleURL.absoluteString,
            day: try self.buildDay(),
            startsAt: try self.buildStartsAtDay(),
            endsAt: try self.buildEndsAtDay(),
            tag: .development)
        //Act
        let task = try sut.generateEncodableRepresentation()
        //Assert
        XCTAssertEqual(task.project, projectDecoder)
        XCTAssert(task.body.isEmpty)
        XCTAssertEqual(task.url, self.exampleURL)
        XCTAssertEqual(task.startsAt, try self.buildDate(year: 2018, month: 2, day: 2, hour: 9, minute: 8, second: 0))
        XCTAssertEqual(task.endsAt, try self.buildDate(year: 2018, month: 2, day: 2, hour: 10, minute: 8, second: 0))
        XCTAssertEqual(task.tag, sut.tag)
    }
    
    func testGenerateEncodableRepresentation_allowsTask_existingBodyAndEmtpyURL() throws {
        //Arrange
        let projectDecoder = try self.buildProject(allowsTask: true)
        let sut = self.buildSUT(
            project: projectDecoder,
            body: "body",
            urlString: "",
            day: try self.buildDay(),
            startsAt: try self.buildStartsAtDay(),
            endsAt: try self.buildEndsAtDay(),
            tag: .development)
        //Act
        let task = try sut.generateEncodableRepresentation()
        //Assert
        XCTAssertEqual(task.project, projectDecoder)
        XCTAssertEqual(task.body, sut.body)
        XCTAssertNil(task.url)
        XCTAssertEqual(task.startsAt, try self.buildDate(year: 2018, month: 2, day: 2, hour: 9, minute: 8, second: 0))
        XCTAssertEqual(task.endsAt, try self.buildDate(year: 2018, month: 2, day: 2, hour: 10, minute: 8, second: 0))
        XCTAssertEqual(task.tag, sut.tag)
    }
    
    func testGenerateEncodableRepresentation_doesNotAllowTask_emptyBody() throws {
        //Arrange
        let projectDecoder = try self.buildProject(allowsTask: false)
        let sut = self.buildSUT(project: projectDecoder, body: "", urlString: "")
        //Assert
        XCTAssertThrowsError(try sut.generateEncodableRepresentation()) { error in
            XCTAssertEqual(error as? TaskForm.ValidationError, TaskForm.ValidationError.bodyIsEmpty)
        }
    }
    
    func testGenerateEncodableRepresentation_nilDay() throws {
        //Arrange
        let projectDecoder = try self.buildProject()
        let startsAt = try self.buildStartsAtDay()
        let sut = self.buildSUT(
            project: projectDecoder,
            day: nil,
            startsAt: startsAt,
            endsAt: startsAt)
        //Assert
        XCTAssertThrowsError(try sut.generateEncodableRepresentation()) { error in
            XCTAssertEqual(error as? TaskForm.ValidationError, TaskForm.ValidationError.dayIsNil)
        }
    }
    
    func testGenerateEncodableRepresentation_nilStartsAt() throws {
        //Arrange
        let projectDecoder = try self.buildProject()
        let startsAt = try self.buildStartsAtDay()
        let sut = self.buildSUT(
            project: projectDecoder,
            day: startsAt,
            startsAt: nil,
            endsAt: startsAt)
        //Assert
        XCTAssertThrowsError(try sut.generateEncodableRepresentation()) { error in
            XCTAssertEqual(error as? TaskForm.ValidationError, TaskForm.ValidationError.startsAtIsNil)
        }
    }
    
    func testGenerateEncodableRepresentation_nilEndsAt() throws {
        //Arrange
        let projectDecoder = try self.buildProject()
        let startsAt = try self.buildStartsAtDay()
        let sut = self.buildSUT(
            project: projectDecoder,
            day: startsAt,
            startsAt: startsAt,
            endsAt: nil)
        //Assert
        XCTAssertThrowsError(try sut.generateEncodableRepresentation()) { error in
            XCTAssertEqual(error as? TaskForm.ValidationError, TaskForm.ValidationError.endsAtIsNil)
        }
    }
    
    func testGenerateEncodableRepresentation_endsAtEqualsStartsAt() throws {
        //Arrange
        let projectDecoder = try self.buildProject()
        let startsAt = try self.buildStartsAtDay()
        let sut = self.buildSUT(
            project: projectDecoder,
            day: startsAt,
            startsAt: startsAt,
            endsAt: startsAt)
        //Assert
        XCTAssertThrowsError(try sut.generateEncodableRepresentation()) { error in
            XCTAssertEqual(error as? TaskForm.ValidationError, TaskForm.ValidationError.timeRangeIsIncorrect)
        }
    }
    
    func testGenerateEncodableRepresentation_endsAtBeforeStartsAt() throws {
        //Arrange
        let projectDecoder = try self.buildProject()
        let startsAt = try self.buildStartsAtDay()
        let sut = self.buildSUT(
            project: projectDecoder,
            day: startsAt,
            startsAt: startsAt,
            endsAt: startsAt.addingTimeInterval(-60))
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
        let projectDecoder = try self.buildProject()
        let sut = self.buildSUT(
            project: projectDecoder,
            body: "body",
            urlString: self.exampleURL.absoluteString,
            day: try self.buildDay(),
            startsAt: try self.buildStartsAtDay(),
            endsAt: try self.buildEndsAtDay())
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssert(errors.isEmpty)
    }
    
    func testValidationErrors_missingProject_returnsProperError() throws {
        //Arrange
        let sut = self.buildSUT(
            project: nil,
            body: "body",
            urlString: self.exampleURL.absoluteString,
            day: try self.buildDay(),
            startsAt: try self.buildStartsAtDay(),
            endsAt: try self.buildEndsAtDay())
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssertEqual(errors, [.projectIsNil])
    }
    
    func testValidationErrors_lunchProject_missingBodyAndURL_returnsEmptyArray() throws {
        //Arrange
        let projectDecoder = try self.buildProject(isLunch: true)
        let sut = self.buildSUT(
            project: projectDecoder,
            body: "",
            urlString: "",
            day: try self.buildDay(),
            startsAt: try self.buildStartsAtDay(),
            endsAt: try self.buildEndsAtDay())
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssert(errors.isEmpty)
    }
    
    func testValidationErrors_projectWithoutCountingDuration_missingBodyAndURL_returnsEmptyArray() throws {
        //Arrange
        let projectDecoder = try self.buildProject(countDuration: false)
        let sut = self.buildSUT(
            project: projectDecoder,
            body: "",
            urlString: "",
            day: try self.buildDay(),
            startsAt: try self.buildStartsAtDay(),
            endsAt: try self.buildEndsAtDay())
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssert(errors.isEmpty)
    }
    
    func testValidationErrors_doesNotAllowTask_missingBody_returnsProperError() throws {
        //Arrange
        let projectDecoder = try self.buildProject(allowsTask: false)
        let sut = self.buildSUT(
            project: projectDecoder,
            body: "",
            urlString: self.exampleURL.absoluteString,
            day: try self.buildDay(),
            startsAt: try self.buildStartsAtDay(),
            endsAt: try self.buildEndsAtDay())
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssertEqual(errors, [.bodyIsEmpty])
    }
    
    func testValidationErrors_doesNotAllowTask_missingTaskURL_returnsEmptyArray() throws {
        //Arrange
        let projectDecoder = try self.buildProject(allowsTask: false)
        let sut = self.buildSUT(
            project: projectDecoder,
            body: "body",
            urlString: "",
            day: try self.buildDay(),
            startsAt: try self.buildStartsAtDay(),
            endsAt: try self.buildEndsAtDay())
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssert(errors.isEmpty)
    }
    
    func testValidationErrors_doesNotAllowTask_invalidTaskURL_returnsEmptyArray() throws {
        //Arrange
        let projectDecoder = try self.buildProject(allowsTask: false)
        let sut = self.buildSUT(
            project: projectDecoder,
            body: "body",
            urlString: " ",
            day: try self.buildDay(),
            startsAt: try self.buildStartsAtDay(),
            endsAt: try self.buildEndsAtDay())
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssert(errors.isEmpty)
    }
    
    func testValidationErrors_allowsTask_missingBodyAndTaskURL_returnsProperError() throws {
        //Arrange
        let projectDecoder = try self.buildProject(allowsTask: true)
        let sut = self.buildSUT(
            project: projectDecoder,
            body: "",
            urlString: "",
            day: try self.buildDay(),
            startsAt: try self.buildStartsAtDay(),
            endsAt: try self.buildEndsAtDay())
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssertEqual(errors, [.bodyIsEmpty, .urlStringIsEmpty])
    }
    
    func testValidationErrors_allowsTask_missingBodyAndInvalidTaskURL_returnsProperError() throws {
        //Arrange
        let projectDecoder = try self.buildProject(allowsTask: true)
        let sut = self.buildSUT(
            project: projectDecoder,
            body: "",
            urlString: " ",
            day: try self.buildDay(),
            startsAt: try self.buildStartsAtDay(),
            endsAt: try self.buildEndsAtDay())
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssertEqual(errors, [.urlIsInvalid])
    }
    
    func testValidationErrors_allowsTask_missingBody_returnsEmptyArray() throws {
        //Arrange
        let projectDecoder = try self.buildProject(allowsTask: true)
        let sut = self.buildSUT(
            project: projectDecoder,
            body: "",
            urlString: self.exampleURL.absoluteString,
            day: try self.buildDay(),
            startsAt: try self.buildStartsAtDay(),
            endsAt: try self.buildEndsAtDay())
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssert(errors.isEmpty)
    }
    
    func testValidationErrors_allowsTask_missingTaskURL_returnsEmptyArray() throws {
        //Arrange
        let projectDecoder = try self.buildProject(allowsTask: true)
        let sut = self.buildSUT(
            project: projectDecoder,
            body: "Body",
            urlString: "",
            day: try self.buildDay(),
            startsAt: try self.buildStartsAtDay(),
            endsAt: try self.buildEndsAtDay())
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssert(errors.isEmpty)
    }
    
    func testValidationErrors_allowsTask_invalidTaskURL_returnsProperError() throws {
        //Arrange
        let projectDecoder = try self.buildProject(allowsTask: true)
        let sut = self.buildSUT(
            project: projectDecoder,
            body: "Body",
            urlString: " ",
            day: try self.buildDay(),
            startsAt: try self.buildStartsAtDay(),
            endsAt: try self.buildEndsAtDay())
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssertEqual(errors, [.urlIsInvalid])
    }
    
    func testValidationErrors_missingProjectAndBody_returnsBothErrors() throws {
        //Arrange
        let sut = self.buildSUT(
            project: nil,
            body: "",
            urlString: self.exampleURL.absoluteString,
            day: try self.buildDay(),
            startsAt: try self.buildStartsAtDay(),
            endsAt: try self.buildEndsAtDay())
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssertEqual(errors, [.projectIsNil, .bodyIsEmpty])
    }
    
    func testValidationErrors_missingProjectAndURL_returnsBothErrors() throws {
        //Arrange
        let sut = self.buildSUT(
            project: nil,
            body: "body",
            urlString: "",
            day: try self.buildDay(),
            startsAt: try self.buildStartsAtDay(),
            endsAt: try self.buildEndsAtDay())
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssertEqual(errors, [.projectIsNil, .urlStringIsEmpty])
    }
    
    func testValidationErrors_missingProjectAndInvalidURL_returnsBothErrors() throws {
        //Arrange
        let sut = self.buildSUT(
            project: nil,
            body: "body",
            urlString: " ",
            day: try self.buildDay(),
            startsAt: try self.buildStartsAtDay(),
            endsAt: try self.buildEndsAtDay())
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssertEqual(errors, [.projectIsNil, .urlIsInvalid])
    }
    
    func testValidationErrors_missingProjectAndTaskURLAndBody_returnsAllThreeErrors() throws {
        //Arrange
        let sut = self.buildSUT(
            project: nil,
            body: "",
            urlString: "",
            day: try self.buildDay(),
            startsAt: try self.buildStartsAtDay(),
            endsAt: try self.buildEndsAtDay())
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssertEqual(errors, [.projectIsNil, .bodyIsEmpty, .urlStringIsEmpty])
    }
    
    func testValidationErrors_missingDay_returnsProperError() throws {
        //Arrange
        let projectDecoder = try self.buildProject(allowsTask: true)
        let sut = self.buildSUT(
            project: projectDecoder,
            body: "body",
            urlString: "",
            day: nil,
            startsAt: try self.buildStartsAtDay(),
            endsAt: try self.buildEndsAtDay())
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssertEqual(errors, [.dayIsNil])
    }
    
    func testValidationErrors_missingStartsAt_returnsProperError() throws {
        //Arrange
        let projectDecoder = try self.buildProject(allowsTask: true)
        let sut = self.buildSUT(
            project: projectDecoder,
            day: try self.buildDay(),
            startsAt: nil,
            endsAt: try self.buildEndsAtDay())
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssertEqual(errors, [.startsAtIsNil])
    }
    
    func testValidationErrors_missingEndsAt_returnsProperError() throws {
        //Arrange
        let projectDecoder = try self.buildProject(allowsTask: true)
        let sut = self.buildSUT(
            project: projectDecoder,
            day: try self.buildDay(),
            startsAt: try self.buildStartsAtDay(),
            endsAt: nil)
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssertEqual(errors, [.endsAtIsNil])
    }
    
    func testValidationErrors_startsAtEqualToEndsAt_returnsProperError() throws {
        //Arrange
        let projectDecoder = try self.buildProject(allowsTask: true)
        let startsAt = try self.buildStartsAtDay()
        let sut = self.buildSUT(
            project: projectDecoder,
            body: "Body",
            urlString: "",
            day: try self.buildDay(),
            startsAt: startsAt,
            endsAt: startsAt)
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssertEqual(errors, [.timeRangeIsIncorrect])
    }
    
    func testValidationErrors_emptyForm_returnsAllValidationErrors() throws {
        //Arrange
        let sut = TaskForm(
            workTimeID: nil,
            project: nil,
            body: "",
            urlString: "",
            day: nil,
            startsAt: nil,
            endsAt: nil,
            tag: .development)
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssertEqual(errors.count, 6)
        XCTAssert(errors.contains(.projectIsNil))
        XCTAssert(errors.contains(.bodyIsEmpty))
        XCTAssert(errors.contains(.urlStringIsEmpty))
        XCTAssert(errors.contains(.dayIsNil))
        XCTAssert(errors.contains(.startsAtIsNil))
        XCTAssert(errors.contains(.endsAtIsNil))
    }
}

// MARK: - Private
extension TaskFormTests {
    private func buildSUT(
        project: SimpleProjectRecordDecoder? = nil,
        body: String = "body",
        urlString: String = "",
        day: Date? = nil,
        startsAt: Date? = nil,
        endsAt: Date? = nil,
        tag: ProjectTag = .development
    ) -> TaskForm {
        TaskForm(
            workTimeID: nil,
            project: project,
            body: body,
            urlString: urlString,
            day: day,
            startsAt: startsAt,
            endsAt: endsAt,
            tag: tag)
    }
    
    private func buildProject(
        autofill: Bool? = nil,
        countDuration: Bool? = nil,
        isLunch: Bool = false,
        allowsTask: Bool = true,
        isTaggable: Bool = true
    ) throws -> SimpleProjectRecordDecoder {
        let wrapper = SimpleProjectRecordDecoderFactory.Wrapper(
            id: 2, name: "Foo",
            color: UIColor(hexString: "08e51a")!,
            autofill: autofill,
            countDuration: countDuration,
            isActive: true,
            isInternal: false,
            isLunch: isLunch,
            workTimesAllowsTask: allowsTask,
            isTaggable: isTaggable)
        return try SimpleProjectRecordDecoderFactory().build(wrapper: wrapper)
    }
    
    private func buildDay() throws -> Date {
        try self.buildDate(year: 2018, month: 2, day: 2, hour: 1, minute: 2, second: 33)
    }
    
    private func buildStartsAtDay() throws -> Date {
        try self.buildDate(year: 2019, month: 11, day: 12, hour: 9, minute: 8, second: 57)
    }
    
    private func buildEndsAtDay() throws -> Date {
        try self.buildDate(year: 2019, month: 11, day: 12, hour: 10, minute: 8, second: 57)
    }
}
// swiftlint:disable:this file_length
