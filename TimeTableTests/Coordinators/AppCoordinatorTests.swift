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

    private let timeout = 0.1
    private var memoryContext: NSManagedObjectContext!
    private var window: UIWindow?
    private var storyboardsManagerMock: StoryboardsManagerMock!
    private var errorHandlerMock: ErrorHandlerMock!
    private var serverConfigurationManagerMock: ServerConfigurationManagerMock!
    private var appCoordinator: AppCoordinator!
    private var coreDataStackMock: CoreDataStackUserMock!
    private var bundleMock: BundleMock!
    private var keychainAccessMock: KeychainAccessMock!
    private var userDefaultsMock: UserDefaultsMock!
    private var encoderMock: JSONEncoderMock!
    private var decoderMock: JSONDecoderMock!
    
    private enum SessionResponse: String, JSONFileResource {
        case signInResponse
    }
    
    private lazy var decoder = JSONDecoder()
    
    override func setUp() {
        self.window = UIWindow(frame: CGRect.zero)
        self.storyboardsManagerMock = StoryboardsManagerMock()
        self.errorHandlerMock = ErrorHandlerMock()
        self.serverConfigurationManagerMock = ServerConfigurationManagerMock()
        self.coreDataStackMock = CoreDataStackUserMock()
        self.bundleMock = BundleMock()
        self.keychainAccessMock = KeychainAccessMock()
        self.userDefaultsMock = UserDefaultsMock()
        self.encoderMock = JSONEncoderMock()
        self.decoderMock = JSONDecoderMock()
        self.appCoordinator = AppCoordinator(window: window,
                                             storyboardsManager: storyboardsManagerMock,
                                             errorHandler: errorHandlerMock,
                                             serverConfigurationManager: serverConfigurationManagerMock,
                                             coreDataStack: coreDataStackMock,
                                             accessServiceBuilder: { (_, _, _) in
                                                return AccessService(userDefaults: self.userDefaultsMock,
                                                                     keychainAccess: self.keychainAccessMock,
                                                                     coreData: self.coreDataStackMock,
                                                                     buildEncoder: { return self.encoderMock },
                                                                     buildDecoder: { return self.decoderMock })
        })
        super.setUp()
        do {
            memoryContext = try createInMemoryStorage()
        } catch {
            XCTFail()
        }
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
        let data = try self.json(from: SessionResponse.signInResponse)
        let sessionReponse = try decoder.decode(SessionDecoder.self, from: data)
        //Act
        authenticationCoordinator?.finish(with: .loggedInCorrectly(sessionReponse))
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
        let fetchUserExpectation = self.expectation(description: "")
        coreDataStackMock.fetchUserexpectationHandler = fetchUserExpectation.fulfill
        let key = "key.time_table.login_credentials.key"
        let url = try URL(string: "http://www.example.com").unwrap()
        let keychain = Keychain(server: url, protocolType: .http)
        let credentials = LoginCredentials(email: "user@example.com", password: "password")
        let data = try JSONEncoder().encode(credentials)
        try keychain.set(data, key: key)
        userDefaultsMock.objectForKey = Int64(1)
        let user = UserEntity(context: memoryContext)
        user.identifier = 1
        user.token = "token_abcd"
        user.firstName = "John"
        user.lastName = "Little"
        
        serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        appCoordinator.start()
        coreDataStackMock.fetchUserCompletion?(.success(user))
        wait(for: [fetchUserExpectation], timeout: timeout)
        let child = try (appCoordinator.children.first?.value as? TimeTableTabCoordinator).unwrap()
        //Act
        serverConfigurationManagerMock.oldConfiguration = nil
        child.finishCompletion?()
        //Assert
        XCTAssertEqual(appCoordinator.children.count, 1)
        XCTAssertNotNil(appCoordinator.children.first?.value as? ServerConfigurationCoordinator)
    }
    
    func testRunMainFlowFinishRemoveTimeTableTabCoordinatorFromChildrenAnRunsAuthenticationFlow() throws {
        //Arrange
        let fetchUserExpectation = self.expectation(description: "")
        let fetchFailUserExpectation = self.expectation(description: "")
        coreDataStackMock.fetchUserexpectationHandler = fetchUserExpectation.fulfill
        let key = "key.time_table.login_credentials.key"
        let url = try URL(string: "http://www.example.com").unwrap()
        let keychain = Keychain(server: url, protocolType: .http)
        let credentials = LoginCredentials(email: "user@example.com", password: "password")
        let data = try JSONEncoder().encode(credentials)
        try keychain.set(data, key: key)
        userDefaultsMock.objectForKey = Int64(1)
        let user = UserEntity(context: memoryContext)
        user.identifier = 1
        user.token = "token_abcd"
        user.firstName = "John"
        user.lastName = "Little"
        
        serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        appCoordinator.start()
        coreDataStackMock.fetchUserCompletion?(.success(user))
        wait(for: [fetchUserExpectation], timeout: timeout)
        coreDataStackMock.fetchUserexpectationHandler = fetchFailUserExpectation.fulfill
        let child = try (appCoordinator.children.first?.value as? TimeTableTabCoordinator).unwrap()
        //Act
        try keychain.remove("key.time_table.login_credentials.key")
        child.finishCompletion?()
        coreDataStackMock.fetchUserCompletion?(.failure(TestError(message: "Error")))
        wait(for: [fetchFailUserExpectation], timeout: timeout)
        //Assert
        XCTAssertEqual(appCoordinator.children.count, 1)
        XCTAssertNotNil(appCoordinator.children.first?.value as? AuthenticationCoordinator
        )
    }
}
