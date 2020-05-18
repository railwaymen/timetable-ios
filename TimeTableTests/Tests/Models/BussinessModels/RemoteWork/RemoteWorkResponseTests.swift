//
//  RemoteWorkResponseTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 06/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class RemoteWorkResponseTests: XCTestCase {}

// MARK: - Decodable
extension RemoteWorkResponseTests {
    func testDecoding_fullModel() throws {
        //Arrange
        let data = try self.json(from: RemoteWorkResponseJSONResource.remoteWorkResponseFullModel)
        //Act
        let sut = try self.decoder.decode(RemoteWorkResponse.self, from: data)
        //Assert
        XCTAssertEqual(sut.totalPages, 20)
        XCTAssertEqual(sut.records.count, 1)
    }
    
    func testDecoding_emptyRecordsArray() throws {
        //Arrange
        let data = try self.json(from: RemoteWorkResponseJSONResource.remoteWorkResponseRecordsEmptyArray)
        //Act
        let sut = try self.decoder.decode(RemoteWorkResponse.self, from: data)
        //Assert
        XCTAssertEqual(sut.totalPages, 20)
        XCTAssertEqual(sut.records.count, 0)
    }
}
