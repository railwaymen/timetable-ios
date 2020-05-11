//
//  BasicErrorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 11/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class BasicErrorTests: XCTestCase {}

// MARK: - Decodable
extension BasicErrorTests {
    func testDecoding() throws {
        //Arrange
        let data = try self.json(from: BasicErrorResource.basicErrorResponse)
        //Act
        let sut = try self.decoder.decode(BasicError<RegisterRemoteWorkValidationError.StartsAtErrorKey>.self, from: data)
        //Assert
        XCTAssertEqual(sut.error, RegisterRemoteWorkValidationError.StartsAtErrorKey.overlap)
    }
}
