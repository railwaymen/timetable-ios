//
//  ServerConfigurationManagerTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 31/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ServerConfigurationManagerTests: XCTestCase {
    private var urlSessionMock: URLSessionMock!
    private var userDefaults: UserDefaults!
    private var dispatchQueueManagerMock: DispatchQueueManagerMock!
    
    override func setUp() {
        super.setUp()
        self.urlSessionMock = URLSessionMock()
        self.userDefaults = UserDefaults()
        self.dispatchQueueManagerMock = DispatchQueueManagerMock(taskType: .performOnCurrentThread)
    }
    
    override func tearDown() {
        self.userDefaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        super.tearDown()
    }
    
    func testVerifyConfigurationWhileResponseIsNil() throws {
        //Arrange
        let sut = self.buildSUT()
        self.urlSessionMock.dataTaskReturnValue = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, shouldRememberHost: false)
        var expectedError: Error?
        //Act
        sut.verify(configuration: configuration) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        self.urlSessionMock.dataTaskParams.last?.completionHandler(nil, nil, nil)
        //Assert
        switch (expectedError as? ApiClientError)?.type {
        case .invalidHost(let host)?:
            XCTAssertEqual(host, url)
        default: XCTFail()
        }
    }
    
    func testVerifyConfigurationWhileErrorOccured() throws {
        //Arrange
        let sut = self.buildSUT()
        self.urlSessionMock.dataTaskReturnValue = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, shouldRememberHost: false)
        let fakeResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        var expectedError: Error?
        //Act
        sut.verify(configuration: configuration) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        self.urlSessionMock.dataTaskParams.last?.completionHandler(nil, fakeResponse, TestError(message: ""))
        //Assert
        switch (expectedError as? ApiClientError)?.type {
        case .invalidHost(let host)?:
            XCTAssertEqual(host, url)
        default: XCTFail()
        }
    }
    
    func testGetOldConfigurationWhileHostUrlWasNotSaved() throws {
        //Arrange
        let sut = self.buildSUT()
        self.urlSessionMock.dataTaskReturnValue = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, shouldRememberHost: false)
        let fakeResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        sut.verify(configuration: configuration) { _ in }
        self.urlSessionMock.dataTaskParams.last?.completionHandler(nil, fakeResponse, nil)
        //Act
        let oldConfiguration = try sut.getOldConfiguration().unwrap()
        //Assert
        XCTAssertNil(oldConfiguration.host)
        XCTAssertFalse(oldConfiguration.shouldRememberHost)
    }
    
    func testGetOldConfigurationWhileHostUrlWasSaved() throws {
        //Arrange
        let sut = self.buildSUT()
        self.urlSessionMock.dataTaskReturnValue = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, shouldRememberHost: true)
        let fakeResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        sut.verify(configuration: configuration) { _ in }
        self.urlSessionMock.dataTaskParams.last?.completionHandler(nil, fakeResponse, nil)
        //Act
        let oldConfiguration = try sut.getOldConfiguration().unwrap()
        //Assert
        XCTAssertEqual(oldConfiguration, configuration)
    }
    
    func testGetOldConfigurationWhileHostURLValueIsNil() throws {
        //Arrange
        let sut = self.buildSUT()
        self.urlSessionMock.dataTaskReturnValue = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, shouldRememberHost: true)
        let fakeResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        sut.verify(configuration: configuration) { _ in }
        self.urlSessionMock.dataTaskParams.last?.completionHandler(nil, fakeResponse, nil)
        self.userDefaults.removeObject(forKey: "key.time_table.server_configuration.host")
        //Act
        let oldConfiguration = sut.getOldConfiguration()
        //Assert
        XCTAssertNil(oldConfiguration)
    }
    
    func testGetOldConfigurationWhileHostURLValueIsNotURL() throws {
        //Arrange
        let sut = self.buildSUT()
        self.urlSessionMock.dataTaskReturnValue = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, shouldRememberHost: true)
        let fakeResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        sut.verify(configuration: configuration) { _ in }
        self.urlSessionMock.dataTaskParams.last?.completionHandler(nil, fakeResponse, nil)
        self.userDefaults.set(" ", forKey: "key.time_table.server_configuration.host")
        //Act
        let oldConfiguration = sut.getOldConfiguration()
        //Assert
        XCTAssertNil(oldConfiguration)
    }
    
    func testVerifyConfigurationWhileStatusCodeIsInvalid() throws {
        //Arrange
        let sut = self.buildSUT()
        self.urlSessionMock.dataTaskReturnValue = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, shouldRememberHost: false)
        let fakeResponse = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)
        var expectedError: Error?
        //Act
        sut.verify(configuration: configuration) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        self.urlSessionMock.dataTaskParams.last?.completionHandler(nil, fakeResponse, nil)
        //Assert
        switch (expectedError as? ApiClientError)?.type {
        case .invalidHost(let host)?:
            XCTAssertEqual(host, url)
        default: XCTFail()
        }
    }
    
    func testVerifyConfigurationWhileConfigurationDoesNotContainsHostURL() {
        //Arrange
        let sut = self.buildSUT()
        let configuration = ServerConfiguration(host: nil, shouldRememberHost: false)
        var expectedError: Error?
        //Act
        sut.verify(configuration: configuration) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        //Asserta
        switch (expectedError as? ApiClientError)?.type {
        case .invalidHost(let host)?:
            XCTAssertNil(host)
        default: XCTFail()
        }
    }
    
    func testVerifyConfigurationWhileResponseIsCorrect() throws {
        //Arrange
        let sut = self.buildSUT()
        self.urlSessionMock.dataTaskReturnValue = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, shouldRememberHost: false)
        let fakeResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        var successCalled: Bool = false
        //Act
        sut.verify(configuration: configuration) { result in
            switch result {
            case .success:
                successCalled = true
            case .failure:
                XCTFail()
            }
        }
        self.urlSessionMock.dataTaskParams.last?.completionHandler(nil, fakeResponse, nil)
        //Assert
        XCTAssertTrue(successCalled)
    }

    func testVerifyConfigurationSaveHostURL() throws {
        //Arrange
        let sut = self.buildSUT()
        self.urlSessionMock.dataTaskReturnValue = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, shouldRememberHost: true)
        let fakeResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        //Act
        sut.verify(configuration: configuration) { _ in }
        self.urlSessionMock.dataTaskParams.last?.completionHandler(nil, fakeResponse, nil)
        //Assert
        let hostURLString = try (self.userDefaults.string(forKey: "key.time_table.server_configuration.host")).unwrap()
        let hostURL = try URL(string: hostURLString).unwrap()
        XCTAssertEqual(hostURL, url)
        let shouldSaveHostURL = try (self.userDefaults.value(forKey: "key.time_table.server_configuration.should_remeber_host_key") as? Bool).unwrap()
        XCTAssertTrue(shouldSaveHostURL)
    }
    
    func testVerifyConfigurationDoesNotSaveHostURLWhileShouldRemeberHostIsFalse() throws {
        //Arrange
        let sut = self.buildSUT()
        self.urlSessionMock.dataTaskReturnValue = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, shouldRememberHost: false)
        let fakeResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        //Act
        sut.verify(configuration: configuration) { _ in }
        self.urlSessionMock.dataTaskParams.last?.completionHandler(nil, fakeResponse, nil)
        //Assert
        XCTAssertNil(self.userDefaults.value(forKey: "key.time_table.server_configuration.host"))
        let value = try (self.userDefaults.value(forKey: "key.time_table.server_configuration.should_remeber_host_key") as? Bool).unwrap()
        XCTAssertFalse(value)
    }
}

// MARK: - Private
extension ServerConfigurationManagerTests {
    private func buildSUT() -> ServerConfigurationManagerType {
        return ServerConfigurationManager(urlSession: self.urlSessionMock,
                                          userDefaults: self.userDefaults,
                                          dispatchQueueManager: self.dispatchQueueManagerMock)
    }
}
