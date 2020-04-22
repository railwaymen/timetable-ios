//
//  VacationTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 23/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class VacationTests: XCTestCase {}

// MARK: - Decodable
extension VacationTests {
    func testDecodingVacation_plannedType() throws {
        //Arrange
        let startDate = try self.buildStartDate()
        let endDate = try self.buildEndDate()
        let data = try self.json(from: VacationJSONResource.vacationPlannedTypeResponse)
        //Act
        let sut = try self.decoder.decode(VacationResponse.Vacation.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 11)
        XCTAssertEqual(sut.startDate, startDate)
        XCTAssertEqual(sut.endDate, endDate)
        XCTAssertEqual(sut.type, .planned)
        XCTAssertEqual(sut.status, .accepted)
        XCTAssertEqual(sut.fullName, "user 1")
        XCTAssertEqual(sut.businessDaysCount, 2)
    }
    
    func testDecodingVacation_requestedType() throws {
        //Arrange
        let startDate = try self.buildStartDate()
        let endDate = try self.buildEndDate()
        let data = try self.json(from: VacationJSONResource.vacationRequestedTypeResponse)
        //Act
        let sut = try self.decoder.decode(VacationResponse.Vacation.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 11)
        XCTAssertEqual(sut.startDate, startDate)
        XCTAssertEqual(sut.endDate, endDate)
        XCTAssertEqual(sut.type, .requested)
        XCTAssertEqual(sut.status, .accepted)
        XCTAssertEqual(sut.fullName, "user 1")
        XCTAssertEqual(sut.businessDaysCount, 2)
    }
    
    func testDecodingVacation_compassionateType() throws {
        //Arrange
        let startDate = try self.buildStartDate()
        let endDate = try self.buildEndDate()
        let data = try self.json(from: VacationJSONResource.vacationCompassionateTypeResponse)
        //Act
        let sut = try self.decoder.decode(VacationResponse.Vacation.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 11)
        XCTAssertEqual(sut.startDate, startDate)
        XCTAssertEqual(sut.endDate, endDate)
        XCTAssertEqual(sut.type, .compassionate)
        XCTAssertEqual(sut.status, .accepted)
        XCTAssertEqual(sut.fullName, "user 1")
        XCTAssertEqual(sut.businessDaysCount, 2)
    }
    
    func testDecodingVacation_othersType() throws {
        //Arrange
        let startDate = try self.buildStartDate()
        let endDate = try self.buildEndDate()
        let data = try self.json(from: VacationJSONResource.vacationOthersTypeResponse)
        //Act
        let sut = try self.decoder.decode(VacationResponse.Vacation.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 11)
        XCTAssertEqual(sut.startDate, startDate)
        XCTAssertEqual(sut.endDate, endDate)
        XCTAssertEqual(sut.type, .others)
        XCTAssertEqual(sut.status, .accepted)
        XCTAssertEqual(sut.fullName, "user 1")
        XCTAssertEqual(sut.businessDaysCount, 2)
    }
    
    func testDecodingVacation_unconfirmedStatus() throws {
        //Arrange
        let startDate = try self.buildStartDate()
        let endDate = try self.buildEndDate()
        let data = try self.json(from: VacationJSONResource.vacationUnconfirmedStatusResponse)
        //Act
        let sut = try self.decoder.decode(VacationResponse.Vacation.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 11)
        XCTAssertEqual(sut.startDate, startDate)
        XCTAssertEqual(sut.endDate, endDate)
        XCTAssertEqual(sut.type, .planned)
        XCTAssertEqual(sut.status, .unconfirmed)
        XCTAssertEqual(sut.fullName, "user 1")
        XCTAssertEqual(sut.businessDaysCount, 2)
    }
    
    func testDecodingVacation_declinedStatus() throws {
        //Arrange
        let startDate = try self.buildStartDate()
        let endDate = try self.buildEndDate()
        let data = try self.json(from: VacationJSONResource.vacationDeclinedStatusResponse)
        //Act
        let sut = try self.decoder.decode(VacationResponse.Vacation.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 11)
        XCTAssertEqual(sut.startDate, startDate)
        XCTAssertEqual(sut.endDate, endDate)
        XCTAssertEqual(sut.type, .planned)
        XCTAssertEqual(sut.status, .declined)
        XCTAssertEqual(sut.fullName, "user 1")
        XCTAssertEqual(sut.businessDaysCount, 2)
    }
    
    func testDecodingVacation_approvedStatus() throws {
        //Arrange
        let startDate = try self.buildStartDate()
        let endDate = try self.buildEndDate()
        let data = try self.json(from: VacationJSONResource.vacationApprovedStatusResponse)
        //Act
        let sut = try self.decoder.decode(VacationResponse.Vacation.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 11)
        XCTAssertEqual(sut.startDate, startDate)
        XCTAssertEqual(sut.endDate, endDate)
        XCTAssertEqual(sut.type, .planned)
        XCTAssertEqual(sut.status, .approved)
        XCTAssertEqual(sut.fullName, "user 1")
        XCTAssertEqual(sut.businessDaysCount, 2)
    }
    
    func testDecodingVacation_acceptedStatus() throws {
        //Arrange
        let startDate = try self.buildStartDate()
        let endDate = try self.buildEndDate()
        let data = try self.json(from: VacationJSONResource.vacationAcceptedStatusResponse)
        //Act
        let sut = try self.decoder.decode(VacationResponse.Vacation.self, from: data)
        //Assert
        XCTAssertEqual(sut.id, 11)
        XCTAssertEqual(sut.startDate, startDate)
        XCTAssertEqual(sut.endDate, endDate)
        XCTAssertEqual(sut.type, .planned)
        XCTAssertEqual(sut.status, .accepted)
        XCTAssertEqual(sut.fullName, "user 1")
        XCTAssertEqual(sut.businessDaysCount, 2)
    }
}

// MARK: - Private
extension VacationTests {
    private func buildStartDate() throws -> Date {
        return try self.buildDate(year: 2020, month: 3, day: 4)
    }
    
    private func buildEndDate() throws -> Date {
        return try self.buildDate(year: 2020, month: 3, day: 5)
    }
}
