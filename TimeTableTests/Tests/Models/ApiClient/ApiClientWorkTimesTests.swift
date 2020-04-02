//
//  ApiClient+WorkTimes.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ApiClientWorkTimesTests: XCTestCase {
    private var restler: RestlerMock!
    private var accessService: AccessServiceMock!
    
    override func setUp() {
        super.setUp()
        self.restler = RestlerMock()
        self.accessService = AccessServiceMock()
    }
}

// MARK: - fetchWorkTimes(parameters:completion:)
extension ApiClientWorkTimesTests {
    func testFetchSucceed() throws {
        //Arrange
        let sut = self.buildSUT()
        let data = try self.json(from: WorkTimesJSONResource.workTimesResponse)
        let decoders = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        let parameters = WorkTimesParameters(fromDate: nil, toDate: nil, projectId: nil)
        var completionResult: Result<[WorkTimeDecoder], Error>?
        //Act
        _ = sut.fetchWorkTimes(parameters: parameters) { result in
            completionResult = result
        }
        try self.restler.getReturnValue.callCompletion(type: [WorkTimeDecoder].self, result: .success(decoders))
        //Assert
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), decoders)
    }
    
    func testFetchFailed() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = TestError(message: "fetch failed")
        let parameters = WorkTimesParameters(fromDate: nil, toDate: nil, projectId: nil)
        var completionResult: Result<[WorkTimeDecoder], Error>?
        //Act
        _ = sut.fetchWorkTimes(parameters: parameters) { result in
            completionResult = result
        }
        try self.restler.getReturnValue.callCompletion(type: [WorkTimeDecoder].self, result: .failure(error))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
}

// MARK: - fetchWorkTimeDetails(identifier:completion:)
extension ApiClientWorkTimesTests {
    func testFetchDetails_requestsProperEndpoint() throws {
        //Arrange
        let sut = self.buildSUT()
        //Act
        _ = sut.fetchWorkTimeDetails(identifier: 1) { _ in }
        //Assert
        XCTAssertEqual(self.restler.getParams.count, 1)
        XCTAssertEqual(self.restler.getParams.last?.endpoint as? Endpoint, Endpoint.workTime(1))
    }
    
    func testFetchDetails_success() throws {
        //Arrange
        let sut = self.buildSUT()
        let data = try self.json(from: WorkTimesJSONResource.workTimeResponse)
        let decoder = try self.decoder.decode(WorkTimeDecoder.self, from: data)
        var completionResult: Result<WorkTimeDecoder, Error>?
        //Act
        _ = sut.fetchWorkTimeDetails(identifier: 1) { result in
            completionResult = result
        }
        try self.restler.getReturnValue.callCompletion(type: WorkTimeDecoder.self, result: .success(decoder))
        //Assert
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), decoder)
    }
    
    func testFetchDetails_failure() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = TestError(message: "test error123")
        var completionResult: Result<WorkTimeDecoder, Error>?
        //Act
        _ = sut.fetchWorkTimeDetails(identifier: 1) { result in
            completionResult = result
        }
        try self.restler.getReturnValue.callCompletion(type: WorkTimeDecoder.self, result: .failure(error))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
}

// MARK: - addWorkTime(parameters:completion:)
extension ApiClientWorkTimesTests {
    func testAddWorkTimeSucceed() throws {
        //Arrange
        let sut = self.buildSUT()
        let task = try self.buildTask()
        var completionResult: Result<Void, Error>?
        //Act
        _ = sut.addWorkTime(parameters: task) { result in
            completionResult = result
        }
        try self.restler.postReturnValue.callCompletion(type: Void.self, result: .success(Void()))
        //Assert
        XCTAssertNotNil(try XCTUnwrap(completionResult).get())
    }
    
    func testAddWorkTimeFailed() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = TestError(message: "fetch failed")
        let task = try self.buildTask()
        var completionResult: Result<Void, Error>?
        //Act
        _ = sut.addWorkTime(parameters: task) { result in
            completionResult = result
        }
        try self.restler.postReturnValue.callCompletion(type: Void.self, result: .failure(error))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
}

// MARK: - addWorkTimeWithFilling(task:completion:)
extension ApiClientWorkTimesTests {
    func testAddWorkTimeWithFilling_requestsProperEndpoint() throws {
        //Arrange
        let sut = self.buildSUT()
        let task = try self.buildTask()
        //Act
        _ = sut.addWorkTimeWithFilling(task: task) { _ in }
        //Assert
        XCTAssertEqual(self.restler.postParams.count, 1)
        XCTAssertEqual(self.restler.postParams.last?.endpoint as? Endpoint, Endpoint.workTimesCreateWithFilling)
    }
    
    func testAddWorkTimeWithFilling_success() throws {
        //Arrange
        let sut = self.buildSUT()
        let task = try self.buildTask()
        var completionResult: Result<Void, Error>?
        //Act
        _ = sut.addWorkTimeWithFilling(task: task) { result in
            completionResult = result
        }
        try self.restler.postReturnValue.callCompletion(type: Void.self, result: .success(Void()))
        //Assert
        XCTAssertNotNil(try XCTUnwrap(completionResult).get())
    }
    
    func testAddWorkTimeWithFilling_failure() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = TestError(message: "fetch failed")
        let task = try self.buildTask()
        var completionResult: Result<Void, Error>?
        //Act
        _ = sut.addWorkTimeWithFilling(task: task) { result in
            completionResult = result
        }
        try self.restler.postReturnValue.callCompletion(type: Void.self, result: .failure(error))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
}

// MARK: - deleteWorkTime(identifier:completion:)
extension ApiClientWorkTimesTests {
    func testDeleteWorkTimeSucceed() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Result<Void, Error>?
        //Act
        sut.deleteWorkTime(identifier: 2) { result in
            completionResult = result
        }
        try self.restler.deleteReturnValue.callCompletion(type: Void.self, result: .success(Void()))
        //Assert
        XCTAssertNotNil(try XCTUnwrap(completionResult).get())
    }
    
    func testDeleteWorkTimeFailed() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = TestError(message: "fetch failed")
        var completionResult: Result<Void, Error>?
        //Act
        sut.deleteWorkTime(identifier: 2) { result in
            completionResult = result
        }
        try self.restler.deleteReturnValue.callCompletion(type: Void.self, result: .failure(error))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
}

// MARK: - updateWorkTime(identifier:parameters:completion:)
extension ApiClientWorkTimesTests {
    func testUpdateWorkTime_succeed() throws {
        //Arrange
        let sut = self.buildSUT()
        let task = try self.buildTask()
        var completionResult: Result<Void, Error>?
        //Act
        _ = sut.updateWorkTime(identifier: 1, parameters: task) { result in
            completionResult = result
        }
        try self.restler.putReturnValue.callCompletion(type: Void.self, result: .success(Void()))
        //Assert
        XCTAssertNotNil(try XCTUnwrap(completionResult).get())
    }
    
    func testUpdateWorkTime_fail() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = TestError(message: "fetch failed")
        let task = try self.buildTask()
        var completionResult: Result<Void, Error>?
        //Act
        _ = sut.updateWorkTime(identifier: 1, parameters: task) { result in
            completionResult = result
        }
        try self.restler.putReturnValue.callCompletion(type: Void.self, result: .failure(error))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
}

// MARK: - Private
extension ApiClientWorkTimesTests {
    private func buildSUT() -> ApiClientWorkTimesType {
        return ApiClient(
            restler: self.restler,
            accessService: self.accessService)
    }
    
    private func buildTask() throws -> Task {
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        let projectDecoder = try self.decoder.decode(SimpleProjectRecordDecoder.self, from: data)
        return Task(project: projectDecoder, body: "body", startsAt: Date(), endsAt: Date())
    }
}
