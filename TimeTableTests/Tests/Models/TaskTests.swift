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
    
    func testTitleForProjectNoneType() {
        //Arrange
        let sut = Task(workTimeIdentifier: nil,
                       project: nil,
                       body: "body",
                       url: nil,
                       day: nil,
                       startAt: nil,
                       endAt: nil,
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
        let sut = Task(workTimeIdentifier: nil,
                       project: projectDecoder,
                       body: "body",
                       url: nil,
                       day: nil,
                       startAt: nil,
                       endAt: nil,
                       tag: .development)
        //Act
        let title = sut.title
        //Assert
        XCTAssertEqual(title, "asdsa")
    }
    
    func testAllowTaskForProjectNoneType() {
        //Arrange
        let sut = Task(workTimeIdentifier: nil,
                       project: nil,
                       body: "body",
                       url: nil,
                       day: nil,
                       startAt: nil,
                       endAt: nil,
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
        let sut = Task(workTimeIdentifier: nil,
                       project: projectDecoder,
                       body: "body",
                       url: nil,
                       day: nil,
                       startAt: nil,
                       endAt: nil,
                       tag: .development)
        //Act
        let allowsTask = sut.allowsTask
        //Assert
        XCTAssertTrue(allowsTask)
    }
    
    func testTypeForProjectNoneType() {
        //Arrange
        let sut = Task(workTimeIdentifier: nil,
                       project: nil,
                       body: "body",
                       url: nil,
                       day: nil,
                       startAt: nil,
                       endAt: nil,
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
        let sut = Task(workTimeIdentifier: nil,
                       project: projectDecoder,
                       body: "body",
                       url: nil,
                       day: nil,
                       startAt: nil,
                       endAt: nil,
                       tag: .development)
        //Act
        let type = try sut.type.unwrap()
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
        let sut = Task(workTimeIdentifier: nil,
                       project: projectDecoder,
                       body: "body",
                       url: nil,
                       day: nil,
                       startAt: nil,
                       endAt: nil,
                       tag: .development)
        //Act
        let type = try sut.type.unwrap()
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
        let sut = Task(workTimeIdentifier: nil,
                       project: projectDecoder,
                       body: "body",
                       url: nil,
                       day: nil,
                       startAt: nil,
                       endAt: nil,
                       tag: .development)
        //Act
        let type = try sut.type.unwrap()
        //Assert
        switch type {
        case .lunch(let timeInterval):
            XCTAssertEqual(timeInterval, TimeInterval(60 * 30))
        default: XCTFail()
        }
    }
    
    func testEncodingThrowsErrorWhileProjectIsNil() {
        //Arrange
        let sut = Task(workTimeIdentifier: nil,
                       project: nil,
                       body: "body",
                       url: nil,
                       day: nil,
                       startAt: nil,
                       endAt: nil,
                       tag: .development)
        //Act
        let encodedTask = try? self.encoder.encode(sut)
        //Assert
        XCTAssertNil(encodedTask)
    }
    
    func testEncodingProject() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectWithALunchTrueResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: data)
        let sut = Task(workTimeIdentifier: nil,
                       project: projectDecoder,
                       body: "body",
                       url: nil,
                       day: nil,
                       startAt: nil,
                       endAt: nil,
                       tag: .development)
        //Act
        let encodedTask = try? self.encoder.encode(sut)
        //Assert
        XCTAssertNotNil(encodedTask)
    }
}
