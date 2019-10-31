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
    
    private enum SessionResponse: String, JSONFileResource {
        case signInResponse
    }
        
    override func setUp() {
        dependencyContainer = DependencyContainerMock()
        dependencyContainer.window = UIWindow()
        appCoordinator = AppCoordinator(dependencyContainer: dependencyContainer)
        super.setUp()
        do {
            memoryContext = try createInMemoryStorage()
        } catch {
            XCTFail()
        }
    }
    
    func testStart_appCoordinatorDoNotContainChildControllers() throws {
        //Act
        appCoordinator.start()
        //Assert
        let rootViewController = try (appCoordinator.window?.rootViewController as? UINavigationController).unwrap()
        XCTAssertTrue(rootViewController.children.isEmpty)
    }
    
    func testStart_appCoordinatorContainsChildControllers() throws {
        //Arrange
        dependencyContainer.storyboardsManagerMock.serverConfigurationController = ServerConfigurationViewControllerMock()
        //Act
        appCoordinator.start()
        //Assert
        let rootViewController = try (appCoordinator.window?.rootViewController as? UINavigationController).unwrap()
        XCTAssertEqual(rootViewController.children.count, 1)
    }
    
    func testStartAppCoordinatorContainsAuthenticationConfigurationCoordinatorOnTheStart() {
        //Arrange
        dependencyContainer.serverConfigurationManagerMock.oldConfiguration = nil
        //Act
        appCoordinator.start()
        //Assert
        XCTAssertNotNil(appCoordinator.children.first as? AuthenticationCoordinator)
    }
    
    func testStartAppCoordinatorContainsServerConfigurationCoordinatorOnTheStartWhileConfigurationShouldNotRemeberHost() throws {
        //Arrange
        let url = try URL(string: "www.example.com").unwrap()
        dependencyContainer.serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: false)
        //Act
        appCoordinator.start()
        //Assert
        XCTAssertNotNil(appCoordinator.children.first as? AuthenticationCoordinator)
    }
    
    func testStartAppCoordinatorRunsAuthetincationFlow() throws {
        //Arrange
        let url = try URL(string: "www.example.com").unwrap()
        dependencyContainer.serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        
        //Act
        appCoordinator.start()
        //Assert
        XCTAssertNotNil(appCoordinator.children.first as? AuthenticationCoordinator)
    }
    
    func testServerConfigurationCoordinatorFinishBlockRunAuthenticatioFlow() throws {
        //Arrange
        dependencyContainer.serverConfigurationManagerMock.oldConfiguration = nil
        appCoordinator.start()
        let serverConfigurationCoordinator = appCoordinator.children.first as? AuthenticationCoordinator
        let url = try URL(string: "www.example.com").unwrap()
        dependencyContainer.serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        //Act
        serverConfigurationCoordinator?.finish()
        //Assert
        XCTAssertEqual(appCoordinator.children.count, 1)
        XCTAssertNotNil(appCoordinator.children.first as? AuthenticationCoordinator)
    }

    func testAuthenticationCoordinatorFinishRemoveSelfFromAppCoordinatorChildrenForChangeAddressState() throws {
        //Arrange
        let url = try URL(string: "www.example.com").unwrap()
        dependencyContainer.serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        appCoordinator.start()
        let authenticationCoordinator = appCoordinator.children.first as? AuthenticationCoordinator
        //Act
        authenticationCoordinator?.finish()
        //Assert
        XCTAssertEqual(appCoordinator.children.count, 1)
        XCTAssertNotNil(appCoordinator.children.first as? AuthenticationCoordinator)
    }
    
    func testStartAppCoordinatorRunsAuthenticationFlowWithHTTPHost() throws {
        //Arrange
        let url = URL(string: "http://www.example.com")
        dependencyContainer.serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        //Act
        appCoordinator.start()
        //Assert
        XCTAssertEqual(appCoordinator.children.count, 1)
    }
    
    func testStartAppCoordinatorRunsAuthenticationFlowWithHTTPHosts() throws {
        //Arrange
        let url = URL(string: "https://www.example.com")
        dependencyContainer.serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        //Act
        appCoordinator.start()
        //Assert
        XCTAssertEqual(appCoordinator.children.count, 1)
    }
    
    func testRunMainFlowFinishRemoveTimeTableTabCoordinatorFromChildrenAndRunsServerConfigurationFlow() throws {
        //Arrange
        let url = try URL(string: "http://www.example.com").unwrap()
        let user = UserEntity(context: memoryContext)
        user.identifier = 1
        user.token = "token_abcd"
        user.firstName = "John"
        user.lastName = "Little"
        
        dependencyContainer.serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        appCoordinator.start()
        dependencyContainer.accessServiceMock.getSessionCompletion?(.success(SessionDecoder(entity: user)))
        let child = try (appCoordinator.children.first as? TimeTableTabCoordinator).unwrap()
        //Act
        dependencyContainer.serverConfigurationManagerMock.oldConfiguration = nil
        child.finishCompletion?()
        //Assert
        XCTAssertEqual(appCoordinator.children.count, 1)
        XCTAssertNotNil(appCoordinator.children.first as? AuthenticationCoordinator)
    }
    
    func testRunMainFlowFinishRemoveTimeTableTabCoordinatorFromChildrenAndRunsAuthenticationFlow() throws {
        //Arrange
        let url = try URL(string: "http://www.example.com").unwrap()
        let user = UserEntity(context: memoryContext)
        user.identifier = 1
        user.token = "token_abcd"
        user.firstName = "John"
        user.lastName = "Little"
        
        dependencyContainer.serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        appCoordinator.start()
        dependencyContainer.accessServiceMock.getSessionCompletion?(.success(SessionDecoder(entity: user)))
        let child = try (appCoordinator.children.first as? TimeTableTabCoordinator).unwrap()
        //Act
        child.finishCompletion?()
        dependencyContainer.accessServiceMock.getSessionCompletion?(.failure(TestError(message: "Error")))
        //Assert
        XCTAssertEqual(appCoordinator.children.count, 1)
        XCTAssertNotNil(appCoordinator.children.first as? AuthenticationCoordinator
        )
    }
}
