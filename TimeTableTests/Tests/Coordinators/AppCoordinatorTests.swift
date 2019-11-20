//
//  AppCoordinatorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 25/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
import KeychainAccess
import CoreData
@testable import TimeTable

class AppCoordinatorTests: XCTestCase {
    private var memoryContext: NSManagedObjectContext!
    private var dependencyContainer: DependencyContainerMock!
    
    override func setUp() {
        super.setUp()
        self.dependencyContainer = DependencyContainerMock()
        self.dependencyContainer.window = UIWindow()
        do {
            self.memoryContext = try self.createInMemoryStorage()
        } catch {
            XCTFail()
        }
    }
    
    func testStart_appCoordinatorDoNotContainChildControllers() throws {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.start()
        //Assert
        let rootViewController = try (sut.window?.rootViewController as? UINavigationController).unwrap()
        XCTAssertTrue(rootViewController.children.isEmpty)
    }
    
    func testStart_appCoordinatorContainsChildControllers() throws {
        //Arrange
        let sut = self.buildSUT()
        self.dependencyContainer.storyboardsManagerMock.controllerReturnValue[.serverConfiguration] = [.initial: ServerConfigurationViewControllerMock()]
        //Act
        sut.start()
        //Assert
        let rootViewController = try (sut.window?.rootViewController as? UINavigationController).unwrap()
        XCTAssertEqual(rootViewController.children.count, 1)
    }
    
    func testStartAppCoordinatorContainsAuthenticationConfigurationCoordinatorOnTheStart() {
        //Arrange
        let sut = self.buildSUT()
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = nil
        //Act
        sut.start()
        //Assert
        XCTAssertNotNil(sut.children.first as? AuthenticationCoordinator)
    }
    
    func testStartAppCoordinatorContainsServerConfigurationCoordinatorOnTheStartWhileConfigurationShouldNotRemeberHost() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try URL(string: "www.example.com").unwrap()
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(host: url, shouldRememberHost: false)
        //Act
        sut.start()
        //Assert
        XCTAssertNotNil(sut.children.first as? AuthenticationCoordinator)
    }
    
    func testStartAppCoordinatorRunsAuthetincationFlow() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try URL(string: "www.example.com").unwrap()
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(host: url, shouldRememberHost: true)
        //Act
        sut.start()
        //Assert
        XCTAssertNotNil(sut.children.first as? AuthenticationCoordinator)
    }
    
    func testServerConfigurationCoordinatorFinishBlockRunAuthenticatioFlow() throws {
        //Arrange
        let sut = self.buildSUT()
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = nil
        sut.start()
        let serverConfigurationCoordinator = sut.children.first as? AuthenticationCoordinator
        let url = try URL(string: "www.example.com").unwrap()
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(host: url, shouldRememberHost: true)
        //Act
        serverConfigurationCoordinator?.finish()
        //Assert
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertNotNil(sut.children.first as? AuthenticationCoordinator)
    }

    func testAuthenticationCoordinatorFinishRemoveSelfFromAppCoordinatorChildrenForChangeAddressState() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try URL(string: "www.example.com").unwrap()
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(host: url, shouldRememberHost: true)
        sut.start()
        let authenticationCoordinator = sut.children.first as? AuthenticationCoordinator
        //Act
        authenticationCoordinator?.finish()
        //Assert
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertNotNil(sut.children.first as? AuthenticationCoordinator)
    }
    
    func testStartAppCoordinatorRunsAuthenticationFlowWithHTTPHost() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = URL(string: "http://www.example.com")
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(host: url, shouldRememberHost: true)
        //Act
        sut.start()
        //Assert
        XCTAssertEqual(sut.children.count, 1)
    }
    
    func testStartAppCoordinatorRunsAuthenticationFlowWithHTTPHosts() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = URL(string: "https://www.example.com")
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(host: url, shouldRememberHost: true)
        //Act
        sut.start()
        //Assert
        XCTAssertEqual(sut.children.count, 1)
    }
    
    func testRunMainFlowFinishRemoveTimeTableTabCoordinatorFromChildrenAndRunsServerConfigurationFlow() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try URL(string: "http://www.example.com").unwrap()
        let user = UserEntity(context: self.memoryContext)
        user.identifier = 1
        user.token = "token_abcd"
        user.firstName = "John"
        user.lastName = "Little"
        
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(host: url, shouldRememberHost: true)
        sut.start()
        self.dependencyContainer.accessServiceMock.getSessionParams.last?.completion(.success(SessionDecoder(entity: user)))
        let child = try (sut.children.first as? TimeTableTabCoordinator).unwrap()
        //Act
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = nil
        child.finishCompletion?()
        //Assert
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertNotNil(sut.children.first as? AuthenticationCoordinator)
    }
    
    func testRunMainFlowFinishRemoveTimeTableTabCoordinatorFromChildrenAndRunsAuthenticationFlow() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try URL(string: "http://www.example.com").unwrap()
        let user = UserEntity(context: self.memoryContext)
        user.identifier = 1
        user.token = "token_abcd"
        user.firstName = "John"
        user.lastName = "Little"
        
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(host: url, shouldRememberHost: true)
        sut.start()
        self.dependencyContainer.accessServiceMock.getSessionParams.last?.completion(.success(SessionDecoder(entity: user)))
        let child = try (sut.children.first as? TimeTableTabCoordinator).unwrap()
        //Act
        child.finishCompletion?()
        self.dependencyContainer.accessServiceMock.getSessionParams.last?.completion(.failure(TestError(message: "Error")))
        //Assert
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertNotNil(sut.children.first as? AuthenticationCoordinator
        )
    }
}

// MARK: - Private
extension AppCoordinatorTests {
    private func buildSUT() -> AppCoordinator {
        return AppCoordinator(dependencyContainer: self.dependencyContainer)
    }
}
