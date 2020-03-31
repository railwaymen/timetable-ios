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
    private var userDefaults: UserDefaults!
    private var dispatchQueueManagerMock: DispatchQueueManagerMock!
    private var restlerFactory: RestlerFactoryMock!
    private var restler: RestlerMock!
    
    override func setUp() {
        super.setUp()
        self.userDefaults = UserDefaults()
        self.dispatchQueueManagerMock = DispatchQueueManagerMock(taskType: .performOnCurrentThread)
        self.restlerFactory = RestlerFactoryMock()
        self.restler = self.restlerFactory.buildRestlerReturnValue
    }
    
    override func tearDown() {
        self.userDefaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        super.tearDown()
    }
}

// MARK: - getOldConfiguration() -> ServerConfiguration?
extension ServerConfigurationManagerTests {
    func testGetOldConfiguration_hostUrlNotSaved() throws {
        //Arrange
        let sut = self.buildSUT()
        let configuration = ServerConfiguration(host: self.exampleURL, shouldRememberHost: false)
        sut.verify(configuration: configuration) { _ in }
        try self.restler.headReturnValue.callCompletion(type: Void.self, result: .success(Void()))
        //Act
        let oldConfiguration = try XCTUnwrap(sut.getOldConfiguration())
        //Assert
        XCTAssertNil(oldConfiguration.host)
        XCTAssertFalse(oldConfiguration.shouldRememberHost)
    }

    func testGetOldConfiguration_hostUrlSaved() throws {
        //Arrange
        let sut = self.buildSUT()
        let configuration = ServerConfiguration(host: self.exampleURL, shouldRememberHost: true)
        sut.verify(configuration: configuration) { _ in }
        try self.restler.headReturnValue.callCompletion(type: Void.self, result: .success(Void()))
        //Act
        let oldConfiguration = try XCTUnwrap(sut.getOldConfiguration())
        //Assert
        XCTAssertEqual(oldConfiguration, configuration)
    }

    func testGetOldConfiguration_hostURLValueIsNil() throws {
        //Arrange
        let sut = self.buildSUT()
        let configuration = ServerConfiguration(host: self.exampleURL, shouldRememberHost: true)
        sut.verify(configuration: configuration) { _ in }
        try self.restler.headReturnValue.callCompletion(type: Void.self, result: .success(Void()))
        self.userDefaults.removeObject(forKey: "key.time_table.server_configuration.host")
        //Act
        let oldConfiguration = sut.getOldConfiguration()
        //Assert
        XCTAssertNil(oldConfiguration)
    }

    func testGetOldConfiguration_hostURLValueIsNotURL() throws {
        //Arrange
        let sut = self.buildSUT()
        let configuration = ServerConfiguration(host: self.exampleURL, shouldRememberHost: true)
        sut.verify(configuration: configuration) { _ in }
        try self.restler.headReturnValue.callCompletion(type: Void.self, result: .success(Void()))
        self.userDefaults.set(" ", forKey: "key.time_table.server_configuration.host")
        //Act
        let oldConfiguration = sut.getOldConfiguration()
        //Assert
        XCTAssertNil(oldConfiguration)
    }
}

// MARK: - verify(configuration:completion:)
extension ServerConfigurationManagerTests {
    func testVerify_withoutURL_callsCompletionFailure() throws {
        //Arrange
        let sut = self.buildSUT()
        let configuration = ServerConfiguration(host: nil, shouldRememberHost: false)
        var completionResult: Result<Void, Error>?
        //Act
        sut.verify(configuration: configuration) { result in
            completionResult = result
        }
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: ApiClientError(type: .invalidHost(nil)))
        XCTAssertEqual(self.dispatchQueueManagerMock.performOnMainThreadParams.count, 1)
    }
    
    func testVerify_withURL_makesProperRequest() throws {
        //Arrange
        let sut = self.buildSUT()
        let configuration = ServerConfiguration(host: self.exampleURL, shouldRememberHost: false)
        var completionResult: Result<Void, Error>?
        //Act
        sut.verify(configuration: configuration) { result in
            completionResult = result
        }
        //Assert
        XCTAssertNil(completionResult)
        XCTAssertEqual(self.restlerFactory.buildRestlerParams.count, 1)
        XCTAssertEqual(self.restlerFactory.buildRestlerParams.last?.baseURL, self.exampleURL)
        XCTAssertEqual(self.restler.headParams.count, 1)
        XCTAssertEqual(self.restler.headParams.last?.endpoint as? String, "")
        XCTAssertEqual(self.restler.headReturnValue.failureDecodeParams.count, 1)
        XCTAssert(self.restler.headReturnValue.failureDecodeParams.last?.type is ApiClientError.Type)
        XCTAssertEqual(self.restler.headReturnValue.decodeParams.count, 1)
        XCTAssert(self.restler.headReturnValue.decodeParams.last?.type is Void.Type)
    }
    
    func testVerify_successResponse_callsCompletionSuccess() throws {
        //Arrange
        let sut = self.buildSUT()
        let configuration = ServerConfiguration(host: self.exampleURL, shouldRememberHost: false)
        var completionResult: Result<Void, Error>?
        //Act
        sut.verify(configuration: configuration) { result in
            completionResult = result
        }
        try self.restler.headReturnValue.callCompletion(type: Void.self, result: .success(Void()))
        //Assert
        XCTAssertNoThrow(try XCTUnwrap(completionResult).get())
        XCTAssertEqual(self.dispatchQueueManagerMock.performOnMainThreadParams.count, 1)
    }
    
    func testVerify_shouldNotRememeberHost_successResponse_savesProperValues() throws {
        //Arrange
        let sut = self.buildSUT()
        let configuration = ServerConfiguration(host: self.exampleURL, shouldRememberHost: false)
        //Act
        sut.verify(configuration: configuration) { _ in }
        try self.restler.headReturnValue.callCompletion(type: Void.self, result: .success(Void()))
        //Assert
        XCTAssertNil(self.userDefaults.string(forKey: UserDefaultsKeys.hostURLKey))
        XCTAssertFalse(try XCTUnwrap(self.userDefaults.value(forKey: UserDefaultsKeys.shouldRemeberHostKey) as? Bool))
    }
    
    func testVerify_shouldRememeberHost_successResponse_savesProperValues() throws {
        //Arrange
        let sut = self.buildSUT()
        let configuration = ServerConfiguration(host: self.exampleURL, shouldRememberHost: true)
        //Act
        sut.verify(configuration: configuration) { _ in }
        try self.restler.headReturnValue.callCompletion(type: Void.self, result: .success(Void()))
        //Assert
        XCTAssertEqual(self.userDefaults.string(forKey: UserDefaultsKeys.hostURLKey), self.exampleURL.absoluteString)
        XCTAssertTrue(try XCTUnwrap(self.userDefaults.value(forKey: UserDefaultsKeys.shouldRemeberHostKey) as? Bool))
    }
    
    func testVerify_failureResponse_apiClientError_callsCompletionFailure() throws {
        //Arrange
        let sut = self.buildSUT()
        let configuration = ServerConfiguration(host: self.exampleURL, shouldRememberHost: false)
        let error = ApiClientError(type: .noConnection)
        var completionResult: Result<Void, Error>?
        //Act
        sut.verify(configuration: configuration) { result in
            completionResult = result
        }
        try self.restler.headReturnValue.callCompletion(type: Void.self, result: .failure(error))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
        XCTAssertEqual(self.dispatchQueueManagerMock.performOnMainThreadParams.count, 1)
    }
    
    func testVerify_failureResponse_testError_callsCompletionFailure() throws {
        //Arrange
        let sut = self.buildSUT()
        let configuration = ServerConfiguration(host: self.exampleURL, shouldRememberHost: false)
        let error = TestError(message: "test error")
        let expectedError = ApiClientError(type: .invalidHost(self.exampleURL))
        var completionResult: Result<Void, Error>?
        //Act
        sut.verify(configuration: configuration) { result in
            completionResult = result
        }
        try self.restler.headReturnValue.callCompletion(type: Void.self, result: .failure(error))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: expectedError)
        XCTAssertEqual(self.dispatchQueueManagerMock.performOnMainThreadParams.count, 1)
    }
}

// MARK: - Private
extension ServerConfigurationManagerTests {
    private func buildSUT() -> ServerConfigurationManagerType {
        return ServerConfigurationManager(
            userDefaults: self.userDefaults,
            dispatchQueueManager: self.dispatchQueueManagerMock,
            restlerFactory: self.restlerFactory)
    }
}

// MARK: - Private structures
extension ServerConfigurationManagerTests {
    private struct UserDefaultsKeys {
        static let hostURLKey = "key.time_table.server_configuration.host"
        static let shouldRemeberHostKey = "key.time_table.server_configuration.should_remeber_host_key"
    }
}
