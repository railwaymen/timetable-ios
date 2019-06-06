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
    
    private enum SimpleProjectResponse: String, JSONFileResource {
        case simpleProjectFullResponse
        case simpleProjectWithAutofillTrueResponse
        case simpleProjectWithALunchTrueResponse
    }
    
    private var decoder: JSONDecoder = JSONDecoder()
    
    func testTitleForProjectNoneType() {
        //Arrange
        let task = Task(workTimeIdentifier: nil,
                        project: nil,
                        body: "body",
                        url: nil,
                        day: nil,
                        startAt: nil,
                        endAt: nil,
                        tag: .development)
        //Act
        let title = task.title
        //Assert
        XCTAssertEqual(title, "work_time.text_field.select_project".localized)
    }
    
    func testTitleForProjectSomeType() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectResponse.simpleProjectFullResponse)
        let projectDecoder = try decoder.decode(ProjectDecoder.self, from: data)
        let task = Task(workTimeIdentifier: nil,
                        project: projectDecoder,
                        body: "body",
                        url: nil,
                        day: nil,
                        startAt: nil,
                        endAt: nil,
                        tag: .development)
        //Act
        let title = task.title
        //Assert
        XCTAssertEqual(title, "asdsa")
    }
    
    func testAllowTaskForProjectNoneType() {
        //Arrange
        let task = Task(workTimeIdentifier: nil,
                        project: nil,
                        body: "body",
                        url: nil,
                        day: nil,
                        startAt: nil,
                        endAt: nil,
                        tag: .development)
        //Act
        let allowsTask = task.allowsTask
        //Assert
        XCTAssertTrue(allowsTask)
    }
    
    func testAllowTaskForProjectSomeType() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectResponse.simpleProjectFullResponse)
        let projectDecoder = try decoder.decode(ProjectDecoder.self, from: data)
        let task = Task(workTimeIdentifier: nil,
                        project: projectDecoder,
                        body: "body",
                        url: nil,
                        day: nil,
                        startAt: nil,
                        endAt: nil,
                        tag: .development)
        //Act
        let allowsTask = task.allowsTask
        //Assert
        XCTAssertTrue(allowsTask)
    }
    
    func testTypeForProjectNoneType() {
        //Arrange
        let task = Task(workTimeIdentifier: nil,
                        project: nil,
                        body: "body",
                        url: nil,
                        day: nil,
                        startAt: nil,
                        endAt: nil,
                        tag: .development)
        //Act
        let type = task.type
        //Assert
        XCTAssertNil(type)
    }
    
    func testTypeForProjectWithStandardType() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectResponse.simpleProjectFullResponse)
        let projectDecoder = try decoder.decode(ProjectDecoder.self, from: data)
        let task = Task(workTimeIdentifier: nil,
                        project: projectDecoder,
                        body: "body",
                        url: nil,
                        day: nil,
                        startAt: nil,
                        endAt: nil,
                        tag: .development)
        //Act
        let type = try task.type.unwrap()
        //Assert
        switch type {
        case .standard: break
        default: XCTFail()
        }
    }
    
    func testTypeForProjectWithFullDayType() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectResponse.simpleProjectWithAutofillTrueResponse)
        let projectDecoder = try decoder.decode(ProjectDecoder.self, from: data)
        let task = Task(workTimeIdentifier: nil,
                        project: projectDecoder,
                        body: "body",
                        url: nil,
                        day: nil,
                        startAt: nil,
                        endAt: nil,
                        tag: .development)
        //Act
        let type = try task.type.unwrap()
        //Assert
        switch type {
        case .fullDay(let timeInterval):
            XCTAssertEqual(timeInterval, TimeInterval(60  * 60 * 8))
        default: XCTFail()
        }
    }
    
    func testTypeForProjectWithLunchType() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectResponse.simpleProjectWithALunchTrueResponse)
        let projectDecoder = try decoder.decode(ProjectDecoder.self, from: data)
        let task = Task(workTimeIdentifier: nil,
                        project: projectDecoder,
                        body: "body",
                        url: nil,
                        day: nil,
                        startAt: nil,
                        endAt: nil,
                        tag: .development)
        //Act
        let type = try task.type.unwrap()
        //Assert
        switch type {
        case .lunch(let timeInterval):
            XCTAssertEqual(timeInterval, TimeInterval(60 * 30))
        default: XCTFail()
        }
    }
    
    func testEcondeThrowsErrorWhileProjectIsNil() {
        //Arrange
        let encoder = JSONEncoder()
        let task = Task(workTimeIdentifier: nil,
                        project: nil,
                        body: "body",
                        url: nil,
                        day: nil,
                        startAt: nil,
                        endAt: nil,
                        tag: .development)
        //Act
        let encodedTask = try? encoder.encode(task)
        //Assert
        XCTAssertNil(encodedTask)
    }
    
    func testEcondeProject() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectResponse.simpleProjectWithALunchTrueResponse)
        let projectDecoder = try decoder.decode(ProjectDecoder.self, from: data)
        let task = Task(workTimeIdentifier: nil,
                        project: projectDecoder,
                        body: "body",
                        url: nil,
                        day: nil,
                        startAt: nil,
                        endAt: nil,
                        tag: .development)
        let encoder = JSONEncoder()
        //Act
        let encodedTask = try? encoder.encode(task)
        //Assert
        XCTAssertNotNil(encodedTask)
    }
}
