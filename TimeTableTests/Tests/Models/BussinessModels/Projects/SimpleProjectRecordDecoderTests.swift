//
//  SimpleProjectRecordDecoderTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 21/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

// swiftlint:disable identifier_name
class SimpleProjectRecordDecoderTests: XCTestCase {}

// MARK: - Decodable
extension SimpleProjectRecordDecoderTests {
    func testDecoding_workTimesProjectResponse() throws {
        //Arrange
        let data = try self.json(from: WorkTimesProjectJSONResource.workTimesProjectResponse)
        //Act
        let sut = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: data)
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
        XCTAssertFalse(sut.isTaggable)
    }
    
    func testDecoding_workTimesProjectNullColorResponse() throws {
        //Arrange
        let data = try self.json(from: WorkTimesProjectJSONResource.workTimesProjectNullColorResponse)
        //Act
        let sut = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: data)
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
        XCTAssertTrue(sut.isTaggable)
    }
    
    func testDecoding_workTimesProjectMissingColorKeyResponse() throws {
        //Arrange
        let data = try self.json(from: WorkTimesProjectJSONResource.workTimesProjectMissingColorKeyResponse)
        //Act
        let sut = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: data)
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
        XCTAssertTrue(sut.isTaggable)
    }
    
    func testDecoding_simpleProjectFullResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        //Act
        let sut = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 11)
        XCTAssertEqual(sut.name, "asdsa")
        XCTAssertEqual(sut.color, UIColor(hexString: "0c0cOc"))
        XCTAssertFalse(try XCTUnwrap(sut.autofill))
        XCTAssertTrue(try XCTUnwrap(sut.countDuration))
        XCTAssertTrue(try XCTUnwrap(sut.isActive))
        XCTAssertFalse(try XCTUnwrap(sut.isInternal))
        XCTAssertFalse(sut.isLunch)
        XCTAssertTrue(sut.workTimesAllowsTask)
        XCTAssertTrue(sut.isTaggable)
    }
    
    func testDecoding_simpleProjectNullColorResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectNullColorResponse)
        //Act
        let sut = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 11)
        XCTAssertEqual(sut.name, "asdsa")
        XCTAssertNil(sut.color)
        XCTAssertFalse(try XCTUnwrap(sut.autofill))
        XCTAssertTrue(try XCTUnwrap(sut.countDuration))
        XCTAssertTrue(try XCTUnwrap(sut.isActive))
        XCTAssertFalse(try XCTUnwrap(sut.isInternal))
        XCTAssertFalse(sut.isLunch)
        XCTAssertTrue(sut.workTimesAllowsTask)
        XCTAssertTrue(sut.isTaggable)
    }
    
    func testDecoding_simpleProjectMissingColorKeyResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectMissingColorKeyResponse)
        //Act
        let sut = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 11)
        XCTAssertEqual(sut.name, "asdsa")
        XCTAssertNil(sut.color)
        XCTAssertFalse(try XCTUnwrap(sut.autofill))
        XCTAssertTrue(try XCTUnwrap(sut.countDuration))
        XCTAssertTrue(try XCTUnwrap(sut.isActive))
        XCTAssertFalse(try XCTUnwrap(sut.isInternal))
        XCTAssertFalse(sut.isLunch)
        XCTAssertTrue(sut.workTimesAllowsTask)
        XCTAssertTrue(sut.isTaggable)
    }
    
    func testDecoding_simpleProjectNullAutofillResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectNullAutofillResponse)
        //Act
        let sut = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 11)
        XCTAssertEqual(sut.name, "asdsa")
        XCTAssertEqual(sut.color, UIColor(hexString: "0c0cOc"))
        XCTAssertNil(sut.autofill)
        XCTAssertTrue(try XCTUnwrap(sut.countDuration))
        XCTAssertTrue(try XCTUnwrap(sut.isActive))
        XCTAssertFalse(try XCTUnwrap(sut.isInternal))
        XCTAssertFalse(sut.isLunch)
        XCTAssertTrue(sut.workTimesAllowsTask)
        XCTAssertTrue(sut.isTaggable)
    }
    
    func testDecoding_simpleProjectMissingAutofillKeyResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectMissingAutofillKeyResponse)
        //Act
        let sut = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 11)
        XCTAssertEqual(sut.name, "asdsa")
        XCTAssertEqual(sut.color, UIColor(hexString: "0c0cOc"))
        XCTAssertNil(sut.autofill)
        XCTAssertTrue(try XCTUnwrap(sut.countDuration))
        XCTAssertTrue(try XCTUnwrap(sut.isActive))
        XCTAssertFalse(try XCTUnwrap(sut.isInternal))
        XCTAssertFalse(sut.isLunch)
        XCTAssertTrue(sut.workTimesAllowsTask)
        XCTAssertTrue(sut.isTaggable)
    }
    
    func testDecoding_simpleProjectNullInternalResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectNullInternalResponse)
        //Act
        let sut = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 11)
        XCTAssertEqual(sut.name, "asdsa")
        XCTAssertEqual(sut.color, UIColor(hexString: "0c0cOc"))
        XCTAssertFalse(try XCTUnwrap(sut.autofill))
        XCTAssertTrue(try XCTUnwrap(sut.countDuration))
        XCTAssertTrue(try XCTUnwrap(sut.isActive))
        XCTAssertNil(sut.isInternal)
        XCTAssertFalse(sut.isLunch)
        XCTAssertTrue(sut.workTimesAllowsTask)
        XCTAssertTrue(sut.isTaggable)
    }
    
    func testDecoding_simpleProjectMissingInternalKeyResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectMissingInternalKeyResponse)
        //Act
        let sut = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 11)
        XCTAssertEqual(sut.name, "asdsa")
        XCTAssertEqual(sut.color, UIColor(hexString: "0c0cOc"))
        XCTAssertFalse(try XCTUnwrap(sut.autofill))
        XCTAssertTrue(try XCTUnwrap(sut.countDuration))
        XCTAssertTrue(try XCTUnwrap(sut.isActive))
        XCTAssertNil(sut.isInternal)
        XCTAssertFalse(sut.isLunch)
        XCTAssertTrue(sut.workTimesAllowsTask)
        XCTAssertTrue(sut.isTaggable)
    }
    
    func testDecoding_simpleProjectNullCountDurationResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectNullCountDurationResponse)
        //Act
        let sut = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 11)
        XCTAssertEqual(sut.name, "asdsa")
        XCTAssertEqual(sut.color, UIColor(hexString: "0c0cOc"))
        XCTAssertFalse(try XCTUnwrap(sut.autofill))
        XCTAssertNil(sut.countDuration)
        XCTAssertTrue(try XCTUnwrap(sut.isActive))
        XCTAssertFalse(try XCTUnwrap(sut.isInternal))
        XCTAssertFalse(sut.isLunch)
        XCTAssertTrue(sut.workTimesAllowsTask)
        XCTAssertTrue(sut.isTaggable)
    }
    
    func testDecoding_simpleProjectMissingCountDurationKeyResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectMissingCountDurationKeyResponse)
        //Act
        let sut = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 11)
        XCTAssertEqual(sut.name, "asdsa")
        XCTAssertEqual(sut.color, UIColor(hexString: "0c0cOc"))
        XCTAssertFalse(try XCTUnwrap(sut.autofill))
        XCTAssertNil(sut.countDuration)
        XCTAssertTrue(try XCTUnwrap(sut.isActive))
        XCTAssertFalse(try XCTUnwrap(sut.isInternal))
        XCTAssertFalse(sut.isLunch)
        XCTAssertTrue(sut.workTimesAllowsTask)
        XCTAssertTrue(sut.isTaggable)
    }
    
    func testDecoding_simpleProjectNullActiveResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectNullActiveResponse)
        //Act
        let sut = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 11)
        XCTAssertEqual(sut.name, "asdsa")
        XCTAssertEqual(sut.color, UIColor(hexString: "0c0cOc"))
        XCTAssertFalse(try XCTUnwrap(sut.autofill))
        XCTAssertTrue(try XCTUnwrap(sut.countDuration))
        XCTAssertNil(sut.isActive)
        XCTAssertFalse(try XCTUnwrap(sut.isInternal))
        XCTAssertFalse(sut.isLunch)
        XCTAssertTrue(sut.workTimesAllowsTask)
        XCTAssertTrue(sut.isTaggable)
    }
    
    func testDecoding_simpleProjectMissingActiveKeyResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectMissingActiveKeyResponse)
        //Act
        let sut = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 11)
        XCTAssertEqual(sut.name, "asdsa")
        XCTAssertEqual(sut.color, UIColor(hexString: "0c0cOc"))
        XCTAssertFalse(try XCTUnwrap(sut.autofill))
        XCTAssertTrue(try XCTUnwrap(sut.countDuration))
        XCTAssertNil(sut.isActive)
        XCTAssertFalse(try XCTUnwrap(sut.isInternal))
        XCTAssertFalse(sut.isLunch)
        XCTAssertTrue(sut.workTimesAllowsTask)
        XCTAssertTrue(sut.isTaggable)
    }
    
    func testDecoding_simpleProjectIsTaggableTrueResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectWithIsTaggableTrueResponse)
        //Act
        let sut = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 11)
        XCTAssertEqual(sut.name, "asdsa")
        XCTAssertEqual(sut.color, UIColor(hexString: "0c0cOc"))
        XCTAssertFalse(try XCTUnwrap(sut.autofill))
        XCTAssertTrue(try XCTUnwrap(sut.countDuration))
        XCTAssertTrue(try XCTUnwrap(sut.isActive))
        XCTAssertFalse(try XCTUnwrap(sut.isInternal))
        XCTAssertFalse(sut.isLunch)
        XCTAssertTrue(sut.workTimesAllowsTask)
        XCTAssertTrue(sut.isTaggable)
    }
    
    func testDecoding_simpleProjectIsTaggableFalseResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectWithIsTaggableFalseResponse)
        //Act
        let sut = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.identifier, 11)
        XCTAssertEqual(sut.name, "asdsa")
        XCTAssertEqual(sut.color, UIColor(hexString: "0c0cOc"))
        XCTAssertFalse(try XCTUnwrap(sut.autofill))
        XCTAssertTrue(try XCTUnwrap(sut.countDuration))
        XCTAssertTrue(try XCTUnwrap(sut.isActive))
        XCTAssertFalse(try XCTUnwrap(sut.isInternal))
        XCTAssertFalse(sut.isLunch)
        XCTAssertTrue(sut.workTimesAllowsTask)
        XCTAssertFalse(sut.isTaggable)
    }
    
    func testDecoding_simpleProjectNullLunchResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectNullLunchResponse)
        //Act
        let sut = try? self.decoder.decode(SimpleProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertNil(sut)
    }
    
    func testDecoding_simpleProjectMissingLunchKeyResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectMissingLunchKeyResponse)
        //Act
        let sut = try? self.decoder.decode(SimpleProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertNil(sut)
    }
    
    func testDecoding_simpleProjectNullWorkTimesAllowsTaskResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectNullWorkTimesAllowsTaskResponse)
        //Act
        let sut = try? self.decoder.decode(SimpleProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertNil(sut)
    }
    
    func testDecoding_simpleProjectMissingWorkTimesAllowsTaskKeyResponse() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectMissingWorkTimesAllowsTaskKeyResponse)
        //Act
        let sut = try? self.decoder.decode(SimpleProjectRecordDecoder.self, from: data)
        //Assert
        XCTAssertNil(sut)
    }
}
// swiftlint:enable identifier_name
