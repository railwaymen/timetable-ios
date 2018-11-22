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
    
    private var window: UIWindow?
    private var storyboardsManagerMock: StoryboardsManagerMock!
    private var errorHandlerMock: ErrorHandlerMock!
    private var serverConfigurationManagerMock: ServerConfigurationManagerMock!
    private var appCoordinator: AppCoordinator!
    private var coreDataStackMock: CoreDataStackMock!
    private var bundleMock: BundleMock!
    
    override func setUp() {
        self.window = UIWindow(frame: CGRect.zero)
        self.storyboardsManagerMock = StoryboardsManagerMock()
        self.errorHandlerMock = ErrorHandlerMock()
        self.serverConfigurationManagerMock = ServerConfigurationManagerMock()
        self.coreDataStackMock = CoreDataStackMock()
        self.bundleMock = BundleMock()
        self.appCoordinator = AppCoordinator(window: window,
                                             storyboardsManager: storyboardsManagerMock,
                                             errorHandler: errorHandlerMock,
                                             serverConfigurationManager: serverConfigurationManagerMock,
                                             coreDataStack: coreDataStackMock,
                                             bundle: bundleMock)
        super.setUp()
    }
    
    func testStart_appCoordinatorDoNotContainChildControllers() {
        //Act
        appCoordinator.start()
        //Assert
        XCTAssertTrue(appCoordinator.navigationController.children.isEmpty)
    }
    
    func testStart_appCoordinatorContainsChildControllers() {
        //Arrange
        storyboardsManagerMock.controller = ServerConfigurationViewControllerMock()
        //Act
        appCoordinator.start()
        //Assert
        XCTAssertEqual(appCoordinator.navigationController.children.count, 1)
    }
    
    func testStartAppCoordinatorContainsChildCoordinatorOnTheStart() {
        //Act
        appCoordinator.start()
        //Assert
        XCTAssertEqual(appCoordinator.children.count, 1)
    }
    
    func testStartAppCoordinatorContainsServerConfigurationCoordinatorOnTheStart() {
        //Arrange
        serverConfigurationManagerMock.oldConfiguration = nil
        //Act
        appCoordinator.start()
        //Assert
        XCTAssertNotNil(appCoordinator.children.first?.value as? ServerConfigurationCoordinator)
    }
    
    func testStartAppCoordinatorContainsServerConfigurationCoordinatorOnTheStartWhileConfigurationShouldNotRemeberHost() throws {
        //Arrange
        let url = try URL(string: "www.example.com").unwrap()
        serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: false)
        //Act
        appCoordinator.start()
        //Assert
        XCTAssertNotNil(appCoordinator.children.first?.value as? ServerConfigurationCoordinator)
    }
    
    func testStartAppCoordinatorRunsAuthetincationFlow() throws {
        //Arrange
        let url = try URL(string: "www.example.com").unwrap()
        serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        //Act
        appCoordinator.start()
        //Assert
        XCTAssertNotNil(appCoordinator.children.first?.value as? AuthenticationCoordinator)
    }
    
    func testServerConfigurationCoordinatorFinishBlockRunAuthenticatioFlow() throws {
        //Arrange
        serverConfigurationManagerMock.oldConfiguration = nil
        appCoordinator.start()
        let serverConfigurationCoordinator = appCoordinator.children.first?.value as? ServerConfigurationCoordinator
        let url = try URL(string: "www.example.com").unwrap()
        let serverConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        //Act
        serverConfigurationCoordinator?.finish(with: serverConfiguration)
        //Assert
        XCTAssertEqual(appCoordinator.children.count, 1)
        XCTAssertNotNil(appCoordinator.children.first?.value as? AuthenticationCoordinator)
    }
    
    func testAuthenticationCoordinatorFinishRemoveSelfFromAppCoordinatorChildrenForLoggedInCorrectlyState() throws {
        //Arrange
        let url = try URL(string: "www.example.com").unwrap()
        serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        appCoordinator.start()
        let authenticationCoordinator = appCoordinator.children.first?.value as? AuthenticationCoordinator
        //Act
        authenticationCoordinator?.finish(with: .loggedInCorrectly)
        //Assert
        XCTAssertEqual(appCoordinator.children.count, 1)
        XCTAssertNotNil(appCoordinator.children.first?.value as? TimeTableTabCoordinator)
    }
    
    func testAuthenticationCoordinatorFinishRemoveSelfFromAppCoordinatorChildrenForChangeAddressState() throws {
        //Arrange
        let url = try URL(string: "www.example.com").unwrap()
        serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        appCoordinator.start()
        let authenticationCoordinator = appCoordinator.children.first?.value as? AuthenticationCoordinator
        //Act
        authenticationCoordinator?.finish(with: .changeAddress)
        //Assert
        XCTAssertEqual(appCoordinator.children.count, 1)
        XCTAssertNotNil(appCoordinator.children.first?.value as? ServerConfigurationCoordinator)
    }
    
    func testStartAppCoordinatorDoesNotRunAuthenticationFlowWhileCreatingApiClientWhileHostIsNil() {
        //Arrange
        serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: nil, shouldRememberHost: true)
        //Act
        appCoordinator.start()
        //Assert
        XCTAssertEqual(appCoordinator.children.count, 0)
    }
    
    func testStartAppCoordinatorRunsAuthenticationFlowWithHTTPHost() throws {
        //Arrange
        let url = URL(string: "http://www.example.com")
        serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        //Act
        appCoordinator.start()
        //Assert
        XCTAssertEqual(appCoordinator.children.count, 1)
    }
    
    func testStartAppCoordinatorRunsAuthenticationFlowWithHTTPHosts() throws {
        //Arrange
        let url = URL(string: "https://www.example.com")
        serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        //Act
        appCoordinator.start()
        //Assert
        XCTAssertEqual(appCoordinator.children.count, 1)
    }
    
    func testStartAppCoordinatorDoesNotRunAuthenticationFlowWithBundleIdAndWithoutHostURL() throws {
        //Arrange
        serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: nil, shouldRememberHost: true)
        bundleMock.bundleIdentifier = "org.example.com"
        //Act
        appCoordinator.start()
        //Assert
        XCTAssertEqual(appCoordinator.children.count, 0)
    }
    
    func testStartAppCoordinatorDoesNotRunAuthenticationFlowWithoutBundleIdAndWithoutHostURL() throws {
        //Arrange
        serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: nil, shouldRememberHost: true)
        bundleMock.bundleIdentifier = nil
        //Act
        appCoordinator.start()
        //Assert
        XCTAssertEqual(appCoordinator.children.count, 0)
    }
    
    func testRunMainFlowFinishRemoveTimeTableTabCoordinatorFromChildrenAnRunsServerConfigurationFlow() throws {
        //Arrange
        let key = "key.time_table.login_credentials.key"
        let url = try URL(string: "http://www.example.com").unwrap()
        let keychain = Keychain(server: url, protocolType: .http)
        let credentials = LoginCredentials(email: "user@example.com", password: "password")
        let data = try JSONEncoder().encode(credentials)
        try keychain.set(data, key: key)
        serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        appCoordinator.start()
        let child = try (appCoordinator.children.first?.value as? TimeTableTabCoordinator).unwrap()
        //Act
        serverConfigurationManagerMock.oldConfiguration = nil
        child.finishCompletion?()
        //Assert
        XCTAssertEqual(appCoordinator.children.count, 1)
        XCTAssertNotNil(appCoordinator.children.first?.value as? ServerConfigurationCoordinator)
    }
    
    func testRunMainFlowFinishRemoveTimeTableTabCoordinatorFromChildrenAnRunsServerAuthenticationFlow() throws {
        //Arrange
        let key = "key.time_table.login_credentials.key"
        let url = try URL(string: "http://www.example.com").unwrap()
        let keychain = Keychain(server: url, protocolType: .http)
        let credentials = LoginCredentials(email: "user@example.com", password: "password")
        let data = try JSONEncoder().encode(credentials)
        try keychain.set(data, key: key)
        serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        appCoordinator.start()
        let child = try (appCoordinator.children.first?.value as? TimeTableTabCoordinator).unwrap()
        //Act
        try keychain.remove("key.time_table.login_credentials.key")
        child.finishCompletion?()
        //Assert
        XCTAssertEqual(appCoordinator.children.count, 1)
        XCTAssertNotNil(appCoordinator.children.first?.value as? AuthenticationCoordinator
        )
    }
}
