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
        let sut = Project(decoder: projectRecord)
        //Assert
        XCTAssertEqual(sut.identifier, 11)
        XCTAssertEqual(sut.name, "Test Name")
        XCTAssertEqual(sut.color, color)
        XCTAssertEqual(sut.users.count, 1)
        XCTAssertEqual(try (sut.users.first).unwrap(), user)
        XCTAssertEqual(sut.leader, leader)
    }
    
    func testInitializationWithProjectRecordNullColorResponse() throws {
        //Arrange
        let user = Project.User(name: "Admin Admin")
        let leader = Project.User(name: "Rosalind Auer")
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordNullColorResponse)
        let projectRecord = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Act
        let sut = Project(decoder: projectRecord)
        //Assert
        XCTAssertEqual(sut.identifier, 11)
        XCTAssertEqual(sut.name, "Test Name")
        XCTAssertEqual(sut.color, .black)
        XCTAssertEqual(sut.users.count, 1)
        XCTAssertEqual(try (sut.users.first).unwrap(), user)
        XCTAssertEqual(sut.leader, leader)
    }
    
    func testInitializationWithProjectRecordMissingColorKeyResponse() throws {
        //Arrange
        let user = Project.User(name: "Admin Admin")
        let leader = Project.User(name: "Rosalind Auer")
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordMissingColorKeyResponse)
        let projectRecord = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Act
        let sut = Project(decoder: projectRecord)
        //Assert
        XCTAssertEqual(sut.identifier, 11)
        XCTAssertEqual(sut.name, "Test Name")
        XCTAssertEqual(sut.color, .black)
        XCTAssertEqual(sut.users.count, 1)
        XCTAssertEqual(try (sut.users.first).unwrap(), user)
        XCTAssertEqual(sut.leader, leader)
    }

    func testInitializationWithProjectRecordNullUserResponse() throws {
        //Arrange
        let color = UIColor(hexString: "0c0c0c")
        let leader = Project.User(name: "Rosalind Auer")
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordNullUserResponse)
        let projectRecord = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Act
        let sut = Project(decoder: projectRecord)
        //Assert
        XCTAssertEqual(sut.identifier, 11)
        XCTAssertEqual(sut.name, "Test Name")
        XCTAssertEqual(sut.color, color)
        XCTAssertEqual(sut.users.count, 0)
        XCTAssertEqual(sut.leader, leader)
    }
    
    func testInitializationWithProjectRecordMissingUserKeyResponse() throws {
        //Arrange
        let color = UIColor(hexString: "0c0c0c")
        let leader = Project.User(name: "Rosalind Auer")
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordMissingUserKeyResponse)
        let projectRecord = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Act
        let sut = Project(decoder: projectRecord)
        //Assert
        XCTAssertEqual(sut.identifier, 11)
        XCTAssertEqual(sut.name, "Test Name")
        XCTAssertEqual(sut.color, color)
        XCTAssertEqual(sut.users.count, 0)
        XCTAssertEqual(sut.leader, leader)
    }
    
    func testInitializationWithProjectRecordNullLeaderResponse() throws {
        //Arrange
        let color = UIColor(hexString: "0c0c0c")
        let user = Project.User(name: "Admin Admin")
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordNullLeaderResponse)
        let projectRecord = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Act
        let sut = Project(decoder: projectRecord)
        //Assert
        XCTAssertEqual(sut.identifier, 11)
        XCTAssertEqual(sut.name, "Test Name")
        XCTAssertEqual(sut.color, color)
        XCTAssertEqual(sut.users.count, 1)
        XCTAssertEqual(try (sut.users.first).unwrap(), user)
        XCTAssertNil(sut.leader)
    }
    
    func testInitializationWithProjectRecordMissingLeaderKey() throws {
        //Arrange
        let color = UIColor(hexString: "0c0c0c")
        let user = Project.User(name: "Admin Admin")
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordMissingLeaderKey)
        let projectRecord = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Act
        let sut = Project(decoder: projectRecord)
        //Assert
        XCTAssertEqual(sut.identifier, 11)
        XCTAssertEqual(sut.name, "Test Name")
        XCTAssertEqual(sut.color, color)
        XCTAssertEqual(sut.users.count, 1)
        XCTAssertEqual(try (sut.users.first).unwrap(), user)
        XCTAssertNil(sut.leader)
    }
}
