//
//  TemporarySessionManagerTests.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 03/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class TemporarySessionManagerTests: XCTestCase {
    private var dateFactory: DateFactoryMock!
    
    override func setUp() {
        super.setUp()
        self.dateFactory = DateFactoryMock()
    }
}

// MARK: - Setting Session
extension TemporarySessionManagerTests {
    func testSettingSession_returnsTheSameSessionProvidedOnOpen() throws {
        //Arrange
        let sut = self.buildSUT()
        let session = try self.buildSessionDecoder()
        //Act
        sut.open(session: session)
        let returnedSession = sut.getSession()
        //Assert
        XCTAssertEqual(session, returnedSession)
    }
}

// MARK: - Suspending Session
extension TemporarySessionManagerTests {
    func testSuspendingSession_continuesSessionBeforeAcceptedDeadline() throws {
        //Arrange
        let sut = self.buildSUT()
        let session = try self.buildSessionDecoder()
        sut.open(session: session)
        let acceptedTime: TimeInterval = 2 * .minute + 59
        let suspendingDate = try self.exampleDate()
        self.dateFactory.currentDateReturnValue = suspendingDate
        //Act
        sut.suspendSession()
        self.dateFactory.currentDateReturnValue = suspendingDate.addingTimeInterval(acceptedTime)
        sut.continueSuspendedSession()
        //Assert
        XCTAssertEqual(sut.getSession(), session)
    }
    
    func testSuspendingSession_closesSessionAfter() throws {
        //Arrange
        let sut = self.buildSUT()
        let session = try self.buildSessionDecoder()
        sut.open(session: session)
        let notAcceptedTime: TimeInterval = 3 * .minute + 1
        let suspendingDate = try self.exampleDate()
        self.dateFactory.currentDateReturnValue = suspendingDate
        //Act
        sut.suspendSession()
        self.dateFactory.currentDateReturnValue = suspendingDate.addingTimeInterval(notAcceptedTime)
        sut.continueSuspendedSession()
        //Assert
        XCTAssertNil(sut.getSession())
    }
    
    func testSuspendingSession_withoutCallingContinue_continuesSessionBeforeAcceptedDeadline() throws {
        //Arrange
        let sut = self.buildSUT()
        let session = try self.buildSessionDecoder()
        sut.open(session: session)
        let acceptedTime: TimeInterval = 2 * .minute + 59
        let suspendingDate = try self.exampleDate()
        self.dateFactory.currentDateReturnValue = suspendingDate
        //Act
        sut.suspendSession()
        self.dateFactory.currentDateReturnValue = suspendingDate.addingTimeInterval(acceptedTime)
        //Assert
        XCTAssertEqual(sut.getSession(), session)
    }
    
    func testSuspendingSession_withoutCallingContinue_closesSessionAfter() throws {
        //Arrange
        let sut = self.buildSUT()
        let session = try self.buildSessionDecoder()
        sut.open(session: session)
        let notAcceptedTime: TimeInterval = 3 * .minute + 1
        let suspendingDate = try self.exampleDate()
        self.dateFactory.currentDateReturnValue = suspendingDate
        //Act
        sut.suspendSession()
        self.dateFactory.currentDateReturnValue = suspendingDate.addingTimeInterval(notAcceptedTime)
        //Assert
        XCTAssertNil(sut.getSession())
    }
}

// MARK: - Private
extension TemporarySessionManagerTests {
    private func buildSUT() -> TemporarySessionManager {
        TemporarySessionManager(dateFactory: self.dateFactory)
    }
    
    private func buildSessionDecoder() throws -> SessionDecoder {
        try SessionDecoderFactory().build()
    }
    
    private func exampleDate() throws -> Date {
        try self.buildDate(year: 2020, month: 3, day: 1)
    }
}
