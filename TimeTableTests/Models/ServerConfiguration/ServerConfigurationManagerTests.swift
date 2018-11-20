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
    private var manager: ServerConfigurationManagerType!
    
    override func setUp() {
        self.urlSessionMock = UrlSessionMock()
        self.userDefaultsMock = UserDefaultsMock()
        self.manager = ServerConfigurationManager(urlSession: urlSessionMock, userDefaults: userDefaultsMock)
        super.setUp()
    }
    
    func testVerifyConfigurationWhileResponseIsNil() throws {
        //Arrange
        urlSessionMock.dataTask = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, shouldRememberHost: false)
        var expectedError: Error?
        //Act
        manager.verify(configuration: configuration) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        urlSessionMock.completionHandler?(nil, nil, nil)
        //Assert
        switch expectedError as? ApiError {
        case .invalidHost(let host)?:
            XCTAssertEqual(host, url)
        default: XCTFail()
        }
    }
    
    func testVerifyConfigurationWhileErrorOccured() throws {
        //Arrange
        urlSessionMock.dataTask = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, shouldRememberHost: false)
        let fakeResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        var expectedError: Error?
        //Act
        manager.verify(configuration: configuration) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        urlSessionMock.completionHandler?(nil, fakeResponse, TestError(messsage: ""))
        //Assert
        switch expectedError as? ApiError {
        case .invalidHost(let host)?:
            XCTAssertEqual(host, url)
        default: XCTFail()
        }
    }
    
    func testGetOldConfigurationWhileHostUrlWasNotSaved() throws {
        //Arrange
        urlSessionMock.dataTask = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, shouldRememberHost: false)
        let fakeResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        manager.verify(configuration: configuration) { _ in }
        urlSessionMock.completionHandler?(nil, fakeResponse, nil)
        //Act
        let oldConfiguration = try manager.getOldConfiguration().unwrap()
        //Assert
        XCTAssertNil(oldConfiguration.host)
        XCTAssertFalse(oldConfiguration.shouldRememberHost)
    }
    
    func testGetOldConfigurationWhileHostUrlWasSaved() throws {
        //Arrange
        urlSessionMock.dataTask = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, shouldRememberHost: true)
        let fakeResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        manager.verify(configuration: configuration) { _ in }
        urlSessionMock.completionHandler?(nil, fakeResponse, nil)
        //Act
        let oldConfiguration = try manager.getOldConfiguration().unwrap()
        //Assert
        XCTAssertEqual(oldConfiguration, configuration)
    }
    
    func testGetOldConfigurationWhileHostURLValueIsNil() throws {
        //Arrange
        urlSessionMock.dataTask = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, shouldRememberHost: true)
        let fakeResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        manager.verify(configuration: configuration) { _ in }
        urlSessionMock.completionHandler?(nil, fakeResponse, nil)
        userDefaultsMock.setAnyValueDictionary.removeAll()
        //Act
        let oldConfiguration = manager.getOldConfiguration()
        //Assert
        XCTAssertNil(oldConfiguration)
    }
    
    func testGetOldConfigurationWhileHostURLValueIsNotURL() throws {
        //Arrange
        urlSessionMock.dataTask = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, shouldRememberHost: true)
        let fakeResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        manager.verify(configuration: configuration) { _ in }
        urlSessionMock.completionHandler?(nil, fakeResponse, nil)
        let key = try userDefaultsMock.setAnyValueDictionary.first.unwrap().key
        userDefaultsMock.setAnyValueDictionary[key] = "\\example"
        //Act
        let oldConfiguration = manager.getOldConfiguration()
        //Assert
        XCTAssertNil(oldConfiguration)
    }
    
    func testVerifyConfigurationWhileStatusCodeIsInvalid() throws {
        //Arrange
        urlSessionMock.dataTask = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, shouldRememberHost: false)
        let fakeResponse = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)
        var expectedError: Error?
        //Act
        manager.verify(configuration: configuration) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        urlSessionMock.completionHandler?(nil, fakeResponse, nil)
        //Assert
        switch expectedError as? ApiError {
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
        manager.verify(configuration: configuration) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        //Asserta
        switch expectedError as? ApiError {
        case .invalidHost(let host)?:
            XCTAssertNil(host)
        default: XCTFail()
        }
    }
    
    func testVerifyConfigurationWhileResponseIsCorrect() throws {
        //Arrange
        urlSessionMock.dataTask = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, shouldRememberHost: false)
        let fakeResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        var successCalled: Bool = false
        //Act
        manager.verify(configuration: configuration) { result in
            switch result {
            case .success:
                successCalled = true
            case .failure:
                XCTFail()
            }
        }
        urlSessionMock.completionHandler?(nil, fakeResponse, nil)
        //Assert
        XCTAssertTrue(successCalled)
    }

    func testVerifyConfigurationSaveHostURL() throws {
        //Arrange
        urlSessionMock.dataTask = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, shouldRememberHost: true)
        let fakeResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        //Act
        manager.verify(configuration: configuration) { _ in }
        urlSessionMock.completionHandler?(nil, fakeResponse, nil)
        //Assert
        XCTAssertFalse(userDefaultsMock.setAnyValueDictionary.isEmpty)
        let hostURLString = try (userDefaultsMock.setAnyValueDictionary.first?.value as? String).unwrap()
        let hostURL = try URL(string: hostURLString).unwrap()
        XCTAssertEqual(hostURL, url)
        XCTAssertFalse(userDefaultsMock.setBoolValueDictionary.isEmpty)
        let shouldSaveHostURL = try userDefaultsMock.setBoolValueDictionary.first.unwrap().value
        XCTAssertTrue(shouldSaveHostURL)
    }
    
    func testVerifyConfigurationDoesNotSaveHostURLWhileShouldRemeberHostIsFalse() throws {
        //Arrange
        urlSessionMock.dataTask = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, shouldRememberHost: false)
        let fakeResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        //Act
        manager.verify(configuration: configuration) { _ in }
        urlSessionMock.completionHandler?(nil, fakeResponse, nil)
        //Assert
        XCTAssertTrue(userDefaultsMock.setAnyValueDictionary.isEmpty)
        XCTAssertFalse(userDefaultsMock.setBoolValueDictionary.isEmpty)
        let value = try userDefaultsMock.setBoolValueDictionary.first.unwrap().value
        XCTAssertFalse(value)
    }
}

private class UrlSessionMock: URLSessionType {
    var dataTask: URLSessionDataTaskMock!
    private(set) var request: URLRequest?
    private(set) var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskType {
        self.request = request
        self.completionHandler = completionHandler
        return dataTask
    }
}

private class URLSessionDataTaskMock: URLSessionDataTaskType {
    private(set) var resumeCalled = false
    func resume() {
        resumeCalled = true
    }
}

private class UserDefaultsMock: UserDefaultsType {
    var setAnyValueDictionary: [String: Any?] = [:]
    var setBoolValueDictionary: [String: Bool] = [:]
    
    func bool(forKey defaultName: String) -> Bool {
        return setBoolValueDictionary[defaultName] ?? false
    }
    
    func removeObject(forKey defaultName: String) {
        setAnyValueDictionary.removeValue(forKey: defaultName)
        setBoolValueDictionary.removeValue(forKey: defaultName)
    }
    
    func set(_ value: Any?, forKey defaultName: String) {
        setAnyValueDictionary[defaultName] = value
    }
    
    func set(_ value: Bool, forKey defaultName: String) {
        setBoolValueDictionary[defaultName] = value
    }
    
    func string(forKey defaultName: String) -> String? {
        return (setAnyValueDictionary[defaultName] as? String) ?? nil
    }
    
    func object(forKey defaultName: String) -> Any? { return nil }
}

private struct TestError: Error {
    let messsage: String
}

extension TestError: Equatable {
    static func == (lhs: TestError, rhs: TestError) -> Bool {
        return lhs.messsage == rhs.messsage
    }
}
