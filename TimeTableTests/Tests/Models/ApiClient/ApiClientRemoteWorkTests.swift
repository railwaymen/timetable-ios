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

// MARK: - fetchRemoteWork(parameters:completion:)
extension ApiClientRemoteWorkTests {
    func testFetchRemoteWork_succeed() throws {
        //Arrange
        let sut = self.buildSUT()
        let parameters = RemoteWorkParameters(page: 1, perPage: 24)
        let data = try self.json(from: RemoteWorkResponseJSONResource.remoteWorkResponseFullModel)
        let decoder = try self.decoder.decode(RemoteWorkResponse.self, from: data)
        var completionResult: RemoteWorkResponseResult?
        //Act
        _ = sut.fetchRemoteWork(parameters: parameters) { result in
            completionResult = result
        }
        try self.restler.getReturnValue.callCompletion(type: RemoteWorkResponse.self, result: .success(decoder))
        //Assert
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), decoder)
    }
    
    func testFetchRemoteWork_failed() throws {
        //Arrange
        let sut = self.buildSUT()
        let parameters = RemoteWorkParameters(page: 1, perPage: 24)
        let error = TestError(message: "fetch failed")
        var completionResult: RemoteWorkResponseResult?
        //Act
        _ = sut.fetchRemoteWork(parameters: parameters) { result in
            completionResult = result
        }
        try self.restler.getReturnValue.callCompletion(type: RemoteWorkResponse.self, result: .failure(error))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
}

// MARK: - registerRemoteWork(parameters:completion:)
extension ApiClientRemoteWorkTests {
    func testRegisterRemoteWork_succeed() throws {
        //Arrange
        let sut = self.buildSUT()
        let parameters = try self.buildRemoteWorkRequest()
        let decoder = try self.buildRemoteWork()
        var completionResult: RemoteWorkArrayResult?
        //Act
        _ = sut.registerRemoteWork(parameters: parameters) { result in
            completionResult = result
        }
        try self.restler.postReturnValue.callCompletion(type: [RemoteWork].self, result: .success([decoder]))
        //Assert
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), [decoder])
    }
    
    func testRegisterRemoteWork_failed() throws {
        //Arrange
        let sut = self.buildSUT()
        let parameters = try self.buildRemoteWorkRequest()
        let error = TestError(message: "post failed")
        var completionResult: RemoteWorkArrayResult?
        //Act
        _ = sut.registerRemoteWork(parameters: parameters) { result in
            completionResult = result
        }
        try self.restler.postReturnValue.callCompletion(type: [RemoteWork].self, result: .failure(error))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
}

// MARK: - deleteRemoteWork(_:completion:)
extension ApiClientRemoteWorkTests {
    func testDeleteRemoteWork_succeed() throws {
        //Arrange
        let sut = self.buildSUT()
        let remoteWork = try self.buildRemoteWork()
        var completionResult: VoidResult?
        //Act
        _ = sut.deleteRemoteWork(remoteWork) { result in
            completionResult = result
        }
        try self.restler.deleteReturnValue.callCompletion(type: Void.self, result: .success(Void()))
        //Assert
        XCTAssertNoThrow(try XCTUnwrap(completionResult).get())
    }
    
    func testDeleteRemoteWork_failed() throws {
        //Arrange
        let sut = self.buildSUT()
        let remoteWork = try self.buildRemoteWork()
        let error = TestError(message: "delete failed")
        var completionResult: VoidResult?
        //Act
        _ = sut.deleteRemoteWork(remoteWork) { result in
            completionResult = result
        }
        try self.restler.deleteReturnValue.callCompletion(type: Void.self, result: .failure(error))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
}

// MARK: - updateRemoteWork(_:with:completion:)
extension ApiClientRemoteWorkTests {
    func testUpdateRemoteWork_succeeded() throws {
        //Arrange
        let sut = self.buildSUT()
        let parameters = try self.buildRemoteWorkRequest()
        let decoder = try self.buildRemoteWork()
        var completionResult: RemoteWorkResult?
        //Act
        _ = sut.updateRemoteWork(decoder, with: parameters, completion: { result in
            completionResult = result
        })
        try self.restler.putReturnValue.callCompletion(type: RemoteWork.self, result: .success(decoder))
        //Assert
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), decoder)
    }
    
    func testUpdateRemoteWork_failed() throws {
        //Arrange
        let sut = self.buildSUT()
        let parameters = try self.buildRemoteWorkRequest()
        let decoder = try self.buildRemoteWork()
        let error = TestError(message: "PUT failed")
        var completionResult: RemoteWorkResult?
        //Act
        _ = sut.updateRemoteWork(decoder, with: parameters, completion: { result in
            completionResult = result
        })
        try self.restler.putReturnValue.callCompletion(type: RemoteWork.self, result: .failure(error))
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
    
    private func buildRemoteWorkRequest() throws -> RemoteWorkRequest {
        let startsAt = try self.buildDate(year: 2020, month: 4, day: 14)
        let endsAt = try self.buildDate(year: 2020, month: 5, day: 3)
        return RemoteWorkRequest(note: "note", startsAt: startsAt, endsAt: endsAt)
    }
    
    private func buildRemoteWork() throws -> RemoteWork {
        let data = try self.json(from: RemoteWorkJSONResource.remoteWorkFullModel)
        return try self.decoder.decode(RemoteWork.self, from: data)
    }
}
