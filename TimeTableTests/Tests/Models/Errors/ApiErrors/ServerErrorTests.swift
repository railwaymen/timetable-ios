//
//  ServerErrorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 14/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
import Restler
@testable import TimeTable

class ServerErrorTests: XCTestCase {}

// MARK: - Decodable
extension ServerErrorTests {
    func testDecoding_fullModel() throws {
        //Arrange
        let data = try self.json(from: ServerErrorJSONResource.serverErrorFullModel)
        //Act
        let sut = try self.decoder.decode(ServerError.self, from: data)
        //Assert
        XCTAssertEqual(sut.error, "error_key")
        XCTAssertEqual(sut.status, 502)
    }
}
