//
//  ProjectRecordDecoderUserTests.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 19/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ProjectRecordDecoderUserTests: XCTestCase {
    private let factory: ProjectRecordDecoderFactory = ProjectRecordDecoderFactory()
}

// MARK: - Decodable
extension ProjectRecordDecoderUserTests {
    func testsDecoding_fullModel() throws {
        //Arrange
        let data = try self.json(from: ProjectRecordUserJSONResource.projectRecordUserFullResponse)
        //Act
        let sut = try self.decoder.decode(ProjectRecordDecoder.User.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 132)
        XCTAssertEqual(sut.firstName, "Trevor")
        XCTAssertEqual(sut.lastName, "Buck")
    }
}

// MARK: - name
extension ProjectRecordDecoderUserTests {
    func testName_returnsFullName() throws {
        //Arrange
        let sut = try self.factory.buildUser(firstName: "John", lastName: "Smith")
        //Act
        let name = sut.name
        //Assert
        XCTAssertEqual(name, "John Smith")
    }
}
