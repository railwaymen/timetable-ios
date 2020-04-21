//
//  AppCoordinatorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 25/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
import KeychainAccess
@testable import TimeTable

class AppCoordinatorTests: XCTestCase {
    private var dependencyContainer: DependencyContainerMock!
    
    private var viewControllerBuilderMock: ViewControllerBuilderMock {
        self.dependencyContainer.viewControllerBuilderMock
    }
    
    override func setUp() {
        super.setUp()
        self.dependencyContainer = DependencyContainerMock()
        self.dependencyContainer.window = UIWindow()
    }
}

// MARK: - start(finishHandler:)
extension AppCoordinatorTests {
    func testStart_withoutOpenSession_runsAuthenticationCoordinator() throws {
        //Arrange
        let sut = self.buildSUT()
        self.dependencyContainer.accessServiceMock.isSessionOpenedReturnValue = false
        //Act
        sut.start()
        //Assert
        XCTAssertEqual(sut.children.count, 1)
        XCTAssert(sut.children.last is AuthenticationCoordinator)
    }
    
    func testStart_withOpenSession_withoutServerConfiguration_runsAuthenticationCoordinator() throws {
        //Arrange
        let sut = self.buildSUT()
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = nil
        self.dependencyContainer.accessServiceMock.isSessionOpenedReturnValue = true
        //Act
        sut.start()
        //Assert
        XCTAssertEqual(sut.children.count, 1)
        XCTAssert(sut.children.last is AuthenticationCoordinator)
    }
    
    func testStart_withOpenSession_withEmptyServerConfiguration_runsAuthenticationCoordinator() throws {
        //Arrange
        let sut = self.buildSUT()
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(
            host: nil)
        self.dependencyContainer.accessServiceMock.isSessionOpenedReturnValue = true
        //Act
        sut.start()
        //Assert
        XCTAssertEqual(sut.children.count, 1)
        XCTAssert(sut.children.last is AuthenticationCoordinator)
    }
    
    func testStart_withOpenSession_withServerConfiguration_runsMainFlow() throws {
        //Arrange
        let sut = self.buildSUT()
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(
            host: self.exampleURL)
        self.dependencyContainer.accessServiceMock.isSessionOpenedReturnValue = true
        //Act
        sut.start()
        //Assert
        XCTAssertEqual(sut.children.count, 1)
        XCTAssert(sut.children.last is TimeTableTabCoordinator)
    }
}

// MARK: - finish()
extension AppCoordinatorTests {
    func testServerConfigurationCoordinatorFinishBlockRunAuthenticationFlow() throws {
        //Arrange
        let sut = self.buildSUT()
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = nil
        sut.start()
        let serverConfigurationCoordinator = sut.children.first as? AuthenticationCoordinator
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(
            host: self.exampleURL)
        //Act
        serverConfigurationCoordinator?.finish()
        //Assert
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertNotNil(sut.children.first as? AuthenticationCoordinator)
    }

    func testRunMainFlowFinishRemovesTimeTableTabCoordinatorFromChildrenAndRunsServerConfigurationFlow() throws {
        //Arrange
        let sut = self.buildSUT()
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(
            host: self.exampleURL)
        self.dependencyContainer.accessServiceMock.isSessionOpenedReturnValue = true
        sut.start()
        let child = try XCTUnwrap(sut.children.first as? TimeTableTabCoordinator)
        //Act
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = nil
        child.finish()
        //Assert
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertNotNil(sut.children.first as? AuthenticationCoordinator)
    }

    func testRunMainFlowFinishRemovesTimeTableTabCoordinatorFromChildrenAndRunsAuthenticationFlow() throws {
        //Arrange
        let sut = self.buildSUT()
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(
            host: self.exampleURL)
        self.dependencyContainer.accessServiceMock.isSessionOpenedReturnValue = true
        sut.start()
        let child = try XCTUnwrap(sut.children.first as? TimeTableTabCoordinator)
        self.dependencyContainer.accessServiceMock.isSessionOpenedReturnValue = false
        //Act
        child.finish()
        //Assert
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertNotNil(sut.children.first as? AuthenticationCoordinator)
    }
}

// MARK: - Private
extension AppCoordinatorTests {
    private func buildSUT() -> AppCoordinator {
        return AppCoordinator(dependencyContainer: self.dependencyContainer)
    }
    
    private func buildSessionDecoder() throws -> SessionDecoder {
        return SessionDecoder(
            id: 1,
            firstName: "John",
            lastName: "Little",
            isLeader: false,
            admin: false,
            manager: false,
            token: "token_abcd")
    }
}
