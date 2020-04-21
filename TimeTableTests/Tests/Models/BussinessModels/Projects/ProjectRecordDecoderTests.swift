//
//  ProjectRecordDecoderTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 08/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ProjectRecordDecoderTests: XCTestCase {}

// MARK: - Decodable
extension ProjectRecordDecoderTests {
    func testDecoding_fullModel() throws {
        //Arrange
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordResponse)
        //Act
        let sut = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 11)
        XCTAssertEqual(sut.name, "Test Name")
        XCTAssertEqual(sut.color, UIColor(hexString: "0c0c0c"))
        XCTAssertEqual(sut.leader.firstName, "Leader")
        XCTAssertEqual(sut.leader.lastName, "Best")
        XCTAssertEqual(sut.users.count, 3)
        XCTAssertEqual(sut.users.first?.id, 1)
        XCTAssertEqual(sut.users.first?.firstName, "John")
        XCTAssertEqual(sut.users.first?.lastName, "Smith")
    }
    
    func testDecoding_nullColor() throws {
        //Arrange
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordNullColorResponse)
        //Act
        let sut = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 11)
        XCTAssertEqual(sut.name, "Test Name")
        XCTAssertNil(sut.color)
        XCTAssertEqual(sut.leader.firstName, "Leader")
        XCTAssertEqual(sut.leader.lastName, "Best")
        XCTAssertEqual(sut.users.count, 3)
        XCTAssertEqual(sut.users.first?.id, 1)
        XCTAssertEqual(sut.users.first?.firstName, "John")
        XCTAssertEqual(sut.users.first?.lastName, "Smith")
    }

    func testDecoding_missingColorKey() throws {
        //Arrange
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordMissingColorKeyResponse)
        //Act
        let sut = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 11)
        XCTAssertEqual(sut.name, "Test Name")
        XCTAssertNil(sut.color)
        XCTAssertEqual(sut.leader.firstName, "Leader")
        XCTAssertEqual(sut.leader.lastName, "Best")
        XCTAssertEqual(sut.users.count, 3)
        XCTAssertEqual(sut.users.first?.id, 1)
        XCTAssertEqual(sut.users.first?.firstName, "John")
        XCTAssertEqual(sut.users.first?.lastName, "Smith")
    }
    
    func testDecoding_nullLeaderFirstName() throws {
        //Arrange
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordNullLeaderFirstNameResponse)
        //Act
        let sut = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 11)
        XCTAssertEqual(sut.name, "Test Name")
        XCTAssertEqual(sut.color, UIColor(hexString: "0c0c0c"))
        XCTAssertNil(sut.leader.firstName)
        XCTAssertEqual(sut.leader.lastName, "Best")
        XCTAssertEqual(sut.users.count, 3)
        XCTAssertEqual(sut.users.first?.id, 1)
        XCTAssertEqual(sut.users.first?.firstName, "John")
        XCTAssertEqual(sut.users.first?.lastName, "Smith")
    }
    
    func testDecoding_missingLeaderFirstNameKey() throws {
        //Arrange
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordMissingLeaderFirstNameKeyResponse)
        //Act
        let sut = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 11)
        XCTAssertEqual(sut.name, "Test Name")
        XCTAssertEqual(sut.color, UIColor(hexString: "0c0c0c"))
        XCTAssertNil(sut.leader.firstName)
        XCTAssertEqual(sut.leader.lastName, "Best")
        XCTAssertEqual(sut.users.count, 3)
        XCTAssertEqual(sut.users.first?.id, 1)
        XCTAssertEqual(sut.users.first?.firstName, "John")
        XCTAssertEqual(sut.users.first?.lastName, "Smith")
    }
    
    func testDecoding_nullLeaderLastName() throws {
        //Arrange
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordNullLeaderLastNameResponse)
        //Act
        let sut = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 11)
        XCTAssertEqual(sut.name, "Test Name")
        XCTAssertEqual(sut.color, UIColor(hexString: "0c0c0c"))
        XCTAssertEqual(sut.leader.firstName, "Leader")
        XCTAssertNil(sut.leader.lastName)
        XCTAssertEqual(sut.users.count, 3)
        XCTAssertEqual(sut.users.first?.id, 1)
        XCTAssertEqual(sut.users.first?.firstName, "John")
        XCTAssertEqual(sut.users.first?.lastName, "Smith")
    }
    
    func testDecoding_missingLeaderLastNameKey() throws {
        //Arrange
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordMissingLeaderLastNameKeyResponse)
        //Act
        let sut = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 11)
        XCTAssertEqual(sut.name, "Test Name")
        XCTAssertEqual(sut.color, UIColor(hexString: "0c0c0c"))
        XCTAssertEqual(sut.leader.firstName, "Leader")
        XCTAssertNil(sut.leader.lastName)
        XCTAssertEqual(sut.users.count, 3)
        XCTAssertEqual(sut.users.first?.id, 1)
        XCTAssertEqual(sut.users.first?.firstName, "John")
        XCTAssertEqual(sut.users.first?.lastName, "Smith")
    }
    
    func testDecoding_nullUsers() throws {
        //Arrange
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordNullUsersResponse)
        //Act
        let sut = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 11)
        XCTAssertEqual(sut.name, "Test Name")
        XCTAssertEqual(sut.color, UIColor(hexString: "0c0c0c"))
        XCTAssertEqual(sut.leader.firstName, "Leader")
        XCTAssertEqual(sut.leader.lastName, "Best")
        XCTAssertTrue(sut.users.isEmpty)
    }
    
    func testDecoding_missingUsersKey() throws {
        //Arrange
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordMissingUsersKeyResponse)
        //Act
        let sut = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 11)
        XCTAssertEqual(sut.name, "Test Name")
        XCTAssertEqual(sut.color, UIColor(hexString: "0c0c0c"))
        XCTAssertEqual(sut.leader.firstName, "Leader")
        XCTAssertEqual(sut.leader.lastName, "Best")
        XCTAssertTrue(sut.users.isEmpty)
    }
}
