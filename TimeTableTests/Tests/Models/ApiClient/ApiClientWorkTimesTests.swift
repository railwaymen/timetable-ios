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
    
    override func setUp() {
        super.setUp()
        self.restler = RestlerMock()
    }
}

// MARK: - fetchWorkTimes(parameters: WorkTimesParameters, completion: @escaping ((Result<[WorkTimeDecoder], Error>) -> Void))
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
        try XCTUnwrap(self.restler.getReturnValue.getDecodeReturnedMock()?.onCompletionParams.last).handler(.success(decoders))
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
        try XCTUnwrap(self.restler.getReturnValue.getDecodeReturnedMock(type: [WorkTimeDecoder].self)?.onCompletionParams.last).handler(.failure(error))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
}

// MARK: - addWorkTime(parameters: Task, completion: @escaping ((Result<Void, Error>) -> Void))
extension ApiClientWorkTimesTests {
    func testAddWorkTimeSucceed() throws {
        //Arrange
        let sut = self.buildSUT()
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: data)
        let task = Task(project: projectDecoder, body: "body", startsAt: Date(), endsAt: Date())
        var completionResult: Result<Void, Error>?
        //Act
        sut.addWorkTime(parameters: task) { result in
            completionResult = result
        }
        try XCTUnwrap(self.restler.postReturnValue.getDecodeReturnedMock(type: Void.self)?.onCompletionParams.last).handler(.success(Void()))
        //Assert
        XCTAssertNotNil(try XCTUnwrap(completionResult).get())
    }
    
    func testAddWorkTimeFailed() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = TestError(message: "fetch failed")
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: data)
        let task = Task(project: projectDecoder, body: "body", startsAt: Date(), endsAt: Date())
        var completionResult: Result<Void, Error>?
        //Act
        sut.addWorkTime(parameters: task) { result in
            completionResult = result
        }
        try XCTUnwrap(self.restler.postReturnValue.getDecodeReturnedMock(type: Void.self)?.onCompletionParams.last).handler(.failure(error))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
}

// MARK: - deleteWorkTime(identifier: Int64, completion: @escaping ((Result<Void, Error>) -> Void))
extension ApiClientWorkTimesTests {
    func testDeleteWorkTimeSucceed() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Result<Void, Error>?
        //Act
        sut.deleteWorkTime(identifier: 2) { result in
            completionResult = result
        }
        try XCTUnwrap(self.restler.deleteReturnValue.getDecodeReturnedMock(type: Void.self)?.onCompletionParams.last).handler(.success(Void()))
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
        try XCTUnwrap(self.restler.deleteReturnValue.getDecodeReturnedMock(type: Void.self)?.onCompletionParams.last).handler(.failure(error))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
}

// MARK: - updateWorkTime(identifier: Int64, parameters: Task, completion: @escaping ((Result<Void, Error>) -> Void))
extension ApiClientWorkTimesTests {
    func testUpdateWorkTime_succeed() throws {
        //Arrange
        let sut = self.buildSUT()
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: data)
        let task = Task(project: projectDecoder, body: "body", startsAt: Date(), endsAt: Date())
        var completionResult: Result<Void, Error>?
        //Act
        sut.updateWorkTime(identifier: 1, parameters: task) { result in
            completionResult = result
        }
        try XCTUnwrap(self.restler.putReturnValue.getDecodeReturnedMock(type: Void.self)?.onCompletionParams.last).handler(.success(Void()))
        //Assert
        XCTAssertNotNil(try XCTUnwrap(completionResult).get())
    }
    
    func testUpdateWorkTime_fail() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = TestError(message: "fetch failed")
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: data)
        let task = Task(project: projectDecoder, body: "body", startsAt: Date(), endsAt: Date())
        var completionResult: Result<Void, Error>?
        //Act
        sut.updateWorkTime(identifier: 1, parameters: task) { result in
            completionResult = result
        }
        try XCTUnwrap(self.restler.putReturnValue.getDecodeReturnedMock(type: Void.self)?.onCompletionParams.last).handler(.failure(error))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
}

// MARK: - Private
extension ApiClientWorkTimesTests {
    private func buildSUT() -> ApiClientWorkTimesType {
        return ApiClient(restler: self.restler)
    }
}
