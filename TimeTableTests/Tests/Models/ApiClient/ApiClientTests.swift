//
//  ApiClientTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 06/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

// swiftlint:disable file_length
// swiftlint:disable type_body_length
class ApiClientTests: XCTestCase {
    private var networkingMock: NetworkingMock!
    private var requestEncoderMock: RequestEncoderMock!
    private var jsonDecoderMock: JSONDecoderMock!

    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter(type: .dateAndTimeExtended))
        return decoder
    }()
    
    override func setUp() {
        self.networkingMock = NetworkingMock()
        self.requestEncoderMock = RequestEncoderMock()
        self.jsonDecoderMock = JSONDecoderMock()
        super.setUp()
    }

    // MARK: - ApiClientNetworkingType
    func testPostReturnsAnErrorWhileGivenWrapperCannotBeEncodedToDictionary() {
        //ArrangeC
        var expectedError: Error?
        let apiClient = self.buildApiClient()
        let parameters = LoginCredentials(email: "user1@example.com", password: "password")
        self.requestEncoderMock.isEncodeToDictionaryThrowingError = true
        //Act
        apiClient.post(Endpoints.signIn, parameters: parameters) { (result: TimeTable.Result<SessionDecoder>) in
            switch result {
            case .success: XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        //Assert
        switch (expectedError as? ApiClientError)?.type {
        case .invalidParameters?: break
        default: XCTFail()
        }
    }
    
    func testPostReturnsAnErrorWhileNetworkRequestFailed() throws {
        //Arrange
        var expectedError: Error?
        let error = TestError(message: "500 - server internal error")
        let parameters = LoginCredentials(email: "user1@example.com", password: "password")
        let apiClient = self.buildApiClient()
        //Act
        apiClient.post(Endpoints.signIn, parameters: parameters) { (result: TimeTable.Result<SessionDecoder>) in
            switch result {
            case .success: XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        self.networkingMock.postParams.last?.completion(.failure(error))
        //Assert
        let testError = try (expectedError as? TestError).unwrap()
        XCTAssertEqual(testError, error)
    }
    
    func testPostReturnsCorrectDecodableObject() throws {
        //Arrange
        var expectedDecoder: Decodable?
        let parameters = LoginCredentials(email: "user1@example.com", password: "password")
        let data = try self.json(from: SessionJSONResource.signInResponse)
        let apiClient = self.buildApiClient()
        //Act
        apiClient.post(Endpoints.signIn, parameters: parameters) { (result: TimeTable.Result<SessionDecoder>) in
            switch result {
            case .success(let decoder):
                expectedDecoder = decoder
            case .failure:
                XCTFail()
            }
        }
        self.networkingMock.postParams.last?.completion(.success(data))
        //Assert
        let decoder = try (expectedDecoder as? SessionDecoder).unwrap()
        XCTAssertEqual(decoder.identifier, 1)
        XCTAssertEqual(decoder.firstName, "Admin")
        XCTAssertEqual(decoder.lastName, "Little")
        XCTAssertFalse(decoder.isLeader)
        XCTAssertTrue(decoder.admin)
        XCTAssertFalse(decoder.manager)
        XCTAssertEqual(decoder.token, "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiJiMDhmODZhZi0zNWRhLTQ4ZjIt")
    }
    
    func testPostReturnsAnErrorWhileResponseJSONIsInvalid() throws {
        //Arrange
        var expectedError: Error?
        let parameters = LoginCredentials(email: "user1@example.com", password: "password")
        let data = try JSONSerialization.data(withJSONObject: ["test": "test"], options: .prettyPrinted)
        let apiClient = self.buildApiClient()
        //Act
        apiClient.post(Endpoints.signIn, parameters: parameters) { (result: TimeTable.Result<SessionDecoder>) in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
                
            }
        }
        self.networkingMock.postParams.last?.completion(.success(data))
        //Assert
        switch (expectedError as? ApiClientError)?.type {
        case .invalidResponse?: break
        default: XCTFail()
        }
    }
    
    func testPostWithoutDecodableResponseReturnsAnErrorWhileGivenWrapperCannotBeEncodedToDictionary() throws {
        //Arrange
        var expectedError: Error?
        let apiClient = self.buildApiClient()
        var components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 21, hour: 15)
        let startsAt = try Calendar.current.date(from: components).unwrap()
        components.hour = 16
        let endsAt = try Calendar.current.date(from: components).unwrap()
        components.day = 22
        let day = try Calendar.current.date(from: components).unwrap()
        let data = try self.json(from: WorkTimesProjectJSONResource.workTimesProjectResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: data)
        let url = try URL(string: "www.example.com").unwrap()
        let task = Task(workTimeIdentifier: nil,
                        project: projectDecoder,
                        body: "TEST",
                        url: url,
                        day: day,
                        startAt: startsAt,
                        endAt: endsAt,
                        tag: .development)
        self.requestEncoderMock.isEncodeToDictionaryThrowingError = true
        //Act
        apiClient.post(Endpoints.workTimes, parameters: task) { (result: TimeTable.Result<Void>) in
            switch result {
            case .success: XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        //Assert
        switch (expectedError as? ApiClientError)?.type {
        case .invalidParameters?: break
        default: XCTFail()
        }
    }

    func testPostWithoutDecodableResponseReturnsAnErrorWhileNetworkRequestFailed() throws {
        //Arrange
        var expectedError: Error?
        let error = TestError(message: "500 - server internal error")
        let apiClient = self.buildApiClient()
        var components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 21, hour: 15)
        let startsAt = try Calendar.current.date(from: components).unwrap()
        components.hour = 16
        let endsAt = try Calendar.current.date(from: components).unwrap()
        components.day = 22
        let day = try Calendar.current.date(from: components).unwrap()
        let data = try self.json(from: WorkTimesProjectJSONResource.workTimesProjectResponse)
        let projectDecoder = try decoder.decode(ProjectDecoder.self, from: data)
        let url = try URL(string: "www.example.com").unwrap()
        let task = Task(workTimeIdentifier: nil,
                        project: projectDecoder,
                        body: "TEST",
                        url: url,
                        day: day,
                        startAt: startsAt,
                        endAt: endsAt,
                        tag: .development)
        //Act
        apiClient.post(Endpoints.workTimes, parameters: task) { (result: TimeTable.Result<Void>) in
            switch result {
            case .success: XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        self.networkingMock.postParams.last?.completion(.failure(error))
        //Assert
        let testError = try (expectedError as? TestError).unwrap()
        XCTAssertEqual(testError, error)
    }
    
    func testPostWithoutDecodableResponseReturnsCorrectDecodableObject() throws {
        //Arrange
        var successCalled = false
        let apiClient = self.buildApiClient()
        var components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 21, hour: 15)
        let startsAt = try Calendar.current.date(from: components).unwrap()
        components.hour = 16
        let endsAt = try Calendar.current.date(from: components).unwrap()
        components.day = 22
        let day = try Calendar.current.date(from: components).unwrap()
        let data = try self.json(from: WorkTimesProjectJSONResource.workTimesProjectResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: data)
        let url = try URL(string: "www.example.com").unwrap()
        let task = Task(workTimeIdentifier: nil,
                        project: projectDecoder,
                        body: "TEST",
                        url: url,
                        day: day,
                        startAt: startsAt,
                        endAt: endsAt,
                        tag: .development)
        //Act
        apiClient.post(Endpoints.workTimes, parameters: task) { (result: TimeTable.Result<Void>) in
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

    func testGetReturnsAnErrorWhileGivenWrapperCannotBeEncodedToDictionary() {
        //Arrange
        var expectedError: Error?
        let apiClient = self.buildApiClient()
        let parameters = WorkTimesParameters(fromDate: nil, toDate: nil, projectIdentifier: nil)
        self.requestEncoderMock.isEncodeToDictionaryThrowingError = true
        //Act
        apiClient.get(Endpoints.workTimes, parameters: parameters) { (result: TimeTable.Result<[WorkTimeDecoder]>) in
            switch result {
            case .success: XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        //Assert
        switch (expectedError as? ApiClientError)?.type {
        case .invalidParameters?: break
        default: XCTFail()
        }
    }

    func testGetReturnsAnErrorWhileNetworkRequestFailed() throws {
        //Arrange
        var expectedError: Error?
        let error = TestError(message: "500 - server internal error")
        let parameters = WorkTimesParameters(fromDate: nil, toDate: nil, projectIdentifier: nil)
        let apiClient = self.buildApiClient()
        //Act
        apiClient.get(Endpoints.workTimes, parameters: parameters) { (result: TimeTable.Result<[WorkTimeDecoder]>) in
            switch result {
            case .success: XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        self.networkingMock.getParams.last?.completion(.failure(error))
        //Assert
        let testError = try (expectedError as? TestError).unwrap()
        XCTAssertEqual(testError, error)
    }
    
    func testGetReturnsCorrectDecodableObject() throws {
        //Arrange
        var expectedDecoder: Decodable?
        let parameters = WorkTimesParameters(fromDate: nil, toDate: nil, projectIdentifier: nil)
        let data = try self.json(from: WorkTimesJSONResource.workTimesResponse)
        let decoders = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        let apiClient = self.buildApiClient()
        //Act
        apiClient.get(Endpoints.workTimes, parameters: parameters) { (result: TimeTable.Result<[WorkTimeDecoder]>) in
            switch result {
            case .success(let decoder):
                expectedDecoder = decoder
            case .failure:
                XCTFail()
            }
        }
        self.networkingMock.getParams.last?.completion(.success(data))
        //Assert
        let decoder = try (expectedDecoder as? [WorkTimeDecoder]).unwrap()
        XCTAssertEqual(decoder[0], decoders[0])
        XCTAssertEqual(decoder[1], decoders[1])
    }
    
    func testGetReturnsAnErrorWhileResponseJSONIsInvalid() throws {
        //Arrange
        var expectedError: Error?
        let parameters = WorkTimesParameters(fromDate: nil, toDate: nil, projectIdentifier: nil)
        let data = try JSONSerialization.data(withJSONObject: ["test": "test"], options: .prettyPrinted)
        let apiClient = self.buildApiClient()
        //Act
        apiClient.get(Endpoints.workTimes, parameters: parameters) { (result: TimeTable.Result<[WorkTimeDecoder]>) in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
                
            }
        }
        self.networkingMock.getParams.last?.completion(.success(data))
        //Assert
        switch (expectedError as? ApiClientError)?.type {
        case .invalidResponse?: break
        default: XCTFail()
        }
    }
    
    func testPutReturnsAnErrorWhileGivenWrapperCannotBeEncodedToDictionary() {
        //ArrangeC
        var expectedError: Error?
        let apiClient = self.buildApiClient()
        let parameters = LoginCredentials(email: "user1@example.com", password: "password")
        self.requestEncoderMock.isEncodeToDictionaryThrowingError = true
        //Act
        apiClient.put(Endpoints.signIn, parameters: parameters) { (result: TimeTable.Result<SessionDecoder>) in
            switch result {
            case .success: XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        //Assert
        switch (expectedError as? ApiClientError)?.type {
        case .invalidParameters?: break
        default: XCTFail()
        }
    }
    
    func testPutReturnsAnErrorWhileNetworkRequestFailed() throws {
        //Arrange
        var expectedError: Error?
        let error = TestError(message: "500 - server internal error")
        let parameters = LoginCredentials(email: "user1@example.com", password: "password")
        let apiClient = self.buildApiClient()
        //Act
        apiClient.put(Endpoints.signIn, parameters: parameters) { (result: TimeTable.Result<SessionDecoder>) in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        self.networkingMock.putParams.last?.completion(.failure(error))
        //Assert
        let testError = try (expectedError as? TestError).unwrap()
        XCTAssertEqual(testError, error)
    }
    
    func testPutReturnsCorrectDecodableObject() throws {
        //Arrange
        var expectedDecoder: Decodable?
        let parameters = LoginCredentials(email: "user1@example.com", password: "password")
        let data = try self.json(from: SessionJSONResource.signInResponse)
        let apiClient = self.buildApiClient()
        //Act
        apiClient.put(Endpoints.signIn, parameters: parameters) { (result: TimeTable.Result<SessionDecoder>) in
            switch result {
            case .success(let decoder):
                expectedDecoder = decoder
            case .failure:
                XCTFail()
            }
        }
        self.networkingMock.putParams.last?.completion(.success(data))
        //Assert
        let decoder = try (expectedDecoder as? SessionDecoder).unwrap()
        XCTAssertEqual(decoder.identifier, 1)
        XCTAssertEqual(decoder.firstName, "Admin")
        XCTAssertEqual(decoder.lastName, "Little")
        XCTAssertFalse(decoder.isLeader)
        XCTAssertTrue(decoder.admin)
        XCTAssertFalse(decoder.manager)
        XCTAssertEqual(decoder.token, "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiJiMDhmODZhZi0zNWRhLTQ4ZjIt")
    }
    
    func testPutReturnsAnErrorWhileResponseJSONIsInvalid() throws {
        //Arrange
        var expectedError: Error?
        let parameters = LoginCredentials(email: "user1@example.com", password: "password")
        let data = try JSONSerialization.data(withJSONObject: ["test": "test"], options: .prettyPrinted)
        let apiClient = self.buildApiClient()
        //Act
        apiClient.put(Endpoints.signIn, parameters: parameters) { (result: TimeTable.Result<SessionDecoder>) in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
                
            }
        }
        self.networkingMock.putParams.last?.completion(.success(data))
        //Assert
        let testError = try (expectedError as? ApiClientError).unwrap()
        XCTAssertEqual(testError.type, .invalidResponse)
    }
    
    func testPutWithoutDecodableResponseReturnsAnErrorWhileGivenWrapperCannotBeEncodedToDictionary() throws {
        //Arrange
        var expectedError: Error?
        let apiClient = self.buildApiClient()
        var components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 21, hour: 15)
        let startsAt = try Calendar.current.date(from: components).unwrap()
        components.hour = 16
        let endsAt = try Calendar.current.date(from: components).unwrap()
        components.day = 22
        let day = try Calendar.current.date(from: components).unwrap()
        let data = try self.json(from: WorkTimesProjectJSONResource.workTimesProjectResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: data)
        let url = try URL(string: "www.example.com").unwrap()
        let task = Task(workTimeIdentifier: nil,
                        project: projectDecoder,
                        body: "TEST",
                        url: url,
                        day: day,
                        startAt: startsAt,
                        endAt: endsAt,
                        tag: .development)
        self.requestEncoderMock.isEncodeToDictionaryThrowingError = true
        //Act
        apiClient.put(Endpoints.workTimes, parameters: task) { (result: TimeTable.Result<Void>) in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        //Assert
        let testError = try (expectedError as? ApiClientError).unwrap()
        XCTAssertEqual(testError.type, .invalidParameters)
    }
    
    func testPutWithoutDecodableResponseReturnsAnErrorWhileNetworkRequestFailed() throws {
        //Arrange
        var expectedError: Error?
        let error = TestError(message: "500 - server internal error")
        let apiClient = self.buildApiClient()
        var components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 21, hour: 15)
        let startsAt = try Calendar.current.date(from: components).unwrap()
        components.hour = 16
        let endsAt = try Calendar.current.date(from: components).unwrap()
        components.day = 22
        let day = try Calendar.current.date(from: components).unwrap()
        let data = try self.json(from: WorkTimesProjectJSONResource.workTimesProjectResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: data)
        let url = try URL(string: "www.example.com").unwrap()
        let task = Task(workTimeIdentifier: nil,
                        project: projectDecoder,
                        body: "TEST",
                        url: url,
                        day: day,
                        startAt: startsAt,
                        endAt: endsAt,
                        tag: .development)
        //Act
        apiClient.put(Endpoints.workTimes, parameters: task) { (result: TimeTable.Result<Void>) in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        self.networkingMock.putParams.last?.completion(.failure(error))
        //Assert
        let testError = try (expectedError as? TestError).unwrap()
        XCTAssertEqual(testError, error)
    }
    
    func testPutWithoutDecodableResponseReturnsCorrectDecodableObject() throws {
        //Arrange
        var successCalled = false
        let apiClient = self.buildApiClient()
        var components = DateComponents(timeZone: TimeZone(secondsFromGMT: 3600), year: 2018, month: 11, day: 21, hour: 15)
        let startsAt = try Calendar.current.date(from: components).unwrap()
        components.hour = 16
        let endsAt = try Calendar.current.date(from: components).unwrap()
        components.day = 22
        let day = try Calendar.current.date(from: components).unwrap()
        let data = try self.json(from: WorkTimesProjectJSONResource.workTimesProjectResponse)
        let projectDecoder = try self.decoder.decode(ProjectDecoder.self, from: data)
        let url = try URL(string: "www.example.com").unwrap()
        let task = Task(workTimeIdentifier: nil,
                        project: projectDecoder,
                        body: "TEST",
                        url: url,
                        day: day,
                        startAt: startsAt,
                        endAt: endsAt,
                        tag: .development)
        //Act
        apiClient.put(Endpoints.workTimes, parameters: task) { (result: TimeTable.Result<Void>) in
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

    // MARK: - Private
    private func buildApiClient() -> ApiClient {
        return ApiClient(networking: self.networkingMock,
                         encoder: self.requestEncoderMock,
                         decoder: self.jsonDecoderMock)
    }
}
// swiftlint:enable type_body_length
// swiftlint:enable file_length
