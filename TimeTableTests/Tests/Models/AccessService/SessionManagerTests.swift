//
//  SessionManagerTests.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 03/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class SessionManagerTests: XCTestCase {
    private var keychainBuilder: KeychainBuilderMock!
    private var encoderMock: JSONEncoderMock!
    private var decoderMock: JSONDecoderMock!
    private var errorHandler: ErrorHandlerMock!
    private var serverConfigurationManager: ServerConfigurationManagerMock!
    private var keychainAccess: KeychainAccessMock!
    
    private var userSessionKey: String {
        "key.time_table.user_session"
    }
    
    override func setUp() {
        super.setUp()
        self.keychainBuilder = KeychainBuilderMock()
        self.encoderMock = JSONEncoderMock()
        self.decoderMock = JSONDecoderMock()
        self.errorHandler = ErrorHandlerMock()
        self.serverConfigurationManager = ServerConfigurationManagerMock()
        self.keychainAccess = KeychainAccessMock()
        self.keychainBuilder.buildReturnValue = self.keychainAccess
    }
}

// MARK: - open(session:)
extension SessionManagerTests {
    func testOpenSession_buildsKeychain() throws {
        //Arrange
        let sut = self.buildSUT()
        let session = try self.buildSessionDecoder()
        self.serverConfigurationManager.getOldConfigurationReturnValue = ServerConfiguration(
            host: self.exampleURL)
        //Act
        sut.open(session: session)
        //Assert
        XCTAssertEqual(self.keychainBuilder.buildParams.count, 1)
        XCTAssertEqual(self.keychainBuilder.buildParams.last?.url, self.exampleURL)
    }
    
    func testOpenSession_savesEncodedSessionToKeychain() throws {
        //Arrange
        let sut = self.buildSUT()
        let session = try self.buildSessionDecoder()
        //Act
        sut.open(session: session)
        //Assert
        let expectedData = try self.encoder.encode(session)
        XCTAssertEqual(self.keychainAccess.setDataParams.count, 1)
        XCTAssertEqual(self.keychainAccess.setDataParams.last?.value, expectedData)
        XCTAssertEqual(self.keychainAccess.setDataParams.last?.key, self.userSessionKey)
    }
    
    func testOpenSession_encodingErrorStopsAppInDebug() throws {
        //Arrange
        let sut = self.buildSUT()
        let session = try self.buildSessionDecoder()
        self.encoderMock.shouldThrowError = true
        //Act
        sut.open(session: session)
        //Assert
        XCTAssertEqual(self.errorHandler.stopInDebugParams.count, 1)
    }
    
    func testOpenSession_keychainErrorStopsAppInDebug() throws {
        //Arrange
        let sut = self.buildSUT()
        let session = try self.buildSessionDecoder()
        let error = "Keychain error"
        self.keychainAccess.setDataThrowError = error
        //Act
        sut.open(session: session)
        //Assert
        XCTAssertEqual(self.errorHandler.stopInDebugParams.count, 1)
        XCTAssertEqual(self.errorHandler.stopInDebugParams.last?.message, error)
    }
}

// MARK: - getSession()
extension SessionManagerTests {
    func testGetSession_withSavedSession_returnsSession() throws {
        //Arrange
        let sut = self.buildSUT()
        let savedSession = try self.buildSessionDecoder()
        let data = try self.encoder.encode(savedSession)
        self.keychainAccess.getDataReturnValue = data
        //Act
        let session = sut.getSession()
        //Assert
        XCTAssertEqual(self.keychainAccess.getDataParams.count, 1)
        XCTAssertEqual(self.keychainAccess.getDataParams.last?.key, self.userSessionKey)
        XCTAssertEqual(session, savedSession)
    }
    
    func testGetSession_withKeychainError_returnsNil() throws {
        //Arrange
        let sut = self.buildSUT()
        self.keychainAccess.getDataThrowError = "Error"
        //Act
        let session = sut.getSession()
        //Assert
        XCTAssertNil(session)
    }
    
    func testGetSession_withDecodingError_returnsNil() throws {
        //Arrange
        let sut = self.buildSUT()
        let savedSession = try self.buildSessionDecoder()
        let data = try self.encoder.encode(savedSession)
        self.keychainAccess.getDataReturnValue = data
        self.decoderMock.shouldThrowError = true
        //Act
        let session = sut.getSession()
        //Assert
        XCTAssertNil(session)
    }
}

// MARK: - closeSession()
extension SessionManagerTests {
    func testCloseSession_sessionOpened_removesSession() throws {
        //Arrange
        let sut = self.buildSUT()
        try self.set(isSessionOpened: true)
        //Act
        sut.closeSession()
        //Assert
        XCTAssertEqual(self.keychainAccess.removeParams.count, 1)
        XCTAssertEqual(self.keychainAccess.removeParams.last?.key, self.userSessionKey)
    }
    
    func testCloseSession_sessionOpened_keychainErrorStopsAppInDebug() throws {
        //Arrange
        let sut = self.buildSUT()
        try self.set(isSessionOpened: true)
        let error = "Keychain error"
        self.keychainAccess.removeThrowError = error
        //Act
        sut.closeSession()
        //Assert
        XCTAssertEqual(self.errorHandler.stopInDebugParams.count, 1)
        XCTAssertEqual(self.errorHandler.stopInDebugParams.last?.message, error)
    }
    
    func testCloseSession_sessionClosed() throws {
        //Arrange
        let sut = self.buildSUT()
        try self.set(isSessionOpened: false)
        //Act
        sut.closeSession()
        //Assert
        XCTAssertEqual(self.keychainAccess.removeParams.count, 0)
        XCTAssertEqual(self.errorHandler.stopInDebugParams.count, 0)
    }
}

// MARK: - Private
extension SessionManagerTests {
    private func buildSUT() -> SessionManager {
        SessionManager(
            keychainBuilder: self.keychainBuilder,
            encoder: self.encoderMock,
            decoder: self.decoderMock,
            errorHandler: self.errorHandler,
            serverConfigurationManager: self.serverConfigurationManager)
    }
    
    private func buildSessionDecoder() throws -> SessionDecoder {
        try SessionDecoderFactory().build()
    }
    
    private func set(isSessionOpened: Bool) throws {
        if isSessionOpened {
            let session = try self.buildSessionDecoder()
            let data = try self.encoder.encode(session)
            self.keychainAccess.getDataReturnValue = data
        } else {
            self.keychainAccess.getDataReturnValue = nil
        }
    }
}
