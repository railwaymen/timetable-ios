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
    
    private enum ProjectRecordResponse: String, JSONFileResource {
        case projectRecordResponse
        case projectRecordNullColorResponse
        case projectRecordMissingColorKeyResponse
        case projectRecordNullUserResponse
        case projectRecordMissingUserKeyResponse
        case projectRecordNullLeaderResponse
        case projectRecordMissingLeaderKey
    }
    
    private var decoder: JSONDecoder = JSONDecoder()
    
    func testParsingProjectRecordResponseSucceed() throws {
        //Arrange
        let user = ProjectRecordDecoder.User(name: "Admin Admin")
        let leader = ProjectRecordDecoder.User(name: "Rosalind Auer")
        let color = UIColor(hexString: "0c0c0c")
        let data = try self.json(from: ProjectRecordResponse.projectRecordResponse)
        //Act
        let projectRecord = try decoder.decode(ProjectRecordDecoder.self, from: data)
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
        let data = try self.json(from: ProjectRecordResponse.projectRecordNullColorResponse)
        //Act
        let projectRecord = try decoder.decode(ProjectRecordDecoder.self, from: data)
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
        let data = try self.json(from: ProjectRecordResponse.projectRecordMissingColorKeyResponse)
        //Act
        let projectRecord = try decoder.decode(ProjectRecordDecoder.self, from: data)
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
        let data = try self.json(from: ProjectRecordResponse.projectRecordNullUserResponse)
        //Act
        let projectRecord = try decoder.decode(ProjectRecordDecoder.self, from: data)
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
        let data = try self.json(from: ProjectRecordResponse.projectRecordMissingUserKeyResponse)
        //Act
        let projectRecord = try decoder.decode(ProjectRecordDecoder.self, from: data)
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
        let data = try self.json(from: ProjectRecordResponse.projectRecordNullLeaderResponse)
        //Act
        let projectRecord = try decoder.decode(ProjectRecordDecoder.self, from: data)
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
        let data = try self.json(from: ProjectRecordResponse.projectRecordMissingLeaderKey)
        //Act
        let projectRecord = try decoder.decode(ProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(projectRecord.identifier, 16281)
        XCTAssertEqual(projectRecord.projectIdentifier, 11)
        XCTAssertEqual(projectRecord.name, "Test Name")
        XCTAssertEqual(projectRecord.color, color)
        XCTAssertEqual(projectRecord.user, user)
        XCTAssertNil(projectRecord.leader)
    }
}
