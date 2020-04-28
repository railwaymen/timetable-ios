//
//  AccountingPeriodsResponseTests.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 28/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class AccountingPeriodsResponseTests: XCTestCase {}

// MARK: - Decoding
extension AccountingPeriodsResponseTests {
    func testDecoding_fullModel() throws {
        //Arrange
        let data = try self.json(from: AccountingPeriodsJSONResource.accountingPeriodsResponseFullResponse)
        //Act
        let sut = try self.decoder.decode(AccountingPeriodsResponse.self, from: data)
        //Assert
        XCTAssertEqual(sut.totalPages, 20)
        XCTAssertEqual(sut.records.count, 1)
    }
}
