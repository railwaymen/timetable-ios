//
//  ApiClientVacationTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 23/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ApiClientVacationTests: XCTestCase {
    private var restler: RestlerMock!
    private var accessService: AccessServiceMock!
    
    override func setUp() {
        super.setUp()
        self.restler = RestlerMock()
        self.accessService = AccessServiceMock()
    }
}

// MARK: - fetchVacation(parameters: completion:)
extension ApiClientVacationTests {
    func testFetchSucceed() throws {
        //Arrange
        let parameters = VacationParameters(year: 2020)
        let sut = self.buildSUT()
        let data = try self.json(from: VacationResponseJSONResource.vacationResponseTypeResponse)
        let decoders = try self.decoder.decode(VacationResponse.self, from: data)
        var completionResult: FetchVacationResult?
        //Act
        _ = sut.fetchVacation(parameters: parameters) { result in
            completionResult = result
        }
        try self.restler.getReturnValue.callCompletion(type: VacationResponse.self, result: .success(decoders))
        //Assert
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), decoders)
    }
    
    func testFetchFailed() throws {
        //Arrange
        let parameters = VacationParameters(year: 2020)
        let sut = self.buildSUT()
        let error = TestError(message: "fetch failed")
        var completionResult: FetchVacationResult?
        //Act
        _ = sut.fetchVacation(parameters: parameters) { result in
            completionResult = result
        }
        try self.restler.getReturnValue.callCompletion(type: VacationResponse.self, result: .failure(error))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
}

// MARK: - func addVacation(_ vacation:, completion:)
extension ApiClientVacationTests {
    func testAddVacationSucceed() throws {
        //Arrange
        let sut = self.buildSUT()
        let vaction = try self.buildVacationEncoder()
        let data = try self.json(from: VacationJSONResource.vacationPlannedTypeResponse)
        let decoder = try self.decoder.decode(VacationDecoder.self, from: data)
        var completionResult: AddVacationResult?
        //Act
        _ = sut.addVacation(vaction) { result in
            completionResult = result
        }
        try self.restler.postReturnValue.callCompletion(type: VacationDecoder.self, result: .success(decoder))
        //Assert
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), decoder)
    }
    
    func testAddVacationFailed() throws {
        //Arrange
        let sut = self.buildSUT()
        let vaction = try self.buildVacationEncoder()
        let error = TestError(message: "fetch failed")
        var completionResult: AddVacationResult?
        //Act
        _ = sut.addVacation(vaction) { result in
            completionResult = result
        }
        try self.restler.postReturnValue.callCompletion(type: VacationDecoder.self, result: .failure(error))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
}

// MARK: - func declineVacation(_ vacation:, completion:)
extension ApiClientVacationTests {
    func testDeclineVacationSucceed() throws {
        //Arrange
        let sut = self.buildSUT()
        let data = try self.json(from: VacationJSONResource.vacationPlannedTypeResponse)
        let decoder = try self.decoder.decode(VacationDecoder.self, from: data)
        var completionResult: VoidResult?
        //Act
        _ = sut.declineVacation(decoder) { result in
            completionResult = result
        }
        try self.restler.putReturnValue.callCompletion(type: Void.self, result: .success(Void()))
        //Assert
        XCTAssertNotNil(try XCTUnwrap(completionResult).get())
    }
    
    func testDeclineVacationFailed() throws {
        //Arrange
        let sut = self.buildSUT()
        let data = try self.json(from: VacationJSONResource.vacationPlannedTypeResponse)
        let decoder = try self.decoder.decode(VacationDecoder.self, from: data)
        let error = TestError(message: "fetch failed")
        var completionResult: VoidResult?
        //Act
        _ = sut.declineVacation(decoder) { result in
            completionResult = result
        }
        try self.restler.putReturnValue.callCompletion(type: Void.self, result: .failure(error))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
}

// MARK: - Private
extension ApiClientVacationTests {
    private func buildSUT() -> ApiClientVacationType {
        return ApiClient(
            restler: self.restler,
            accessService: self.accessService)
    }
    
    private func buildVacationEncoder() throws -> VacationEncoder {
        let startDate = try self.buildDate(year: 2020, month: 04, day: 28)
        let endDate = try self.buildDate(year: 2020, month: 04, day: 30)
        return VacationEncoder(type: .compassionate, note: nil, startDate: startDate, endDate: endDate)
    }
}
