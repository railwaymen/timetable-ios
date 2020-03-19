//
//  ProjectRecordDecoderLeaderTests.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 19/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ProjectRecordDecoderLeaderTests: XCTestCase {
    private let factory: ProjectRecordDecoderFactory = ProjectRecordDecoderFactory()
}

// MARK: - name
extension ProjectRecordDecoderLeaderTests {
    func testName_fullData_returnsFullName() throws {
        //Arrange
        let sut = try self.factory.buildLeader(firstName: "John", lastName: "Smith")
        //Act
        let name = sut.name
        //Assert
        XCTAssertEqual(name, "John Smith")
    }
    
    func testName_nilFirstName_returnsLastName() throws {
        //Arrange
        let sut = try self.factory.buildLeader(firstName: nil, lastName: "Smith")
        //Act
        let name = sut.name
        //Assert
        XCTAssertEqual(name, "Smith")
    }
    
    func testName_nilLastName_returnFirstName() throws {
        //Arrange
        let sut = try self.factory.buildLeader(firstName: "John", lastName: nil)
        //Act
        let name = sut.name
        //Assert
        XCTAssertEqual(name, "John")
    }
    
    func testName_nilFirstNameAndLastName_returnsEmptyString() throws {
        //Arrange
        let sut = try self.factory.buildLeader(firstName: nil, lastName: nil)
        //Act
        let name = sut.name
        //Assert
        XCTAssertEqual(name, "")
    }
}
