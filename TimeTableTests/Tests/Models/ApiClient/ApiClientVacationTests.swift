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

// MARK: - fetchVacation(completion:)
extension ApiClientVacationTests {
    func testFetchSucceed() throws {
        //Arrange
        let sut = self.buildSUT()
        let data = try self.json(from: VacationResponseJSONResource.vacationResponseTypeResponse)
        let decoders = try self.decoder.decode(VacationResponse.self, from: data)
        var completionResult: VacationResult?
        //Act
        _ = sut.fetchVacation { result in
            completionResult = result
        }
        try self.restler.getReturnValue.callCompletion(type: VacationResponse.self, result: .success(decoders))
        //Assert
        let result = try XCTUnwrap(completionResult).get()
        
        XCTAssertEqual(result, decoders)
    }
    
    func testFetchFailed() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = TestError(message: "fetch failed")
        var completionResult: VacationResult?
        //Act
        _ = sut.fetchVacation { result in
            completionResult = result
        }
        try self.restler.getReturnValue.callCompletion(type: VacationResponse.self, result: .failure(error))
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
}
