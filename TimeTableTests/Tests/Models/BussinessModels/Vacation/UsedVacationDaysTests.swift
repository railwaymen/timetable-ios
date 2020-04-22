//
//  UsedVacationDaysTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 23/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class UsedVacationDaysTests: XCTestCase {}

// MARK: - Decodable
extension UsedVacationDaysTests {
    func testDecoding_usedVacationDays() throws {
        //Arrange
        let data = try self.json(from: UsedVacationDaysJSONResource.usedVacationDaysResponse)
        //Act
        let sut = try self.decoder.decode(VacationResponse.UsedVacationDays.self, from: data)
        //Assert
        XCTAssertEqual(sut.planned, 3)
        XCTAssertEqual(sut.requested, 1)
        XCTAssertEqual(sut.compassionate, 0)
        XCTAssertEqual(sut.paternity, 2)
        XCTAssertEqual(sut.parental, 5)
        XCTAssertEqual(sut.upbringing, 6)
        XCTAssertEqual(sut.unpaid, 8)
        XCTAssertEqual(sut.rehabilitation, 7)
        XCTAssertEqual(sut.illness, 10)
        XCTAssertEqual(sut.care, 11)
    }
}
