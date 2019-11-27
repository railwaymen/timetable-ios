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
    private var networkingMock: NetworkingMock!
    private var requestEncoderMock: RequestEncoderMock!
    private var jsonDecoderMock: JSONDecoderMock!
    
    override func setUp() {
        super.setUp()
        self.networkingMock = NetworkingMock()
        self.requestEncoderMock = RequestEncoderMock()
        self.jsonDecoderMock = JSONDecoderMock()
    }

    // MARK: - ApiClientWorkTimesType
    func testFetchSucceed() throws {
        //Arrange
        let sut = self.buildSUT()
        let data = try self.json(from: WorkTimesJSONResource.workTimesResponse)
        let decoders = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        var expectedWorkTimes: [WorkTimeDecoder]?
        let parameters = WorkTimesParameters(fromDate: nil, toDate: nil, projectId: nil)
        //Act
        sut.fetchWorkTimes(parameters: parameters) { result in
            switch result {
            case .success(let workTimeDecoder):
                expectedWorkTimes = workTimeDecoder
            case .failure:
                XCTFail()
            }
        }
        self.networkingMock.getParams.last?.completion(.success(data))
        //Assert
        XCTAssertEqual(try XCTUnwrap(expectedWorkTimes?[0]), decoders[0])
        XCTAssertEqual(try XCTUnwrap(expectedWorkTimes?[1]), decoders[1])
    }
    
    func testFetchFailed() throws {
        //Arrange
        let sut = self.buildSUT()
        var expectedError: Error?
        let error = TestError(message: "fetch failed")
        let parameters = WorkTimesParameters(fromDate: nil, toDate: nil, projectId: nil)
        //Act
        sut.fetchWorkTimes(parameters: parameters) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        self.networkingMock.getParams.last?.completion(.failure(error))
        //Assert
        let testError = try XCTUnwrap(expectedError as? TestError)
        XCTAssertEqual(testError, error)
    }
    
    func testAddWorkTimeSucceed() throws {
        //Arrange
        let sut = self.buildSUT()
        var successCalled = false
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: data)
        let task = Task(
            workTimeIdentifier: nil,
            project: projectDecoder,
            body: "body",
            url: nil,
            day: nil,
            startsAt: nil,
            endsAt: nil,
            tag: .development)
        //Act
        sut.addWorkTime(parameters: task) { result in
            switch result {
            case .success:
                successCalled = true
            case .failure:
                XCTFail()
            }
        }
        self.networkingMock.postParams.last?.completion(.success(data))
        //Assert
        XCTAssertTrue(successCalled)
    }
    
    func testAddWorkTimeFailed() throws {
        //Arrange
        let sut = self.buildSUT()
        var expectedError: Error?
        let error = TestError(message: "fetch failed")
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: data)
        let task = Task(
            workTimeIdentifier: nil,
            project: projectDecoder,
            body: "body",
            url: nil,
            day: nil,
            startsAt: nil,
            endsAt: nil,
            tag: .development)
        //Act
        sut.addWorkTime(parameters: task) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        self.networkingMock.postParams.last?.completion(.failure(error))
        //Assert
        let testError = try XCTUnwrap(expectedError as? TestError)
        XCTAssertEqual(testError, error)
    }
    
    func testDeleteWorkTimeSucceed() {
        //Arrange
        let sut = self.buildSUT()
        var successCalled = false
        //Act
        sut.deleteWorkTime(identifier: 2) { result in
            switch result {
            case .success:
                successCalled = true
            case .failure:
                XCTFail()
            }
        }
        self.networkingMock.deleteParams.last?.completion(.success(Void()))
        //Assert
        XCTAssertTrue(successCalled)
    }
    
    func testDeleteWorkTimeFailed() throws {
        //Arrange
        let sut = self.buildSUT()
        var expectedError: Error?
        let error = TestError(message: "fetch failed")
        //Act
        sut.deleteWorkTime(identifier: 2) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        self.networkingMock.deleteParams.last?.completion(.failure(error))
        //Assert
        let testError = try XCTUnwrap(expectedError as? TestError)
        XCTAssertEqual(testError, error)
    }
    
    func testUpdateWorkTime_succeed() throws {
        //Arrange
        let sut = self.buildSUT()
        var successCalled = false
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: data)
        let task = Task(
            workTimeIdentifier: nil,
            project: projectDecoder,
            body: "body",
            url: nil,
            day: nil,
            startsAt: nil,
            endsAt: nil,
            tag: .development)
        //Act
        sut.updateWorkTime(identifier: 1, parameters: task) { result in
            switch result {
            case .success:
                successCalled = true
            case .failure:
                XCTFail()
            }
        }
        self.networkingMock.putParams.last?.completion(.success(data))
        //Assert
        XCTAssertTrue(successCalled)
    }
    
    func testUpdateWorkTime_fail() throws {
        //Arrange
        let sut = self.buildSUT()
        var expectedError: Error?
        let error = TestError(message: "fetch failed")
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectFullResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: data)
        let task = Task(
            workTimeIdentifier: nil,
            project: projectDecoder,
            body: "body",
            url: nil,
            day: nil,
            startsAt: nil,
            endsAt: nil,
            tag: .development)
        //Act
        sut.updateWorkTime(identifier: 1, parameters: task) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        self.networkingMock.putParams.last?.completion(.failure(error))
        //Assert
        let testError = try XCTUnwrap(expectedError as? TestError)
        XCTAssertEqual(testError, error)
    }
}

// MARK: - Private
extension ApiClientWorkTimesTests {
    private func buildSUT() -> ApiClientWorkTimesType {
        return ApiClient(
            networking: self.networkingMock,
            encoder: self.requestEncoderMock,
            decoder: self.jsonDecoderMock)
    }
}
