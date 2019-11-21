//
//  ProjectRecordDecoderTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 08/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ProjectRecordDecoderTests: XCTestCase {

    private var decoder: JSONDecoder = JSONDecoder()
    
    func testParsingProjectRecordResponseSucceed() throws {
        //Arrange
        let user = ProjectRecordDecoder.User(name: "Admin Admin")
        let leader = ProjectRecordDecoder.User(name: "Rosalind Auer")
        let color = UIColor(hexString: "0c0c0c")
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordResponse)
        //Act
        let projectRecord = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(projectRecord.identifier, 16281)
        XCTAssertEqual(projectRecord.projectIdentifier, 11)
        XCTAssertEqual(projectRecord.name, "Test Name")
        XCTAssertEqual(projectRecord.color, color)
        XCTAssertEqual(projectRecord.user, user)
        XCTAssertEqual(projectRecord.leader, leader)
    }
    
    func testParsingProjectRecordNullColorResponseSucceed() throws {
        //Arrange
        let user = ProjectRecordDecoder.User(name: "Admin Admin")
        let leader = ProjectRecordDecoder.User(name: "Rosalind Auer")
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordNullColorResponse)
        //Act
        let projectRecord = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(projectRecord.identifier, 16281)
        XCTAssertEqual(projectRecord.projectIdentifier, 11)
        XCTAssertEqual(projectRecord.name, "Test Name")
        XCTAssertNil(projectRecord.color)
        XCTAssertEqual(projectRecord.user, user)
        XCTAssertEqual(projectRecord.leader, leader)
    }
    
    func testParsingProjectRecordMissingColorKeyResponseSucceed() throws {
        //Arrange
        let user = ProjectRecordDecoder.User(name: "Admin Admin")
        let leader = ProjectRecordDecoder.User(name: "Rosalind Auer")
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordMissingColorKeyResponse)
        //Act
        let projectRecord = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(projectRecord.identifier, 16281)
        XCTAssertEqual(projectRecord.projectIdentifier, 11)
        XCTAssertEqual(projectRecord.name, "Test Name")
        XCTAssertNil(projectRecord.color)
        XCTAssertEqual(projectRecord.user, user)
        XCTAssertEqual(projectRecord.leader, leader)
    }
    
    func testParsingProjectRecordNullUserResponseSucceed() throws {
        //Arrange
        let leader = ProjectRecordDecoder.User(name: "Rosalind Auer")
        let color = UIColor(hexString: "0c0c0c")
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordNullUserResponse)
        //Act
        let projectRecord = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(projectRecord.identifier, 16281)
        XCTAssertEqual(projectRecord.projectIdentifier, 11)
        XCTAssertEqual(projectRecord.name, "Test Name")
        XCTAssertEqual(projectRecord.color, color)
        XCTAssertNil(projectRecord.user)
        XCTAssertEqual(projectRecord.leader, leader)
    }
    
    func testParsingProjectRecordMissingUserKeyResponseSucceed() throws {
        //Arrange
        let leader = ProjectRecordDecoder.User(name: "Rosalind Auer")
        let color = UIColor(hexString: "0c0c0c")
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordMissingUserKeyResponse)
        //Act
        let projectRecord = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(projectRecord.identifier, 16281)
        XCTAssertEqual(projectRecord.projectIdentifier, 11)
        XCTAssertEqual(projectRecord.name, "Test Name")
        XCTAssertEqual(projectRecord.color, color)
        XCTAssertNil(projectRecord.user)
        XCTAssertEqual(projectRecord.leader, leader)
    }
    
    func testParsingProjectRecordNullLeaderResponseSucceed() throws {
        //Arrange
        let user = ProjectRecordDecoder.User(name: "Admin Admin")
        let color = UIColor(hexString: "0c0c0c")
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordNullLeaderResponse)
        //Act
        let projectRecord = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(projectRecord.identifier, 16281)
        XCTAssertEqual(projectRecord.projectIdentifier, 11)
        XCTAssertEqual(projectRecord.name, "Test Name")
        XCTAssertEqual(projectRecord.color, color)
        XCTAssertEqual(projectRecord.user, user)
        XCTAssertNil(projectRecord.leader)
    }
    
    func testParsingProjectRecordMissingLeaderKeySucceed() throws {
        //Arrange
        let user = ProjectRecordDecoder.User(name: "Admin Admin")
        let color = UIColor(hexString: "0c0c0c")
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordMissingLeaderKey)
        //Act
        let projectRecord = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(projectRecord.identifier, 16281)
        XCTAssertEqual(projectRecord.projectIdentifier, 11)
        XCTAssertEqual(projectRecord.name, "Test Name")
        XCTAssertEqual(projectRecord.color, color)
        XCTAssertEqual(projectRecord.user, user)
        XCTAssertNil(projectRecord.leader)
    }
}