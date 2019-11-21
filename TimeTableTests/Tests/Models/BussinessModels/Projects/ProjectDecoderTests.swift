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
        let sut = try self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 3)
        XCTAssertEqual(sut.name, "Lorem ipsum")
        XCTAssertEqual(sut.color, UIColor(hexString: "fe0404"))
        XCTAssertNil(sut.autofill)
        XCTAssertNil(sut.countDuration)
        XCTAssertNil(sut.isActive)
        XCTAssertNil(sut.isInternal)
        XCTAssertFalse(sut.isLunch)
        XCTAssertTrue(sut.workTimesAllowsTask)
    }
    
    func testParsingWorkTimesProjectNullColorResponse() throws {
        //Arrange
        let data = try self.json(from: WorkTimesProjectJSONResource.workTimesProjectNullColorResponse)
        //Act
        let sut = try self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 3)
        XCTAssertEqual(sut.name, "Lorem ipsum")
        XCTAssertNil(sut.color)
        XCTAssertNil(sut.autofill)
        XCTAssertNil(sut.countDuration)
        XCTAssertNil(sut.isActive)
        XCTAssertNil(sut.isInternal)
        XCTAssertFalse(sut.isLunch)
        XCTAssertTrue(sut.workTimesAllowsTask)
    }
    
    func testParsingWorkTimesProjectMissingColorKeyResponse() throws {
        //Arrange
        let data = try self.json(from: WorkTimesProjectJSONResource.workTimesProjectMissingColorKeyResponse)
        //Act
        let sut = try self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 3)
        XCTAssertEqual(sut.name, "Lorem ipsum")
        XCTAssertNil(sut.color)
        XCTAssertNil(sut.autofill)
        XCTAssertNil(sut.countDuration)
        XCTAssertNil(sut.isActive)
        XCTAssertNil(sut.isInternal)
        XCTAssertFalse(sut.isLunch)
        XCTAssertTrue(sut.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectFullResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        //Act
        let sut = try self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 11)
        XCTAssertEqual(sut.name, "asdsa")
        XCTAssertEqual(sut.color, UIColor(hexString: "0c0cOc"))
        XCTAssertFalse(try sut.autofill.unwrap())
        XCTAssertTrue(try sut.countDuration.unwrap())
        XCTAssertTrue(try sut.isActive.unwrap())
        XCTAssertFalse(try sut.isInternal.unwrap())
        XCTAssertFalse(sut.isLunch)
        XCTAssertTrue(sut.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectNullColorResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectNullColorResponse)
        //Act
        let sut = try self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 11)
        XCTAssertEqual(sut.name, "asdsa")
        XCTAssertNil(sut.color)
        XCTAssertFalse(try sut.autofill.unwrap())
        XCTAssertTrue(try sut.countDuration.unwrap())
        XCTAssertTrue(try sut.isActive.unwrap())
        XCTAssertFalse(try sut.isInternal.unwrap())
        XCTAssertFalse(sut.isLunch)
        XCTAssertTrue(sut.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectMissingColorKeyResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectMissingColorKeyResponse)
        //Act
        let sut = try self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 11)
        XCTAssertEqual(sut.name, "asdsa")
        XCTAssertNil(sut.color)
        XCTAssertFalse(try sut.autofill.unwrap())
        XCTAssertTrue(try sut.countDuration.unwrap())
        XCTAssertTrue(try sut.isActive.unwrap())
        XCTAssertFalse(try sut.isInternal.unwrap())
        XCTAssertFalse(sut.isLunch)
        XCTAssertTrue(sut.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectNullAutofillResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectNullAutofillResponse)
        //Act
        let sut = try self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 11)
        XCTAssertEqual(sut.name, "asdsa")
        XCTAssertEqual(sut.color, UIColor(hexString: "0c0cOc"))
        XCTAssertNil(sut.autofill)
        XCTAssertTrue(try sut.countDuration.unwrap())
        XCTAssertTrue(try sut.isActive.unwrap())
        XCTAssertFalse(try sut.isInternal.unwrap())
        XCTAssertFalse(sut.isLunch)
        XCTAssertTrue(sut.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectMissingAutofillKeyResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectMissingAutofillKeyResponse)
        //Act
        let sut = try self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 11)
        XCTAssertEqual(sut.name, "asdsa")
        XCTAssertEqual(sut.color, UIColor(hexString: "0c0cOc"))
        XCTAssertNil(sut.autofill)
        XCTAssertTrue(try sut.countDuration.unwrap())
        XCTAssertTrue(try sut.isActive.unwrap())
        XCTAssertFalse(try sut.isInternal.unwrap())
        XCTAssertFalse(sut.isLunch)
        XCTAssertTrue(sut.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectNullInternalResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectNullInternalResponse)
        //Act
        let sut = try self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 11)
        XCTAssertEqual(sut.name, "asdsa")
        XCTAssertEqual(sut.color, UIColor(hexString: "0c0cOc"))
        XCTAssertFalse(try sut.autofill.unwrap())
        XCTAssertTrue(try sut.countDuration.unwrap())
        XCTAssertTrue(try sut.isActive.unwrap())
        XCTAssertNil(sut.isInternal)
        XCTAssertFalse(sut.isLunch)
        XCTAssertTrue(sut.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectMissingInternalKeyResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectMissingInternalKeyResponse)
        //Act
        let sut = try self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 11)
        XCTAssertEqual(sut.name, "asdsa")
        XCTAssertEqual(sut.color, UIColor(hexString: "0c0cOc"))
        XCTAssertFalse(try sut.autofill.unwrap())
        XCTAssertTrue(try sut.countDuration.unwrap())
        XCTAssertTrue(try sut.isActive.unwrap())
        XCTAssertNil(sut.isInternal)
        XCTAssertFalse(sut.isLunch)
        XCTAssertTrue(sut.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectNullCountDurationResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectNullCountDurationResponse)
        //Act
        let sut = try self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 11)
        XCTAssertEqual(sut.name, "asdsa")
        XCTAssertEqual(sut.color, UIColor(hexString: "0c0cOc"))
        XCTAssertFalse(try sut.autofill.unwrap())
        XCTAssertNil(sut.countDuration)
        XCTAssertTrue(try sut.isActive.unwrap())
        XCTAssertFalse(try sut.isInternal.unwrap())
        XCTAssertFalse(sut.isLunch)
        XCTAssertTrue(sut.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectMissingCountDurationKeyResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectMissingCountDurationKeyResponse)
        //Act
        let sut = try self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 11)
        XCTAssertEqual(sut.name, "asdsa")
        XCTAssertEqual(sut.color, UIColor(hexString: "0c0cOc"))
        XCTAssertFalse(try sut.autofill.unwrap())
        XCTAssertNil(sut.countDuration)
        XCTAssertTrue(try sut.isActive.unwrap())
        XCTAssertFalse(try sut.isInternal.unwrap())
        XCTAssertFalse(sut.isLunch)
        XCTAssertTrue(sut.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectNullActiveResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectNullActiveResponse)
        //Act
        let sut = try self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 11)
        XCTAssertEqual(sut.name, "asdsa")
        XCTAssertEqual(sut.color, UIColor(hexString: "0c0cOc"))
        XCTAssertFalse(try sut.autofill.unwrap())
        XCTAssertTrue(try sut.countDuration.unwrap())
        XCTAssertNil(sut.isActive)
        XCTAssertFalse(try sut.isInternal.unwrap())
        XCTAssertFalse(sut.isLunch)
        XCTAssertTrue(sut.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectMissingActiveKeyResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectMissingActiveKeyResponse)
        //Act
        let sut = try self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 11)
        XCTAssertEqual(sut.name, "asdsa")
        XCTAssertEqual(sut.color, UIColor(hexString: "0c0cOc"))
        XCTAssertFalse(try sut.autofill.unwrap())
        XCTAssertTrue(try sut.countDuration.unwrap())
        XCTAssertNil(sut.isActive)
        XCTAssertFalse(try sut.isInternal.unwrap())
        XCTAssertFalse(sut.isLunch)
        XCTAssertTrue(sut.workTimesAllowsTask)
    }
    
    func testParsingSimpleProjectNullLunchResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectNullLunchResponse)
        //Act
        let sut = try? self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertNil(sut)
    }
    
    func testParsingSimpleProjectMissingLunchKeyResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectMissingLunchKeyResponse)
        //Act
        let sut = try? self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertNil(sut)
    }
    
    func testParsingSimpleProjectNullWorkTimesAllowsTaskResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectNullWorkTimesAllowsTaskResponse)
        //Act
        let sut = try? self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertNil(sut)
    }
    
    func testParsingSimpleProjectMissingWorkTimesAllowsTaskKeyResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectMissingWorkTimesAllowsTaskKeyResponse)
        //Act
        let sut = try? self.decoder.decode(ProjectDecoder.self, from: data)
        //Assert
        XCTAssertNil(sut)
    }
}
// swiftlint:enable identifier_name
