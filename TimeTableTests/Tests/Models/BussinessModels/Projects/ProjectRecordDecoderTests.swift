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
    
    func testParsingProjectRecordResponseSucceed() throws {
        //Arrange
        let user = ProjectRecordDecoder.User(name: "Admin Admin")
        let leader = ProjectRecordDecoder.User(name: "Rosalind Auer")
        let color = UIColor(hexString: "0c0c0c")
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordResponse)
        //Act
        let sut = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 16281)
        XCTAssertEqual(sut.projectIdentifier, 11)
        XCTAssertEqual(sut.name, "Test Name")
        XCTAssertEqual(sut.color, color)
        XCTAssertEqual(sut.user, user)
        XCTAssertEqual(sut.leader, leader)
    }
    
    func testParsingProjectRecordNullColorResponseSucceed() throws {
        //Arrange
        let user = ProjectRecordDecoder.User(name: "Admin Admin")
        let leader = ProjectRecordDecoder.User(name: "Rosalind Auer")
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordNullColorResponse)
        //Act
        let sut = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 16281)
        XCTAssertEqual(sut.projectIdentifier, 11)
        XCTAssertEqual(sut.name, "Test Name")
        XCTAssertNil(sut.color)
        XCTAssertEqual(sut.user, user)
        XCTAssertEqual(sut.leader, leader)
    }
    
    func testParsingProjectRecordMissingColorKeyResponseSucceed() throws {
        //Arrange
        let user = ProjectRecordDecoder.User(name: "Admin Admin")
        let leader = ProjectRecordDecoder.User(name: "Rosalind Auer")
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordMissingColorKeyResponse)
        //Act
        let sut = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 16281)
        XCTAssertEqual(sut.projectIdentifier, 11)
        XCTAssertEqual(sut.name, "Test Name")
        XCTAssertNil(sut.color)
        XCTAssertEqual(sut.user, user)
        XCTAssertEqual(sut.leader, leader)
    }
    
    func testParsingProjectRecordNullUserResponseSucceed() throws {
        //Arrange
        let leader = ProjectRecordDecoder.User(name: "Rosalind Auer")
        let color = UIColor(hexString: "0c0c0c")
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordNullUserResponse)
        //Act
        let sut = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 16281)
        XCTAssertEqual(sut.projectIdentifier, 11)
        XCTAssertEqual(sut.name, "Test Name")
        XCTAssertEqual(sut.color, color)
        XCTAssertNil(sut.user)
        XCTAssertEqual(sut.leader, leader)
    }
    
    func testParsingProjectRecordMissingUserKeyResponseSucceed() throws {
        //Arrange
        let leader = ProjectRecordDecoder.User(name: "Rosalind Auer")
        let color = UIColor(hexString: "0c0c0c")
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordMissingUserKeyResponse)
        //Act
        let sut = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 16281)
        XCTAssertEqual(sut.projectIdentifier, 11)
        XCTAssertEqual(sut.name, "Test Name")
        XCTAssertEqual(sut.color, color)
        XCTAssertNil(sut.user)
        XCTAssertEqual(sut.leader, leader)
    }
    
    func testParsingProjectRecordNullLeaderResponseSucceed() throws {
        //Arrange
        let user = ProjectRecordDecoder.User(name: "Admin Admin")
        let color = UIColor(hexString: "0c0c0c")
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordNullLeaderResponse)
        //Act
        let sut = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 16281)
        XCTAssertEqual(sut.projectIdentifier, 11)
        XCTAssertEqual(sut.name, "Test Name")
        XCTAssertEqual(sut.color, color)
        XCTAssertEqual(sut.user, user)
        XCTAssertNil(sut.leader)
    }
    
    func testParsingProjectRecordMissingLeaderKeySucceed() throws {
        //Arrange
        let user = ProjectRecordDecoder.User(name: "Admin Admin")
        let color = UIColor(hexString: "0c0c0c")
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordMissingLeaderKey)
        //Act
        let sut = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 16281)
        XCTAssertEqual(sut.projectIdentifier, 11)
        XCTAssertEqual(sut.name, "Test Name")
        XCTAssertEqual(sut.color, color)
        XCTAssertEqual(sut.user, user)
        XCTAssertNil(sut.leader)
    }
}
