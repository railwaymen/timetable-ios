//
//  VacationParametersTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 23/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
import Restler
@testable import TimeTable

class VacationParametersTests: XCTestCase {
    private var queryEncoder: Restler.QueryEncoder {
        Restler.QueryEncoder(jsonEncoder: self.encoder)
    }
}

extension VacationParametersTests {
    func testEncoding() throws {
        //Arrange
        let sut = VacationParameters(year: 2020)
        //Act
        let queryItems = try self.queryEncoder.encode(sut)
        //Assert
        XCTAssertEqual(queryItems.count, 1)
        XCTAssert(queryItems.contains(.init(name: "year", value: "\(2020)")))
    }
}
