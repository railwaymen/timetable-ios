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
    
    private enum SimpleProjectResponse: String, JSONFileResource {
        case simpleProjectFullResponse
        case simpleProjectNullColorResponse
        case simpleProjectMissingColorKeyResponse
        case simpleProjectNullAutofillResponse
        case simpleProjectMissingAutofillKeyResponse
        case simpleProjectNullInternalResponse
        case simpleProjectMissingInternalKeyResponse
        case simpleProjectNullCountDurationResponse
        case simpleProjectMissingCountDurationKeyResponse
        case simpleProjectNullActiveResponse
        case simpleProjectMissingActiveKeyResponse
        case simpleProjectNullLunchResponse
        case simpleProjectMissingLunchKeyResponse
        case simpleProjectNullWorkTimesAllowsTaskResponse
        case simpleProjectMissingWorkTimesAllowsTaskKeyResponse
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
        XCTAssertNil(worksTimeProject.autofill)
        XCTAssertNil(worksTimeProject.countDuration)
        XCTAssertNil(worksTimeProject.isActive)
        XCTAssertNil(worksTimeProject.isInternal)
        XCTAssertFalse(worksTimeProject.isLunch)
        XCTAssertTrue(worksTimeProject.workTimesAllowsTask)
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
        XCTAssertNil(worksTimeProject.autofill)
        XCTAssertNil(worksTimeProject.countDuration)
        XCTAssertNil(worksTimeProject.isActive)
        XCTAssertNil(worksTimeProject.isInternal)
        XCTAssertFalse(worksTimeProject.isLunch)
        XCTAssertTrue(worksTimeProject.workTimesAllowsTask)
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
        XCTAssertNil(worksTimeProject.autofill)
        XCTAssertNil(worksTimeProject.countDuration)
        XCTAssertNil(worksTimeProject.isActive)
        XCTAssertNil(worksTimeProject.isInternal)
        XCTAssertFalse(worksTimeProject.isLunch)
        XCTAssertTrue(worksTimeProject.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectFullResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectResponse.simpleProjectFullResponse)
        //Act
        let worksTimeProject = try decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(worksTimeProject.identifier, 11)
        XCTAssertEqual(worksTimeProject.name, "asdsa")
        XCTAssertEqual(worksTimeProject.color, UIColor(string: "0c0cOc"))
        XCTAssertFalse(try worksTimeProject.autofill.unwrap())
        XCTAssertTrue(try worksTimeProject.countDuration.unwrap())
        XCTAssertTrue(try worksTimeProject.isActive.unwrap())
        XCTAssertFalse(try worksTimeProject.isInternal.unwrap())
        XCTAssertFalse(worksTimeProject.isLunch)
        XCTAssertTrue(worksTimeProject.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectNullColorResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectResponse.simpleProjectNullColorResponse)
        //Act
        let worksTimeProject = try decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(worksTimeProject.identifier, 11)
        XCTAssertEqual(worksTimeProject.name, "asdsa")
        XCTAssertNil(worksTimeProject.color)
        XCTAssertFalse(try worksTimeProject.autofill.unwrap())
        XCTAssertTrue(try worksTimeProject.countDuration.unwrap())
        XCTAssertTrue(try worksTimeProject.isActive.unwrap())
        XCTAssertFalse(try worksTimeProject.isInternal.unwrap())
        XCTAssertFalse(worksTimeProject.isLunch)
        XCTAssertTrue(worksTimeProject.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectMissingColorKeyResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectResponse.simpleProjectMissingColorKeyResponse)
        //Act
        let worksTimeProject = try decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(worksTimeProject.identifier, 11)
        XCTAssertEqual(worksTimeProject.name, "asdsa")
        XCTAssertNil(worksTimeProject.color)
        XCTAssertFalse(try worksTimeProject.autofill.unwrap())
        XCTAssertTrue(try worksTimeProject.countDuration.unwrap())
        XCTAssertTrue(try worksTimeProject.isActive.unwrap())
        XCTAssertFalse(try worksTimeProject.isInternal.unwrap())
        XCTAssertFalse(worksTimeProject.isLunch)
        XCTAssertTrue(worksTimeProject.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectNullAutofillResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectResponse.simpleProjectNullAutofillResponse)
        //Act
        let worksTimeProject = try decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(worksTimeProject.identifier, 11)
        XCTAssertEqual(worksTimeProject.name, "asdsa")
        XCTAssertEqual(worksTimeProject.color, UIColor(string: "0c0cOc"))
        XCTAssertNil(worksTimeProject.autofill)
        XCTAssertTrue(try worksTimeProject.countDuration.unwrap())
        XCTAssertTrue(try worksTimeProject.isActive.unwrap())
        XCTAssertFalse(try worksTimeProject.isInternal.unwrap())
        XCTAssertFalse(worksTimeProject.isLunch)
        XCTAssertTrue(worksTimeProject.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectMissingAutofillKeyResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectResponse.simpleProjectMissingAutofillKeyResponse)
        //Act
        let worksTimeProject = try decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(worksTimeProject.identifier, 11)
        XCTAssertEqual(worksTimeProject.name, "asdsa")
        XCTAssertEqual(worksTimeProject.color, UIColor(string: "0c0cOc"))
        XCTAssertNil(worksTimeProject.autofill)
        XCTAssertTrue(try worksTimeProject.countDuration.unwrap())
        XCTAssertTrue(try worksTimeProject.isActive.unwrap())
        XCTAssertFalse(try worksTimeProject.isInternal.unwrap())
        XCTAssertFalse(worksTimeProject.isLunch)
        XCTAssertTrue(worksTimeProject.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectNullInternalResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectResponse.simpleProjectNullInternalResponse)
        //Act
        let worksTimeProject = try decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(worksTimeProject.identifier, 11)
        XCTAssertEqual(worksTimeProject.name, "asdsa")
        XCTAssertEqual(worksTimeProject.color, UIColor(string: "0c0cOc"))
        XCTAssertFalse(try worksTimeProject.autofill.unwrap())
        XCTAssertTrue(try worksTimeProject.countDuration.unwrap())
        XCTAssertTrue(try worksTimeProject.isActive.unwrap())
        XCTAssertNil(worksTimeProject.isInternal)
        XCTAssertFalse(worksTimeProject.isLunch)
        XCTAssertTrue(worksTimeProject.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectMissingInternalKeyResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectResponse.simpleProjectMissingInternalKeyResponse)
        //Act
        let worksTimeProject = try decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(worksTimeProject.identifier, 11)
        XCTAssertEqual(worksTimeProject.name, "asdsa")
        XCTAssertEqual(worksTimeProject.color, UIColor(string: "0c0cOc"))
        XCTAssertFalse(try worksTimeProject.autofill.unwrap())
        XCTAssertTrue(try worksTimeProject.countDuration.unwrap())
        XCTAssertTrue(try worksTimeProject.isActive.unwrap())
        XCTAssertNil(worksTimeProject.isInternal)
        XCTAssertFalse(worksTimeProject.isLunch)
        XCTAssertTrue(worksTimeProject.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectNullCountDurationResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectResponse.simpleProjectNullCountDurationResponse)
        //Act
        let worksTimeProject = try decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(worksTimeProject.identifier, 11)
        XCTAssertEqual(worksTimeProject.name, "asdsa")
        XCTAssertEqual(worksTimeProject.color, UIColor(string: "0c0cOc"))
        XCTAssertFalse(try worksTimeProject.autofill.unwrap())
        XCTAssertNil(worksTimeProject.countDuration)
        XCTAssertTrue(try worksTimeProject.isActive.unwrap())
        XCTAssertFalse(try worksTimeProject.isInternal.unwrap())
        XCTAssertFalse(worksTimeProject.isLunch)
        XCTAssertTrue(worksTimeProject.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectMissingCountDurationKeyResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectResponse.simpleProjectMissingCountDurationKeyResponse)
        //Act
        let worksTimeProject = try decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(worksTimeProject.identifier, 11)
        XCTAssertEqual(worksTimeProject.name, "asdsa")
        XCTAssertEqual(worksTimeProject.color, UIColor(string: "0c0cOc"))
        XCTAssertFalse(try worksTimeProject.autofill.unwrap())
        XCTAssertNil(worksTimeProject.countDuration)
        XCTAssertTrue(try worksTimeProject.isActive.unwrap())
        XCTAssertFalse(try worksTimeProject.isInternal.unwrap())
        XCTAssertFalse(worksTimeProject.isLunch)
        XCTAssertTrue(worksTimeProject.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectNullActiveResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectResponse.simpleProjectNullActiveResponse)
        //Act
        let worksTimeProject = try decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(worksTimeProject.identifier, 11)
        XCTAssertEqual(worksTimeProject.name, "asdsa")
        XCTAssertEqual(worksTimeProject.color, UIColor(string: "0c0cOc"))
        XCTAssertFalse(try worksTimeProject.autofill.unwrap())
        XCTAssertTrue(try worksTimeProject.countDuration.unwrap())
        XCTAssertNil(worksTimeProject.isActive)
        XCTAssertFalse(try worksTimeProject.isInternal.unwrap())
        XCTAssertFalse(worksTimeProject.isLunch)
        XCTAssertTrue(worksTimeProject.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectMissingActiveKeyResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectResponse.simpleProjectMissingActiveKeyResponse)
        //Act
        let worksTimeProject = try decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(worksTimeProject.identifier, 11)
        XCTAssertEqual(worksTimeProject.name, "asdsa")
        XCTAssertEqual(worksTimeProject.color, UIColor(string: "0c0cOc"))
        XCTAssertFalse(try worksTimeProject.autofill.unwrap())
        XCTAssertTrue(try worksTimeProject.countDuration.unwrap())
        XCTAssertNil(worksTimeProject.isActive)
        XCTAssertFalse(try worksTimeProject.isInternal.unwrap())
        XCTAssertFalse(worksTimeProject.isLunch)
        XCTAssertTrue(worksTimeProject.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectNullLunchResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectResponse.simpleProjectNullLunchResponse)
        //Act
        let worksTimeProject = try? decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertNil(worksTimeProject)
    }
    
    func testParsingSimpleProjectMissingLunchKeyResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectResponse.simpleProjectMissingLunchKeyResponse)
        //Act
        let worksTimeProject = try? decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertNil(worksTimeProject)
    }
    
    func testParsingSimpleProjectNullWorkTimesAllowsTaskResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectResponse.simpleProjectNullWorkTimesAllowsTaskResponse)
        //Act
        let worksTimeProject = try? decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertNil(worksTimeProject)
    }
    
    func testParsingSimpleProjectMissingWorkTimesAllowsTaskKeyResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectResponse.simpleProjectMissingWorkTimesAllowsTaskKeyResponse)
        //Act
        let worksTimeProject = try? decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertNil(worksTimeProject)
    }
}
