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
    
    private var storyboardsManagerMock: StoryboardsManagerMock {
        self.dependencyContainer.storyboardsManagerMock
    }
    
    override func setUp() {
        super.setUp()
        self.dependencyContainer = DependencyContainerMock()
        self.dependencyContainer.window = UIWindow()
    }
}

// MARK: - start(finishHandler: (() -> Void)?)
extension AppCoordinatorTests {
    func testStart_appCoordinatorDoNotContainChildControllers() throws {
        //Arrange
        let sut = self.buildSUT()
        self.dependencyContainer.accessServiceMock.getSessionReturnValue = try self.buildSessionDecoder()
        //Act
        sut.start()
        //Assert
        let rootViewController = try XCTUnwrap(sut.window?.rootViewController as? UINavigationController)
        XCTAssertTrue(rootViewController.children.isEmpty)
    }
    
    func testStart_appCoordinatorContainsChildControllers() throws {
        //Arrange
        let sut = self.buildSUT()
        self.storyboardsManagerMock.controllerReturnValue[.serverConfiguration] = [
            .initial: ServerConfigurationViewControllerMock()
        ]
        self.dependencyContainer.accessServiceMock.getSessionReturnValue = try self.buildSessionDecoder()
        //Act
        sut.start()
        //Assert
        let rootViewController = try XCTUnwrap(sut.window?.rootViewController as? UINavigationController)
        XCTAssertEqual(rootViewController.children.count, 1)
    }
    
    func testStartAppCoordinatorContainsAuthenticationConfigurationCoordinatorOnTheStart() throws {
        //Arrange
        let sut = self.buildSUT()
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = nil
        self.dependencyContainer.accessServiceMock.getSessionReturnValue = try self.buildSessionDecoder()
        //Act
        sut.start()
        //Assert
        XCTAssertNotNil(sut.children.first as? AuthenticationCoordinator)
    }
    
    func testStart_containsServerConfiguration_configurationShouldNotRemeberHost() throws {
        //Arrange
        let sut = self.buildSUT()
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(
            host: self.exampleURL,
            shouldRememberHost: false)
        self.dependencyContainer.accessServiceMock.getSessionReturnValue = try self.buildSessionDecoder()
        //Act
        sut.start()
        //Assert
        XCTAssertNotNil(sut.children.first as? AuthenticationCoordinator)
    }
}

// MARK: - finish()
extension AppCoordinatorTests {
    func testServerConfigurationCoordinatorFinishBlockRunAuthenticatioFlow() throws {
        //Arrange
        let sut = self.buildSUT()
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = nil
        sut.start()
        let serverConfigurationCoordinator = sut.children.first as? AuthenticationCoordinator
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(
            host: self.exampleURL,
            shouldRememberHost: true)
        //Act
        serverConfigurationCoordinator?.finish()
        //Assert
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertNotNil(sut.children.first as? AuthenticationCoordinator)
    }
    
    func testRunMainFlowFinishRemovesTimeTableTabCoordinatorFromChildrenAndRunsServerConfigurationFlow() throws {
        //Arrange
        let sut = self.buildSUT()
        let session = try self.buildSessionDecoder()
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(
            host: self.exampleURL,
            shouldRememberHost: true)
        self.dependencyContainer.accessServiceMock.getSessionReturnValue = session
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
        let session = try self.buildSessionDecoder()
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(
            host: self.exampleURL,
            shouldRememberHost: true)
        self.dependencyContainer.accessServiceMock.getSessionReturnValue = session
        sut.start()
        let child = try XCTUnwrap(sut.children.first as? TimeTableTabCoordinator)
        self.dependencyContainer.accessServiceMock.getSessionThrownError = TestError(message: "Error")
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
            identifier: 1,
            firstName: "John",
            lastName: "Little",
            isLeader: false,
            admin: false,
            manager: false,
            token: "token_abcd")
    }
}
