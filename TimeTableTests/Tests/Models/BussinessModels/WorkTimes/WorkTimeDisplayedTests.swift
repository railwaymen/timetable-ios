//
//  WorkTimeDisplayedTests.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 03/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class WorkTimeDisplayedTests: XCTestCase {
    private let projectColor: UIColor = .cyan
}

// MARK: - init(workTime:)
extension WorkTimeDisplayedTests {
    func testInitFromWorkTime_setsUpFieldsProperly() throws {
        //Arrange
        let workTime = try self.buildWorkTimeDecoder()
        //Act
        let sut = WorkTimeDisplayed(workTime: workTime)
        //Assert
        XCTAssertEqual(sut.id, 1)
        XCTAssertEqual(sut.body, "Body ")
        XCTAssertEqual(sut.task, "some_url")
        XCTAssertEqual(sut.taskPreview, "TIM-56")
        XCTAssertEqual(sut.projectName, "project name")
        XCTAssertEqual(sut.projectColor, self.projectColor)
        XCTAssertEqual(sut.tag, .clientCommunication)
        XCTAssertEqual(sut.startsAt, try self.startsAt())
        XCTAssertEqual(sut.endsAt, try self.endsAt())
        XCTAssertEqual(sut.duration, 3601)
        XCTAssertNil(sut.updatedAt)
        XCTAssertNil(sut.updatedBy)
        XCTAssert(sut.changedFields.isEmpty)
        XCTAssertEqual(sut.event, .create)
    }
}

// MARK: - init(workTime:version:)
extension WorkTimeDisplayedTests {
    func testInitFromWorkTimeVersion_setsUpFieldsProperly() throws {
        //Arrange
        let workTime = try self.buildWorkTimeDecoder()
        let version = try XCTUnwrap(workTime.versions.first)
        //Act
        let sut = WorkTimeDisplayed(workTime: workTime, version: version)
        //Assert
        XCTAssertEqual(sut.id, 1)
        XCTAssertEqual(sut.body, version.workTime.body)
        XCTAssertEqual(sut.task, version.workTime.task)
        XCTAssertEqual(sut.taskPreview, version.workTime.taskPreview)
        XCTAssertEqual(sut.projectName, version.workTime.project.name)
        XCTAssertEqual(sut.projectColor, version.workTime.project.color)
        XCTAssertEqual(sut.tag, .development)
        XCTAssertEqual(sut.startsAt, version.workTime.startsAt)
        XCTAssertEqual(sut.endsAt, version.workTime.endsAt)
        XCTAssertEqual(sut.duration, TimeInterval(version.workTime.duration))
        XCTAssertEqual(sut.updatedAt, version.createdAt)
        XCTAssertEqual(sut.updatedBy, version.updatedBy)
        XCTAssertEqual(sut.changedFields, version.changeset)
        XCTAssertEqual(sut.event, version.event)
    }
}

// MARK: - Private
extension WorkTimeDisplayedTests {
    private func buildWorkTimeDecoder() throws -> WorkTimeDecoder {
        return try WorkTimeDecoderFactory().build(wrapper: .init(
            id: 1,
            updatedByAdmin: false,
            projectID: 154,
            startsAt: try self.startsAt(),
            endsAt: try self.endsAt(),
            duration: 3601,
            body: "Body ",
            task: "some_url",
            taskPreview: "TIM-56",
            userID: 91,
            project: try self.buildProject(),
            date: try self.date(),
            tag: .clientCommunication,
            versions: [try self.buildTaskVersion()]))
    }
    
    private func buildProject() throws -> SimpleProjectRecordDecoder {
        return try SimpleProjectRecordDecoderFactory().build(wrapper: .init(
            name: "project name",
            color: self.projectColor))
    }
    
    private func buildTaskVersion() throws -> TaskVersion {
        let data = try self.json(from: TaskVersionJSONResource.taskVersionFullModel)
        return try self.decoder.decode(TaskVersion.self, from: data)
    }
    
    private func startsAt() throws -> Date {
        return try self.buildDate(year: 2019, month: 7, day: 12)
    }
    
    private func endsAt() throws -> Date {
        return try self.buildDate(year: 2020, month: 1, day: 21)
    }
    
    private func date() throws -> Date {
        return try self.buildDate(year: 2001, month: 5, day: 30)
    }
    
    private func timeZone() throws -> TimeZone {
        try XCTUnwrap(TimeZone(secondsFromGMT: 0))
    }
}
