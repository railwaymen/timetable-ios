//
//  ProjectDecoderTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 21/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ProjectDecoderTests: XCTestCase {
    
    private enum WorkTimesProjectResponse: String, JSONFileResource {
        case workTimesProjectResponse
        case workTimesProjectNullColorResponse
        case workTimesProjectMissingColorKeyResponse
    }
    
    private var decoder: JSONDecoder = JSONDecoder()
    
    func testParsingWorkTimesProjectResponse() throws {
        //Arrange
        let data = try self.json(from: WorkTimesProjectResponse.workTimesProjectResponse)
        //Act
        let worksTimeProject = try decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(worksTimeProject.identifier, 3)
        XCTAssertEqual(worksTimeProject.name, "Lorem ipsum")
        XCTAssertEqual(worksTimeProject.color, UIColor(string: "fe0404"))
        XCTAssertTrue(worksTimeProject.workTimesAllowsTask)
        XCTAssertFalse(worksTimeProject.isLunch)
    }
    
    func testParsingWorkTimesProjectNullColorResponse() throws {
        //Arrange
        let data = try self.json(from: WorkTimesProjectResponse.workTimesProjectNullColorResponse)
        //Act
        let worksTimeProject = try decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(worksTimeProject.identifier, 3)
        XCTAssertEqual(worksTimeProject.name, "Lorem ipsum")
        XCTAssertNil(worksTimeProject.color)
        XCTAssertTrue(worksTimeProject.workTimesAllowsTask)
        XCTAssertFalse(worksTimeProject.isLunch)
    }
    
    func testParsingWorkTimesProjectMissingColorKeyResponse() throws {
        //Arrange
        let data = try self.json(from: WorkTimesProjectResponse.workTimesProjectMissingColorKeyResponse)
        //Act
        let worksTimeProject = try decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(worksTimeProject.identifier, 3)
        XCTAssertEqual(worksTimeProject.name, "Lorem ipsum")
        XCTAssertNil(worksTimeProject.color)
        XCTAssertTrue(worksTimeProject.workTimesAllowsTask)
        XCTAssertFalse(worksTimeProject.isLunch)
    }
}
