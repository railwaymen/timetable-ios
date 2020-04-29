//
//  AccountingPeriodsParametersTests.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 28/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
import Restler
@testable import TimeTable

class AccountingPeriodsParametersTests: XCTestCase {
    private var queryEncoder: Restler.QueryEncoder {
        .init(jsonEncoder: self.encoder)
    }
}

// MARK: - Query Encoding
extension AccountingPeriodsParametersTests {
    func testQueryEncoding_fullModel() throws {
        //Arrange
        let sut = AccountingPeriodsParameters(page: 7, recordsPerPage: 12)
        //Act
        let items = try self.queryEncoder.encode(sut)
        //Assert
        XCTAssertEqual(items.count, 2)
        XCTAssert(items.contains(.init(name: "page", value: "7")))
        XCTAssert(items.contains(.init(name: "per_page", value: "12")))
    }
}
