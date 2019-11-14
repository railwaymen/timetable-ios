//
//  ProjectDecoderTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 21/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

// swiftlint:disable identifier_name
class ProjectDecoderTests: XCTestCase {
        
    private var decoder: JSONDecoder = JSONDecoder()
    
    func testParsingWorkTimesProjectResponse() throws {
        //Arrange
        let data = try self.json(from: WorkTimesProjectJSONResource.workTimesProjectResponse)
        //Act
        let project = try self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(project.identifier, 3)
        XCTAssertEqual(project.name, "Lorem ipsum")
        XCTAssertEqual(project.color, UIColor(hexString: "fe0404"))
        XCTAssertNil(project.autofill)
        XCTAssertNil(project.countDuration)
        XCTAssertNil(project.isActive)
        XCTAssertNil(project.isInternal)
        XCTAssertFalse(project.isLunch)
        XCTAssertTrue(project.workTimesAllowsTask)
    }
    
    func testParsingWorkTimesProjectNullColorResponse() throws {
        //Arrange
        let data = try self.json(from: WorkTimesProjectJSONResource.workTimesProjectNullColorResponse)
        //Act
        let project = try self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(project.identifier, 3)
        XCTAssertEqual(project.name, "Lorem ipsum")
        XCTAssertNil(project.color)
        XCTAssertNil(project.autofill)
        XCTAssertNil(project.countDuration)
        XCTAssertNil(project.isActive)
        XCTAssertNil(project.isInternal)
        XCTAssertFalse(project.isLunch)
        XCTAssertTrue(project.workTimesAllowsTask)
    }
    
    func testParsingWorkTimesProjectMissingColorKeyResponse() throws {
        //Arrange
        let data = try self.json(from: WorkTimesProjectJSONResource.workTimesProjectMissingColorKeyResponse)
        //Act
        let project = try self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(project.identifier, 3)
        XCTAssertEqual(project.name, "Lorem ipsum")
        XCTAssertNil(project.color)
        XCTAssertNil(project.autofill)
        XCTAssertNil(project.countDuration)
        XCTAssertNil(project.isActive)
        XCTAssertNil(project.isInternal)
        XCTAssertFalse(project.isLunch)
        XCTAssertTrue(project.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectFullResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        //Act
        let project = try self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(project.identifier, 11)
        XCTAssertEqual(project.name, "asdsa")
        XCTAssertEqual(project.color, UIColor(hexString: "0c0cOc"))
        XCTAssertFalse(try project.autofill.unwrap())
        XCTAssertTrue(try project.countDuration.unwrap())
        XCTAssertTrue(try project.isActive.unwrap())
        XCTAssertFalse(try project.isInternal.unwrap())
        XCTAssertFalse(project.isLunch)
        XCTAssertTrue(project.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectNullColorResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectNullColorResponse)
        //Act
        let project = try self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(project.identifier, 11)
        XCTAssertEqual(project.name, "asdsa")
        XCTAssertNil(project.color)
        XCTAssertFalse(try project.autofill.unwrap())
        XCTAssertTrue(try project.countDuration.unwrap())
        XCTAssertTrue(try project.isActive.unwrap())
        XCTAssertFalse(try project.isInternal.unwrap())
        XCTAssertFalse(project.isLunch)
        XCTAssertTrue(project.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectMissingColorKeyResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectMissingColorKeyResponse)
        //Act
        let project = try self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(project.identifier, 11)
        XCTAssertEqual(project.name, "asdsa")
        XCTAssertNil(project.color)
        XCTAssertFalse(try project.autofill.unwrap())
        XCTAssertTrue(try project.countDuration.unwrap())
        XCTAssertTrue(try project.isActive.unwrap())
        XCTAssertFalse(try project.isInternal.unwrap())
        XCTAssertFalse(project.isLunch)
        XCTAssertTrue(project.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectNullAutofillResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectNullAutofillResponse)
        //Act
        let project = try self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(project.identifier, 11)
        XCTAssertEqual(project.name, "asdsa")
        XCTAssertEqual(project.color, UIColor(hexString: "0c0cOc"))
        XCTAssertNil(project.autofill)
        XCTAssertTrue(try project.countDuration.unwrap())
        XCTAssertTrue(try project.isActive.unwrap())
        XCTAssertFalse(try project.isInternal.unwrap())
        XCTAssertFalse(project.isLunch)
        XCTAssertTrue(project.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectMissingAutofillKeyResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectMissingAutofillKeyResponse)
        //Act
        let project = try self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(project.identifier, 11)
        XCTAssertEqual(project.name, "asdsa")
        XCTAssertEqual(project.color, UIColor(hexString: "0c0cOc"))
        XCTAssertNil(project.autofill)
        XCTAssertTrue(try project.countDuration.unwrap())
        XCTAssertTrue(try project.isActive.unwrap())
        XCTAssertFalse(try project.isInternal.unwrap())
        XCTAssertFalse(project.isLunch)
        XCTAssertTrue(project.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectNullInternalResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectNullInternalResponse)
        //Act
        let project = try self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(project.identifier, 11)
        XCTAssertEqual(project.name, "asdsa")
        XCTAssertEqual(project.color, UIColor(hexString: "0c0cOc"))
        XCTAssertFalse(try project.autofill.unwrap())
        XCTAssertTrue(try project.countDuration.unwrap())
        XCTAssertTrue(try project.isActive.unwrap())
        XCTAssertNil(project.isInternal)
        XCTAssertFalse(project.isLunch)
        XCTAssertTrue(project.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectMissingInternalKeyResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectMissingInternalKeyResponse)
        //Act
        let project = try self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(project.identifier, 11)
        XCTAssertEqual(project.name, "asdsa")
        XCTAssertEqual(project.color, UIColor(hexString: "0c0cOc"))
        XCTAssertFalse(try project.autofill.unwrap())
        XCTAssertTrue(try project.countDuration.unwrap())
        XCTAssertTrue(try project.isActive.unwrap())
        XCTAssertNil(project.isInternal)
        XCTAssertFalse(project.isLunch)
        XCTAssertTrue(project.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectNullCountDurationResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectNullCountDurationResponse)
        //Act
        let project = try self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(project.identifier, 11)
        XCTAssertEqual(project.name, "asdsa")
        XCTAssertEqual(project.color, UIColor(hexString: "0c0cOc"))
        XCTAssertFalse(try project.autofill.unwrap())
        XCTAssertNil(project.countDuration)
        XCTAssertTrue(try project.isActive.unwrap())
        XCTAssertFalse(try project.isInternal.unwrap())
        XCTAssertFalse(project.isLunch)
        XCTAssertTrue(project.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectMissingCountDurationKeyResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectMissingCountDurationKeyResponse)
        //Act
        let project = try self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(project.identifier, 11)
        XCTAssertEqual(project.name, "asdsa")
        XCTAssertEqual(project.color, UIColor(hexString: "0c0cOc"))
        XCTAssertFalse(try project.autofill.unwrap())
        XCTAssertNil(project.countDuration)
        XCTAssertTrue(try project.isActive.unwrap())
        XCTAssertFalse(try project.isInternal.unwrap())
        XCTAssertFalse(project.isLunch)
        XCTAssertTrue(project.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectNullActiveResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectNullActiveResponse)
        //Act
        let project = try self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(project.identifier, 11)
        XCTAssertEqual(project.name, "asdsa")
        XCTAssertEqual(project.color, UIColor(hexString: "0c0cOc"))
        XCTAssertFalse(try project.autofill.unwrap())
        XCTAssertTrue(try project.countDuration.unwrap())
        XCTAssertNil(project.isActive)
        XCTAssertFalse(try project.isInternal.unwrap())
        XCTAssertFalse(project.isLunch)
        XCTAssertTrue(project.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectMissingActiveKeyResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectMissingActiveKeyResponse)
        //Act
        let project = try self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(project.identifier, 11)
        XCTAssertEqual(project.name, "asdsa")
        XCTAssertEqual(project.color, UIColor(hexString: "0c0cOc"))
        XCTAssertFalse(try project.autofill.unwrap())
        XCTAssertTrue(try project.countDuration.unwrap())
        XCTAssertNil(project.isActive)
        XCTAssertFalse(try project.isInternal.unwrap())
        XCTAssertFalse(project.isLunch)
        XCTAssertTrue(project.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectNullLunchResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectNullLunchResponse)
        //Act
        let project = try? self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertNil(project)
    }
    
    func testParsingSimpleProjectMissingLunchKeyResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectMissingLunchKeyResponse)
        //Act
        let project = try? self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertNil(project)
    }
    
    func testParsingSimpleProjectNullWorkTimesAllowsTaskResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectNullWorkTimesAllowsTaskResponse)
        //Act
        let project = try? self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertNil(project)
    }
    
    func testParsingSimpleProjectMissingWorkTimesAllowsTaskKeyResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectMissingWorkTimesAllowsTaskKeyResponse)
        //Act
        let project = try? self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertNil(project)
    }
}
// swiftlint:enable identifier_name
