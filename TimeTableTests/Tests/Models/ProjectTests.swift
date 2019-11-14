//
//  ProjectTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 08/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ProjectTests: XCTestCase {
    
    private var decoder: JSONDecoder = JSONDecoder()
    
    func testInitializationWithFullProjectRecord() throws {
        //Arrange
        let color = UIColor(hexString: "0c0c0c")
        let user = Project.User(name: "Admin Admin")
        let leader = Project.User(name: "Rosalind Auer")
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordResponse)
        let projectRecord = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Act
        let project = Project(decoder: projectRecord)
        //Assert
        XCTAssertEqual(project.identifier, 11)
        XCTAssertEqual(project.name, "Test Name")
        XCTAssertEqual(project.color, color)
        XCTAssertEqual(project.users.count, 1)
        XCTAssertEqual(try (project.users.first).unwrap(), user)
        XCTAssertEqual(project.leader, leader)
    }
    
    func testInitializationWithProjectRecordNullColorResponse() throws {
        //Arrange
        let user = Project.User(name: "Admin Admin")
        let leader = Project.User(name: "Rosalind Auer")
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordNullColorResponse)
        let projectRecord = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Act
        let project = Project(decoder: projectRecord)
        //Assert
        XCTAssertEqual(project.identifier, 11)
        XCTAssertEqual(project.name, "Test Name")
        XCTAssertEqual(project.color, .black)
        XCTAssertEqual(project.users.count, 1)
        XCTAssertEqual(try (project.users.first).unwrap(), user)
        XCTAssertEqual(project.leader, leader)
    }
    
    func testInitializationWithProjectRecordMissingColorKeyResponse() throws {
        //Arrange
        let user = Project.User(name: "Admin Admin")
        let leader = Project.User(name: "Rosalind Auer")
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordMissingColorKeyResponse)
        let projectRecord = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Act
        let project = Project(decoder: projectRecord)
        //Assert
        XCTAssertEqual(project.identifier, 11)
        XCTAssertEqual(project.name, "Test Name")
        XCTAssertEqual(project.color, .black)
        XCTAssertEqual(project.users.count, 1)
        XCTAssertEqual(try (project.users.first).unwrap(), user)
        XCTAssertEqual(project.leader, leader)
    }

    func testInitializationWithProjectRecordNullUserResponse() throws {
        //Arrange
        let color = UIColor(hexString: "0c0c0c")
        let leader = Project.User(name: "Rosalind Auer")
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordNullUserResponse)
        let projectRecord = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Act
        let project = Project(decoder: projectRecord)
        //Assert
        XCTAssertEqual(project.identifier, 11)
        XCTAssertEqual(project.name, "Test Name")
        XCTAssertEqual(project.color, color)
        XCTAssertEqual(project.users.count, 0)
        XCTAssertEqual(project.leader, leader)
    }
    
    func testInitializationWithProjectRecordMissingUserKeyResponse() throws {
        //Arrange
        let color = UIColor(hexString: "0c0c0c")
        let leader = Project.User(name: "Rosalind Auer")
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordMissingUserKeyResponse)
        let projectRecord = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Act
        let project = Project(decoder: projectRecord)
        //Assert
        XCTAssertEqual(project.identifier, 11)
        XCTAssertEqual(project.name, "Test Name")
        XCTAssertEqual(project.color, color)
        XCTAssertEqual(project.users.count, 0)
        XCTAssertEqual(project.leader, leader)
    }
    
    func testInitializationWithProjectRecordNullLeaderResponse() throws {
        //Arrange
        let color = UIColor(hexString: "0c0c0c")
        let user = Project.User(name: "Admin Admin")
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordNullLeaderResponse)
        let projectRecord = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Act
        let project = Project(decoder: projectRecord)
        //Assert
        XCTAssertEqual(project.identifier, 11)
        XCTAssertEqual(project.name, "Test Name")
        XCTAssertEqual(project.color, color)
        XCTAssertEqual(project.users.count, 1)
        XCTAssertEqual(try (project.users.first).unwrap(), user)
        XCTAssertNil(project.leader)
    }
    
    func testInitializationWithProjectRecordMissingLeaderKey() throws {
        //Arrange
        let color = UIColor(hexString: "0c0c0c")
        let user = Project.User(name: "Admin Admin")
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordMissingLeaderKey)
        let projectRecord = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Act
        let project = Project(decoder: projectRecord)
        //Assert
        XCTAssertEqual(project.identifier, 11)
        XCTAssertEqual(project.name, "Test Name")
        XCTAssertEqual(project.color, color)
        XCTAssertEqual(project.users.count, 1)
        XCTAssertEqual(try (project.users.first).unwrap(), user)
        XCTAssertNil(project.leader)
    }
    
    func testEqualTwoProjects() throws {
        //Arrange
        let firstProjectData = try self.json(from: ProjectRecordJSONResource.projectRecordNullLeaderResponse)
        let firstProjectRecord = try self.decoder.decode(ProjectRecordDecoder.self, from: firstProjectData)
        let secondProjectData = try self.json(from: ProjectRecordJSONResource.projectRecordNullLeaderResponse)
        let secondProjectRecord = try self.decoder.decode(ProjectRecordDecoder.self, from: secondProjectData)
        //Act
        let firstProject = Project(decoder: firstProjectRecord)
        let secondProject = Project(decoder: secondProjectRecord)
        //Assert
        XCTAssertEqual(firstProject, secondProject)
    }
}
