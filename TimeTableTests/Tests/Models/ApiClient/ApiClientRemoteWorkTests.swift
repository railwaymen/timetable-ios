//
//  ApiClientRemoteWorkTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 06/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ApiClientRemoteWorkTests: XCTestCase {
    private var restler: RestlerMock!
    private var accessService: AccessServiceMock!
    
    override func setUp() {
        super.setUp()
        self.restler = RestlerMock()
        self.accessService = AccessServiceMock()
    }
}

// MARK: - func fetchRemoteWork(parameters: _, completion: _) -> RestlerTaskType?
extension ApiClientRemoteWorkTests {
    func testFetchRemoteWorkSucceed() throws {
        //Arrange
        let sut = self.buildSUT()
        let parameters = RemoteWorkParameters(page: 1, perPage: 24)
        let data = try self.json(from: RemoteWorkResponseJSONResource.remoteWorkResponseFullModel)
        let decoder = try self.decoder.decode(RemoteWorkResponse.self, from: data)
        var completionResult: RemoteWorkResult?
        //Act
        _ = sut.fetchRemoteWork(parameters: parameters) { result in
            completionResult = result
        }
        try self.restler.getReturnValue.callCompletion(type: RemoteWorkResponse.self, result: .success(decoder))
        //Assert
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), decoder)
    }
    
    func testFetchRemoteWorkFailed() throws {
        //Arrange
        let sut = self.buildSUT()
        let parameters = RemoteWorkParameters(page: 1, perPage: 24)
        let error = TestError(message: "fetch failed")
        var completionResult: RemoteWorkResult?
        //Act
        _ = sut.fetchRemoteWork(parameters: parameters) { result in
            completionResult = result
        }
        try self.restler.getReturnValue.callCompletion(type: RemoteWorkResponse.self, result: .failure(error))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
}

// MARK: - Private
extension ApiClientRemoteWorkTests {
    private func buildSUT() -> ApiClientRemoteWorkType {
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
