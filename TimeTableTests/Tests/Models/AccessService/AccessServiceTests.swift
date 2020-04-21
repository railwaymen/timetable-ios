//
//  AccessServiceTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 19/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class AccessServiceTests: XCTestCase {
    private var sessionManager: SessionManagerMock!
    private var temporarySessionManager: TemporarySessionManagerMock!
    
    override func setUp() {
        super.setUp()
        self.sessionManager = SessionManagerMock()
        self.temporarySessionManager = TemporarySessionManagerMock()
    }
}

// MARK: - getSession()
extension AccessServiceTests {
    func testGetSession_returnsSavedSessionFirst() throws {
        //Arrange
        let sut = self.buildSUT()
        let expectedSession = try self.buildSessionDecoder(id: 0)
        self.sessionManager.getSessionReturnValue = expectedSession
        self.temporarySessionManager.getSessionReturnValue = try self.buildSessionDecoder(id: 1)
        //Act
        let returnedSession = sut.getSession()
        //Assert
        XCTAssertEqual(returnedSession, expectedSession)
    }
    
    func testGetSession_savedSession_returnsTemporarySession() throws {
        //Arrange
        let sut = self.buildSUT()
        let expectedSession = try self.buildSessionDecoder()
        self.sessionManager.getSessionReturnValue = expectedSession
        self.temporarySessionManager.getSessionReturnValue = nil
        //Act
        let returnedSession = sut.getSession()
        //Assert
        XCTAssertEqual(returnedSession, expectedSession)
    }
    
    func testGetSession_temporarySession_returnsTemporarySession() throws {
        //Arrange
        let sut = self.buildSUT()
        let expectedSession = try self.buildSessionDecoder()
        self.sessionManager.getSessionReturnValue = nil
        self.temporarySessionManager.getSessionReturnValue = expectedSession
        //Act
        let returnedSession = sut.getSession()
        //Assert
        XCTAssertEqual(returnedSession, expectedSession)
    }
    
    func testGetSession_closedSession_returnsNil() throws {
        //Arrange
        let sut = self.buildSUT()
        self.sessionManager.getSessionReturnValue = nil
        self.temporarySessionManager.getSessionReturnValue = nil
        //Act
        let returnedSession = sut.getSession()
        //Assert
        XCTAssertNil(returnedSession)
    }
}

// MARK: isSessionOpened
extension AccessServiceTests {
    func testIsSessionOpened_savedSession_returnsTrue() throws {
        //Arrange
        let sut = self.buildSUT()
        let expectedSession = try self.buildSessionDecoder()
        self.sessionManager.getSessionReturnValue = expectedSession
        self.temporarySessionManager.getSessionReturnValue = nil
        //Assert
        XCTAssertTrue(sut.isSessionOpened)
    }
    
    func testIsSessionOpened_temporarySession_returnsTrue() throws {
        //Arrange
        let sut = self.buildSUT()
        let expectedSession = try self.buildSessionDecoder()
        self.sessionManager.getSessionReturnValue = nil
        self.temporarySessionManager.getSessionReturnValue = expectedSession
        //Assert
        XCTAssertTrue(sut.isSessionOpened)
    }
    
    func testIsSessionOpened_closedSession_returnsFalse() throws {
        //Arrange
        let sut = self.buildSUT()
        self.sessionManager.getSessionReturnValue = nil
        self.temporarySessionManager.getSessionReturnValue = nil
        //Assert
        XCTAssertFalse(sut.isSessionOpened)
    }
}

// MARK: - openSession()
extension AccessServiceTests {
    func testOpenSession_closesOpenedSessions() throws {
        //Arrange
        let sut = self.buildSUT()
        let session = try self.buildSessionDecoder()
        //Act
        sut.openSession(session)
        //Assert
        XCTAssertEqual(self.sessionManager.closeSessionParams.count, 1)
        XCTAssertEqual(self.temporarySessionManager.closeSessionParams.count, 1)
    }
    
    func testOpenSession_opensSavedSession() throws {
        //Arrange
        let sut = self.buildSUT()
        let session = try self.buildSessionDecoder()
        //Act
        sut.openSession(session)
        //Assert
        XCTAssertEqual(self.sessionManager.openSessionParams.count, 1)
        XCTAssertEqual(self.sessionManager.openSessionParams.last?.session, session)
        XCTAssertEqual(self.temporarySessionManager.openSessionParams.count, 0)
    }
}

// MARK: - openTemporarySession()
extension AccessServiceTests {
    func testOpenTemporarySession_closesOpenedSessions() throws {
        //Arrange
        let sut = self.buildSUT()
        let session = try self.buildSessionDecoder()
        //Act
        sut.openTemporarySession(session)
        //Assert
        XCTAssertEqual(self.sessionManager.closeSessionParams.count, 1)
        XCTAssertEqual(self.temporarySessionManager.closeSessionParams.count, 1)
    }
    
    func testOpenTemporarySession_opensTemporarySession() throws {
        //Arrange
        let sut = self.buildSUT()
        let session = try self.buildSessionDecoder()
        //Act
        sut.openTemporarySession(session)
        //Assert
        XCTAssertEqual(self.sessionManager.openSessionParams.count, 0)
        XCTAssertEqual(self.temporarySessionManager.openSessionParams.count, 1)
        XCTAssertEqual(self.temporarySessionManager.openSessionParams.last?.session, session)
    }
}

// MARK: - suspendSession()
extension AccessServiceTests {
    func testSuspendSession_suspendsTemporarySession() throws {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.suspendSession()
        //Assert
        XCTAssertEqual(self.temporarySessionManager.suspendSessionParams.count, 1)
    }
}

// MARK: - continueSuspendedSession()
extension AccessServiceTests {
    func testContinueSuspendedSession_continuesTemporarySession() throws {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.continueSuspendedSession()
        //Assert
        XCTAssertEqual(self.temporarySessionManager.continueSuspendedSessionParams.count, 1)
    }
}

// MARK: - closeSession()
extension AccessServiceTests {
    func testCloseSession_closesSessions() throws {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.closeSession()
        //Assert
        XCTAssertEqual(self.sessionManager.closeSessionParams.count, 1)
        XCTAssertEqual(self.temporarySessionManager.closeSessionParams.count, 1)
    }
}

// MARK: - getUserToken()
extension AccessServiceTests {
    func testGetUserToken_existingSession_returnsTokenFromExistingSession() throws {
        //Arrange
        let sut = self.buildSUT()
        let session = try self.buildSessionDecoder()
        self.sessionManager.getSessionReturnValue = session
        //Act
        let token = sut.getUserToken()
        //Assert
        XCTAssertEqual(token, session.token)
    }
    
    func testGetUserToken_existingTemporarySession_returnsTokenFromExistingSession() throws {
        //Arrange
        let sut = self.buildSUT()
        let session = try self.buildSessionDecoder()
        self.temporarySessionManager.getSessionReturnValue = session
        //Act
        let token = sut.getUserToken()
        //Assert
        XCTAssertEqual(token, session.token)
    }
    
    func testGetUserToken_noExistingSession_returnsTokenFromExistingSession() throws {
        //Arrange
        let sut = self.buildSUT()
        //Act
        let token = sut.getUserToken()
        //Assert
        XCTAssertNil(token)
    }
}

// MARK: - getLastLoggedInUserID()
extension AccessServiceTests {
    func testGetLastLoggedInUserID_existingSession_returnsTokenFromExistingSession() throws {
        //Arrange
        let sut = self.buildSUT()
        let session = try self.buildSessionDecoder()
        self.sessionManager.getSessionReturnValue = session
        //Act
        let userID = sut.getLastLoggedInUserID()
        //Assert
        XCTAssertEqual(userID, Int64(session.id))
    }
    
    func testGetLastLoggedInUserID_existingTemporarySession_returnsTokenFromExistingSession() throws {
        //Arrange
        let sut = self.buildSUT()
        let session = try self.buildSessionDecoder()
        self.temporarySessionManager.getSessionReturnValue = session
        //Act
        let userID = sut.getLastLoggedInUserID()
        //Assert
        XCTAssertEqual(userID, Int64(session.id))
    }
    
    func testGetLastLoggedInUserID_noExistingSession_returnsTokenFromExistingSession() throws {
        //Arrange
        let sut = self.buildSUT()
        //Act
        let userID = sut.getLastLoggedInUserID()
        //Assert
        XCTAssertNil(userID)
    }
}

// MARK: - Private
extension AccessServiceTests {
    private func buildSUT() -> AccessService {
        AccessService(
            sessionManager: self.sessionManager,
            temporarySessionManager: self.temporarySessionManager)
    }
    
    private func buildSessionDecoder(id: Int = 0) throws -> SessionDecoder {
        try SessionDecoderFactory().build(wrapper: .init(id: id))
    }
}
