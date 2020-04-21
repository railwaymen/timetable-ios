//
//  MatchingFullTimeEncoderTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 04/02/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
import Restler
@testable import TimeTable

class MatchingFullTimeEncoderTests: XCTestCase {
    private var queryEncoder: Restler.QueryEncoder {
        Restler.QueryEncoder(jsonEncoder: self.encoder)
    }
}

// MARK: - Encodable
extension MatchingFullTimeEncoderTests {
    func testEncoding_fullModel() throws {
        //Arrange
        let date = try self.buildDate(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let sut = MatchingFullTimeEncoder(date: date, userID: 1)
        //Act
        let queryItems = try self.queryEncoder.encode(sut)
        //Assert
        XCTAssertEqual(queryItems.count, 2)
        XCTAssert(queryItems.contains(.init(name: "date", value: "2018-01-17")))
        XCTAssert(queryItems.contains(.init(name: "user_id", value: "1")))
    }
}
