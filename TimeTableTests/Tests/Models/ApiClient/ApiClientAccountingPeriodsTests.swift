//
//  ApiClientAccountingPeriodsTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 04/02/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ApiClientAccountingPeriodsTests: XCTestCase {
    private var restler: RestlerMock!
    private var accessService: AccessServiceMock!
    
    override func setUp() {
        super.setUp()
        self.restler = RestlerMock()
        self.accessService = AccessServiceMock()
    }
}

// MARK: - fetchAccountingPeriods(parameters:completion:)
extension ApiClientAccountingPeriodsTests {
    func testFetchAccountingPeriods_succeed() throws {
        //Arrange
        let sut = self.buildSUT()
        let data = try self.json(from: AccountingPeriodsJSONResource.accountingPeriodsResponseFullResponse)
        let decoder = try self.decoder.decode(AccountingPeriodsResponse.self, from: data)
        let parameters = AccountingPeriodsParameters(page: 1, recordsPerPage: 10)
        var completionResult: Result<AccountingPeriodsResponse, Error>?
        //Act
        sut.fetchAccountingPeriods(parameters: parameters) {
            completionResult = $0
        }
        try self.restler.getReturnValue.callCompletion(type: AccountingPeriodsResponse.self, result: .success(decoder))
        //Assert
        XCTAssertNoThrow(try XCTUnwrap(completionResult).get())
    }
    
    func testFetchAccountingPeriods_failed() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = "Some error"
        let parameters = AccountingPeriodsParameters(page: 1, recordsPerPage: 10)
        var completionResult: Result<AccountingPeriodsResponse, Error>?
        //Act
        sut.fetchAccountingPeriods(parameters: parameters) {
            completionResult = $0
        }
        try self.restler.getReturnValue.callCompletion(type: AccountingPeriodsResponse.self, result: .failure(error))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
}

// MARK: - fetchMatchingFullTime(parameters:completion:)
extension ApiClientAccountingPeriodsTests {
    func testFetchMatchingFullTime_succeed() throws {
        //Arrange
        let sut = self.buildSUT()
        let data = try self.json(from: MatchingFullTimeJSONResource.matchingFullTimeFullResponse)
        let decoder = try self.decoder.decode(MatchingFullTimeDecoder.self, from: data)
        let date = try self.buildDate(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let matchingFullTime = MatchingFullTimeEncoder(date: date, userID: 1)
        var completionResult: Result<MatchingFullTimeDecoder, Error>?
        //Act
        sut.fetchMatchingFullTime(parameters: matchingFullTime) { result in
            completionResult = result
        }
        try self.restler.getReturnValue.callCompletion(type: MatchingFullTimeDecoder.self, result: .success(decoder))
        //Assert
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), decoder)
    }
    
    func testFetchMatchingFullTime_failed() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = TestError(message: "fetch matching full time failed")
        let date = try self.buildDate(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let matchingFullTime = MatchingFullTimeEncoder(date: date, userID: 1)
        var completionResult: Result<MatchingFullTimeDecoder, Error>?
        //Act
        sut.fetchMatchingFullTime(parameters: matchingFullTime) { result in
            completionResult = result
        }
        try self.restler.getReturnValue.callCompletion(type: MatchingFullTimeDecoder.self, result: .failure(error))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
}

// MARK: - Private
extension ApiClientAccountingPeriodsTests {
    private func buildSUT() -> ApiClientAccountingPeriodsType {
        return ApiClient(
            restler: self.restler,
            accessService: self.accessService)
    }
}
