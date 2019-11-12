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

    private var urlSessionMock: UrlSessionMock!
    private var userDefaultsMock: UserDefaultsMock!
    private var dispatchQueueManagerMock: DispatchQueueManagerMock!
    private var manager: ServerConfigurationManagerType!
    
    override func setUp() {
        super.setUp()
        self.urlSessionMock = UrlSessionMock()
        self.userDefaultsMock = UserDefaultsMock()
        self.dispatchQueueManagerMock = DispatchQueueManagerMock(taskType: .performOnCurrentThread)
        self.manager = ServerConfigurationManager(urlSession: self.urlSessionMock,
                                                  userDefaults: self.userDefaultsMock,
                                                  dispatchQueueManager: self.dispatchQueueManagerMock)
    }
    
    func testVerifyConfigurationWhileResponseIsNil() throws {
        //Arrange
        self.urlSessionMock.dataTask = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, shouldRememberHost: false)
        var expectedError: Error?
        //Act
        self.manager.verify(configuration: configuration) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        self.urlSessionMock.completionHandler?(nil, nil, nil)
        //Assert
        switch (expectedError as? ApiClientError)?.type {
        case .invalidHost(let host)?:
            XCTAssertEqual(host, url)
        default: XCTFail()
        }
    }
    
    func testVerifyConfigurationWhileErrorOccured() throws {
        //Arrange
        self.urlSessionMock.dataTask = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, shouldRememberHost: false)
        let fakeResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        var expectedError: Error?
        //Act
        self.manager.verify(configuration: configuration) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        self.urlSessionMock.completionHandler?(nil, fakeResponse, TestError(message: ""))
        //Assert
        switch (expectedError as? ApiClientError)?.type {
        case .invalidHost(let host)?:
            XCTAssertEqual(host, url)
        default: XCTFail()
        }
    }
    
    func testGetOldConfigurationWhileHostUrlWasNotSaved() throws {
        //Arrange
        self.urlSessionMock.dataTask = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, shouldRememberHost: false)
        let fakeResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        self.manager.verify(configuration: configuration) { _ in }
        self.urlSessionMock.completionHandler?(nil, fakeResponse, nil)
        //Act
        let oldConfiguration = try self.manager.getOldConfiguration().unwrap()
        //Assert
        XCTAssertNil(oldConfiguration.host)
        XCTAssertFalse(oldConfiguration.shouldRememberHost)
    }
    
    func testGetOldConfigurationWhileHostUrlWasSaved() throws {
        //Arrange
        self.urlSessionMock.dataTask = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, shouldRememberHost: true)
        let fakeResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        self.manager.verify(configuration: configuration) { _ in }
        self.urlSessionMock.completionHandler?(nil, fakeResponse, nil)
        //Act
        let oldConfiguration = try self.manager.getOldConfiguration().unwrap()
        //Assert
        XCTAssertEqual(oldConfiguration, configuration)
    }
    
    func testGetOldConfigurationWhileHostURLValueIsNil() throws {
        //Arrange
        self.urlSessionMock.dataTask = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, shouldRememberHost: true)
        let fakeResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        self.manager.verify(configuration: configuration) { _ in }
        self.urlSessionMock.completionHandler?(nil, fakeResponse, nil)
        self.userDefaultsMock.setAnyValueDictionary.removeAll()
        //Act
        let oldConfiguration = self.manager.getOldConfiguration()
        //Assert
        XCTAssertNil(oldConfiguration)
    }
    
    func testGetOldConfigurationWhileHostURLValueIsNotURL() throws {
        //Arrange
        self.urlSessionMock.dataTask = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, shouldRememberHost: true)
        let fakeResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        self.manager.verify(configuration: configuration) { _ in }
        self.urlSessionMock.completionHandler?(nil, fakeResponse, nil)
        let key = try self.userDefaultsMock.setAnyValueDictionary.first.unwrap().key
        self.userDefaultsMock.setAnyValueDictionary[key] = "\\example"
        //Act
        let oldConfiguration = self.manager.getOldConfiguration()
        //Assert
        XCTAssertNil(oldConfiguration)
    }
    
    func testVerifyConfigurationWhileStatusCodeIsInvalid() throws {
        //Arrange
        self.urlSessionMock.dataTask = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, shouldRememberHost: false)
        let fakeResponse = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)
        var expectedError: Error?
        //Act
        self.manager.verify(configuration: configuration) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        self.urlSessionMock.completionHandler?(nil, fakeResponse, nil)
        //Assert
        switch (expectedError as? ApiClientError)?.type {
        case .invalidHost(let host)?:
            XCTAssertEqual(host, url)
        default: XCTFail()
        }
    }
    
    func testVerifyConfigurationWhileConfigurationDoesNotContainsHostURL() {
        //Arrange
        let configuration = ServerConfiguration(host: nil, shouldRememberHost: false)
        var expectedError: Error?
        //Act
        self.manager.verify(configuration: configuration) { result in
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
        self.urlSessionMock.dataTask = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, shouldRememberHost: false)
        let fakeResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        var successCalled: Bool = false
        //Act
        self.manager.verify(configuration: configuration) { result in
            switch result {
            case .success:
                successCalled = true
            case .failure:
                XCTFail()
            }
        }
        self.urlSessionMock.completionHandler?(nil, fakeResponse, nil)
        //Assert
        XCTAssertTrue(successCalled)
    }

    func testVerifyConfigurationSaveHostURL() throws {
        //Arrange
        self.urlSessionMock.dataTask = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, shouldRememberHost: true)
        let fakeResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        //Act
        self.manager.verify(configuration: configuration) { _ in }
        self.urlSessionMock.completionHandler?(nil, fakeResponse, nil)
        //Assert
        XCTAssertFalse(self.userDefaultsMock.setAnyValueDictionary.isEmpty)
        let hostURLString = try (self.userDefaultsMock.setAnyValueDictionary.first?.value as? String).unwrap()
        let hostURL = try URL(string: hostURLString).unwrap()
        XCTAssertEqual(hostURL, url)
        XCTAssertFalse(self.userDefaultsMock.setBoolValueDictionary.isEmpty)
        let shouldSaveHostURL = try self.userDefaultsMock.setBoolValueDictionary.first.unwrap().value
        XCTAssertTrue(shouldSaveHostURL)
    }
    
    func testVerifyConfigurationDoesNotSaveHostURLWhileShouldRemeberHostIsFalse() throws {
        //Arrange
        self.urlSessionMock.dataTask = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, shouldRememberHost: false)
        let fakeResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        //Act
        self.manager.verify(configuration: configuration) { _ in }
        self.urlSessionMock.completionHandler?(nil, fakeResponse, nil)
        //Assert
        XCTAssertTrue(self.userDefaultsMock.setAnyValueDictionary.isEmpty)
        XCTAssertFalse(self.userDefaultsMock.setBoolValueDictionary.isEmpty)
        let value = try self.userDefaultsMock.setBoolValueDictionary.first.unwrap().value
        XCTAssertFalse(value)
    }
}
