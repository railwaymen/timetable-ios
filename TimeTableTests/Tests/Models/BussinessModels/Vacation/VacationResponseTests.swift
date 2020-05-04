//
//  VacationResponseTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 23/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class VacationResponseTests: XCTestCase {}

// MARK: - Decodable
extension VacationResponseTests {
    func testDecoding_vacationResponse() throws {
        //Arrange
        let data = try self.json(from: VacationResponseJSONResource.vacationResponseTypeResponse)
        //Act
        let sut = try self.decoder.decode(VacationResponse.self, from: data)
        //Assert
        XCTAssertEqual(sut.availableVacationDays, 25)
        XCTAssertNotNil(sut.usedVacationDays)
        XCTAssertEqual(sut.records.count, 3)
        let firstRecord = try XCTUnwrap(sut.records[safeIndex: 0])
        let secondRecord = try XCTUnwrap(sut.records[safeIndex: 1])
        let thirdRecord = try XCTUnwrap(sut.records[safeIndex: 2])
        XCTAssert(firstRecord.startDate > secondRecord.startDate)
        XCTAssert(secondRecord.startDate > thirdRecord.startDate)
    }
}
