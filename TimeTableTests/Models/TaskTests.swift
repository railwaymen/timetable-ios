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
    }
    
    private var decoder: JSONDecoder = JSONDecoder()
    
    func testTitleForProjectNoneType() {
        //Arrange
        let task = Task(project: .none, body: "body", url: nil, fromDate: nil, toDate: nil)
        //Act
        let title = task.title
        //Assert
        XCTAssertEqual(title, "work_time.text_field.select_project".localized)
    }
    
    func testTitleForProjectSomeType() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectResponse.simpleProjectFullResponse)
        let projectDecoder = try decoder.decode(ProjectDecoder.self, from: data)
        let task = Task(project: .some(projectDecoder), body: "body", url: nil, fromDate: nil, toDate: nil)
        //Act
        let title = task.title
        //Assert
        XCTAssertEqual(title, "asdsa")
    }
    
    func testAllowTaskForProjectNoneType() {
        //Arrange
        let task = Task(project: .none, body: "body", url: nil, fromDate: nil, toDate: nil)
        //Act
        let allowsTask = task.allowsTask
        //Assert
        XCTAssertFalse(allowsTask)
    }
    
    func testAllowTaskForProjectSomeType() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectResponse.simpleProjectFullResponse)
        let projectDecoder = try decoder.decode(ProjectDecoder.self, from: data)
        let task = Task(project: .some(projectDecoder), body: "body", url: nil, fromDate: nil, toDate: nil)
        //Act
        let allowsTask = task.allowsTask
        //Assert
        XCTAssertTrue(allowsTask)
    }
    
    func testTypeForProjectNoneType() {
        //Arrange
        let task = Task(project: .none, body: "body", url: nil, fromDate: nil, toDate: nil)
        //Act
        let type = task.type
        //Assert
        XCTAssertNil(type)
    }
    
    func testTypeForProjectSomeType() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectResponse.simpleProjectFullResponse)
        let projectDecoder = try decoder.decode(ProjectDecoder.self, from: data)
        let task = Task(project: .some(projectDecoder), body: "body", url: nil, fromDate: nil, toDate: nil)
        //Act
        let type = try task.type.unwrap()
        //Assert
        switch type {
        case .standard: break
        default: XCTFail()
        }
    }
}
