//
//  ApiValidationErrorsTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 16/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ApiValidationErrorsTests: XCTestCase {}

// MARK: - Decodable
extension ApiValidationErrorsTests {
    func testEmptyErrosKeysResponse() throws {
        //Arrange
        let data = try self.json(from: ApiValidationJSONResource.emptyErrosKeysResponse)
        //Act
        let sut = try self.decoder.decode(ApiValidationErrors.self, from: data)
        //Assert
        XCTAssertEqual(sut.errors.keys.count, 0)
    }
    
    func testBaseErrorKeyResponse() throws {
        //Arrange
        let data = try self.json(from: ApiValidationJSONResource.baseErrorKeyResponse)
        //Act
        let sut = try self.decoder.decode(ApiValidationErrors.self, from: data)
        //Assert
        XCTAssertEqual(sut.errors.keys.count, 2)
        XCTAssertEqual(sut.errors.keys[safeIndex: 0]?.error, "overlap")
        XCTAssertEqual(sut.errors.keys[safeIndex: 0]?.errorKey, .overlap)
        XCTAssertEqual(sut.errors.keys[safeIndex: 1]?.error, "Error")
    }
    
    func testStartAtErrorKeyResponse() throws {
        //Arrange
        let data = try self.json(from: ApiValidationJSONResource.startAtErrorKeyResponse)
        //Act
        let sut = try self.decoder.decode(ApiValidationErrors.self, from: data)
        //Assert
        XCTAssertEqual(sut.errors.keys.count, 2)
        XCTAssertEqual(sut.errors.keys[safeIndex: 0]?.error, "Invalid parameters has been send")
        XCTAssertEqual(sut.errors.keys[safeIndex: 1]?.error, "Error")
    }
    
    func testEndsAtErrorKeyResponse() throws {
        //Arrange
        let data = try self.json(from: ApiValidationJSONResource.endsAtErrorKeyResponse)
        //Act
        let sut = try self.decoder.decode(ApiValidationErrors.self, from: data)
        //Assert
        XCTAssertEqual(sut.errors.keys.count, 2)
        XCTAssertEqual(sut.errors.keys[safeIndex: 0]?.error, "Invalid parameters has been send")
        XCTAssertEqual(sut.errors.keys[safeIndex: 1]?.error, "Error")
    }
    
    func testDurationErrorKeyResponse() throws {
        //Arrange
        let data = try self.json(from: ApiValidationJSONResource.durationErrorKeyResponse)
        //Act
        let sut = try self.decoder.decode(ApiValidationErrors.self, from: data)
        //Assert
        XCTAssertEqual(sut.errors.keys.count, 2)
        XCTAssertEqual(sut.errors.keys[safeIndex: 0]?.error, "Invalid parameters has been send")
        XCTAssertEqual(sut.errors.keys[safeIndex: 1]?.error, "Error")
    }
    
    func testInvalidEmailOrPasswordErrorKeyResponse() throws {
        //Arrange
        let data = try self.json(from: ApiValidationJSONResource.invalidEmailOrPasswordErrorKeyResponse)
        //Act
        let sut = try self.decoder.decode(ApiValidationErrors.self, from: data)
        //Assert
        XCTAssertEqual(sut.errors.keys.count, 2)
        XCTAssertEqual(sut.errors.keys[safeIndex: 0]?.error, "Invalid parameters has been send")
        XCTAssertEqual(sut.errors.keys[safeIndex: 1]?.error, "Error")
    }
}
