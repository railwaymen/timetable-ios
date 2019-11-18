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
    private var appCoordinator: AppCoordinator!
    
    override func setUp() {
        super.setUp()
        self.dependencyContainer = DependencyContainerMock()
        self.dependencyContainer.window = UIWindow()
        self.appCoordinator = AppCoordinator(dependencyContainer: self.dependencyContainer)
        do {
            self.memoryContext = try self.createInMemoryStorage()
        } catch {
            XCTFail()
        }
    }
    
    func testStart_appCoordinatorDoNotContainChildControllers() throws {
        //Act
        self.appCoordinator.start()
        //Assert
        let rootViewController = try (self.appCoordinator.window?.rootViewController as? UINavigationController).unwrap()
        XCTAssertTrue(rootViewController.children.isEmpty)
    }
    
    func testStart_appCoordinatorContainsChildControllers() throws {
        //Arrange
        self.dependencyContainer.storyboardsManagerMock.serverConfigurationController = ServerConfigurationViewControllerMock()
        //Act
        self.appCoordinator.start()
        //Assert
        let rootViewController = try (self.appCoordinator.window?.rootViewController as? UINavigationController).unwrap()
        XCTAssertEqual(rootViewController.children.count, 1)
    }
    
    func testStartAppCoordinatorContainsAuthenticationConfigurationCoordinatorOnTheStart() {
        //Arrange
        self.dependencyContainer.serverConfigurationManagerMock.oldConfiguration = nil
        //Act
        self.appCoordinator.start()
        //Assert
        XCTAssertNotNil(self.appCoordinator.children.first as? AuthenticationCoordinator)
    }
    
    func testStartAppCoordinatorContainsServerConfigurationCoordinatorOnTheStartWhileConfigurationShouldNotRemeberHost() throws {
        //Arrange
        let url = try URL(string: "www.example.com").unwrap()
        self.dependencyContainer.serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: false)
        //Act
        self.appCoordinator.start()
        //Assert
        XCTAssertNotNil(self.appCoordinator.children.first as? AuthenticationCoordinator)
    }
    
    func testStartAppCoordinatorRunsAuthetincationFlow() throws {
        //Arrange
        let url = try URL(string: "www.example.com").unwrap()
        self.dependencyContainer.serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        //Act
        self.appCoordinator.start()
        //Assert
        XCTAssertNotNil(self.appCoordinator.children.first as? AuthenticationCoordinator)
    }
    
    func testServerConfigurationCoordinatorFinishBlockRunAuthenticatioFlow() throws {
        //Arrange
        self.dependencyContainer.serverConfigurationManagerMock.oldConfiguration = nil
        self.appCoordinator.start()
        let serverConfigurationCoordinator = self.appCoordinator.children.first as? AuthenticationCoordinator
        let url = try URL(string: "www.example.com").unwrap()
        self.dependencyContainer.serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        //Act
        serverConfigurationCoordinator?.finish()
        //Assert
        XCTAssertEqual(self.appCoordinator.children.count, 1)
        XCTAssertNotNil(self.appCoordinator.children.first as? AuthenticationCoordinator)
    }

    func testAuthenticationCoordinatorFinishRemoveSelfFromAppCoordinatorChildrenForChangeAddressState() throws {
        //Arrange
        let url = try URL(string: "www.example.com").unwrap()
        self.dependencyContainer.serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        self.appCoordinator.start()
        let authenticationCoordinator = self.appCoordinator.children.first as? AuthenticationCoordinator
        //Act
        authenticationCoordinator?.finish()
        //Assert
        XCTAssertEqual(self.appCoordinator.children.count, 1)
        XCTAssertNotNil(self.appCoordinator.children.first as? AuthenticationCoordinator)
    }
    
    func testStartAppCoordinatorRunsAuthenticationFlowWithHTTPHost() throws {
        //Arrange
        let url = URL(string: "http://www.example.com")
        self.dependencyContainer.serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        //Act
        self.appCoordinator.start()
        //Assert
        XCTAssertEqual(self.appCoordinator.children.count, 1)
    }
    
    func testStartAppCoordinatorRunsAuthenticationFlowWithHTTPHosts() throws {
        //Arrange
        let url = URL(string: "https://www.example.com")
        self.dependencyContainer.serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        //Act
        self.appCoordinator.start()
        //Assert
        XCTAssertEqual(self.appCoordinator.children.count, 1)
    }
    
    func testRunMainFlowFinishRemoveTimeTableTabCoordinatorFromChildrenAndRunsServerConfigurationFlow() throws {
        //Arrange
        let url = try URL(string: "http://www.example.com").unwrap()
        let user = UserEntity(context: self.memoryContext)
        user.identifier = 1
        user.token = "token_abcd"
        user.firstName = "John"
        user.lastName = "Little"
        
        self.dependencyContainer.serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        self.appCoordinator.start()
        self.dependencyContainer.accessServiceMock.getSessionParams.last?.completion(.success(SessionDecoder(entity: user)))
        let child = try (self.appCoordinator.children.first as? TimeTableTabCoordinator).unwrap()
        //Act
        self.dependencyContainer.serverConfigurationManagerMock.oldConfiguration = nil
        child.finishCompletion?()
        //Assert
        XCTAssertEqual(self.appCoordinator.children.count, 1)
        XCTAssertNotNil(self.appCoordinator.children.first as? AuthenticationCoordinator)
    }
    
    func testRunMainFlowFinishRemoveTimeTableTabCoordinatorFromChildrenAndRunsAuthenticationFlow() throws {
        //Arrange
        let url = try URL(string: "http://www.example.com").unwrap()
        let user = UserEntity(context: self.memoryContext)
        user.identifier = 1
        user.token = "token_abcd"
        user.firstName = "John"
        user.lastName = "Little"
        
        self.dependencyContainer.serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        self.appCoordinator.start()
        self.dependencyContainer.accessServiceMock.getSessionParams.last?.completion(.success(SessionDecoder(entity: user)))
        let child = try (self.appCoordinator.children.first as? TimeTableTabCoordinator).unwrap()
        //Act
        child.finishCompletion?()
        self.dependencyContainer.accessServiceMock.getSessionParams.last?.completion(.failure(TestError(message: "Error")))
        //Assert
        XCTAssertEqual(self.appCoordinator.children.count, 1)
        XCTAssertNotNil(self.appCoordinator.children.first as? AuthenticationCoordinator
        )
    }
}
