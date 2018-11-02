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
    private var manager: ServerConfigurationManagerType!
    
    override func setUp() {
        self.urlSessionMock = UrlSessionMock()
        self.manager = ServerConfigurationManager(urlSession: urlSessionMock)
        super.setUp()
    }
    
    func testVerifyConfigurationWhileResponseIsNil() throws {
        //Arrange
        urlSessionMock.dataTask = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, staySignedIn: false)
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
        let configuration = ServerConfiguration(host: url, staySignedIn: false)
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
    
    func testVerifyConfigurationWhileStatusCodeIsInvalid() throws {
        //Arrange
        urlSessionMock.dataTask = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, staySignedIn: false)
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
    
    func testVerifyConfigurationWhileResponseIsCorrect() throws {
        //Arrange
        urlSessionMock.dataTask = URLSessionDataTaskMock()
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, staySignedIn: false)
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

private struct TestError: Error {
    let messsage: String
}

extension TestError: Equatable {
    static func == (lhs: TestError, rhs: TestError) -> Bool {
        return lhs.messsage == rhs.messsage
    }
}
