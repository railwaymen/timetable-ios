//
//  AuthenticationCoordinatorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 30/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
import CoreData
@testable import TimeTable

class AuthenticationCoordinatorTests: XCTestCase {
 
    private let timeout = TimeInterval(0.1)
    private var navigationController: UINavigationController!
    private var storyboardsManagerMock: StoryboardsManagerMock!
    private var errorHandlerMock: ErrorHandlerMock!
    private var apiClientMock: ApiClientMock!
    private var coreDataStackMock: CoreDataStackUserMock!
    private var accessServiceMock: AccessServiceMock!
    private var serverConfigurationManagerMock: ServerConfigurationManagerMock!
    private var keychainAccessMock: KeychainAccessMock!
    private var userDefaultsMock: UserDefaultsMock!
    private var encoderMock: JSONEncoderMock!
    private var decoderMock: JSONDecoderMock!
    private var coordinator: AuthenticationCoordinator!
    
    private enum SessionResponse: String, JSONFileResource {
        case signInResponse
    }
    
    private lazy var decoder = JSONDecoder()
    
    override func setUp() {
        self.navigationController = UINavigationController()
        self.storyboardsManagerMock = StoryboardsManagerMock()
        self.errorHandlerMock = ErrorHandlerMock()
        self.apiClientMock = ApiClientMock()
        self.coreDataStackMock = CoreDataStackUserMock()
        self.accessServiceMock = AccessServiceMock()
        self.serverConfigurationManagerMock = ServerConfigurationManagerMock()
        self.coreDataStackMock = CoreDataStackUserMock()
        self.keychainAccessMock = KeychainAccessMock()
        self.userDefaultsMock = UserDefaultsMock()
        self.encoderMock = JSONEncoderMock()
        self.decoderMock = JSONDecoderMock()
        self.coordinator = AuthenticationCoordinator(window: nil,
                                                     storyboardsManager: storyboardsManagerMock,
                                                     decoder: decoderMock,
                                                     encoder: encoderMock,
                                                     accessServiceBuilder: ({ (_, _, _) in return self.accessServiceMock }),
                                                     coreDataStack: coreDataStackMock,
                                                     errorHandler: errorHandlerMock,
                                                     serverConfigurationManager: serverConfigurationManagerMock)
        super.setUp()
    }
    
    func testStartDoesNotRunServerConfigurationFlowWhileReturnedControllerIsInvalid() {
        //Arrange
        storyboardsManagerMock.serverConfigurationController = UIViewController()
        //Act
        coordinator.start(finishCompletion: { (_, _) in })
        //Assert
        XCTAssertTrue(coordinator.navigationController.children.isEmpty)
    }
    
    func testStartRunsServerConfigurationFlow() {
        //Arrange
        storyboardsManagerMock.serverConfigurationController = ServerConfigurationViewControllerMock()
        //Act
        coordinator.start(finishCompletion: { (_, _) in })
        //Assert
        XCTAssertNotNil(coordinator.navigationController.children[0] as? ServerConfigurationViewControlleralbe)
    }

    func testStartRunsServerConfigurationFlowWhileServerConfigurationShouldRemeberHostIsFalse() {
        //Arrange
        storyboardsManagerMock.serverConfigurationController = ServerConfigurationViewController()
        serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: nil, shouldRememberHost: false)
        //Act
        coordinator.start(finishCompletion: { (_, _) in })
        //Assert
        XCTAssertNotNil(coordinator.navigationController.children[0] as? ServerConfigurationViewControlleralbe)
    }
    
    func testStartDoesNotRunAuthenticationFlowWhileServerControllerHasNilHost() throws {
        //Arrange
        storyboardsManagerMock.serverConfigurationController = ServerConfigurationViewControllerMock()
        storyboardsManagerMock.loginController = LoginViewControllerMock()
        serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: nil, shouldRememberHost: true)
        //Act
        coordinator.start(finishCompletion: { (_, _) in })
        accessServiceMock.getSessionCompletion?(.failure(TestError(message: "ERROR")))
        //Assert
        XCTAssertEqual(coordinator.navigationController.children.count, 1)
        XCTAssertNotNil(coordinator.navigationController.children[0] as? ServerConfigurationViewControlleralbe)
    }
    
    func testStartDoesNotRunAuthenticationFlowWhileServerControllerIsInvalid() throws {
        //Arrange
        let url = try URL(string: "www.example.com").unwrap()
        storyboardsManagerMock.serverConfigurationController = UIViewController()
        storyboardsManagerMock.loginController = UIViewController()
        serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        //Act
        coordinator.start(finishCompletion: { (_, _) in })
        accessServiceMock.getSessionCompletion?(.failure(TestError(message: "ERROR")))
        //Assert
        XCTAssertTrue(coordinator.navigationController.children.isEmpty)
    }
    
    func testStartDoesNotRunAuthenticationFlowWhileLoginControllerIsInvalid() throws {
        //Arrange
        let url = try URL(string: "www.example.com").unwrap()
        storyboardsManagerMock.serverConfigurationController = ServerConfigurationViewControllerMock()
        storyboardsManagerMock.loginController = UIViewController()
        serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        //Act
        coordinator.start(finishCompletion: { (_, _) in })
        accessServiceMock.getSessionCompletion?(.failure(TestError(message: "ERROR")))
        //Assert
        XCTAssertEqual(coordinator.navigationController.children.count, 1)
        XCTAssertNotNil(coordinator.navigationController.children[0] as? ServerConfigurationViewControlleralbe)
    }
    
    func testStartRunsAuthenticationFlow() throws {
        //Arrange
        let url = try URL(string: "www.example.com").unwrap()
        storyboardsManagerMock.serverConfigurationController = ServerConfigurationViewControllerMock()
        storyboardsManagerMock.loginController = LoginViewControllerMock()
        serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        //Act
        coordinator.start(finishCompletion: { (_, _) in })
        accessServiceMock.getSessionCompletion?(.failure(TestError(message: "ERROR")))
        //Assert
        XCTAssertEqual(coordinator.navigationController.children.count, 2)
        XCTAssertNotNil(coordinator.navigationController.children[0] as? ServerConfigurationViewControlleralbe)
        XCTAssertNotNil(coordinator.navigationController.children[1] as? LoginViewControllerable)
    }
    
    func testFinishOnStart() throws {
        //Arrange
        let url = try URL(string: "www.example.com").unwrap()
        storyboardsManagerMock.serverConfigurationController = ServerConfigurationViewControllerMock()
        storyboardsManagerMock.loginController = LoginViewControllerMock()
        serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        let data = try self.json(from: SessionResponse.signInResponse)
        let sessionReponse = try decoder.decode(SessionDecoder.self, from: data)
        
        //Act
        coordinator.start(finishCompletion: { (configuration, apiClient) in
            //Assert
            XCTAssertEqual(configuration.host, url)
            XCTAssertEqual(configuration.shouldRememberHost, true)
            XCTAssertEqual(apiClient.networking.headerFields?["token"], "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiJiMDhmODZhZi0zNWRhLTQ4ZjIt")
        })
        accessServiceMock.getSessionCompletion?(.success(sessionReponse))
    }
    
    // MARK: - ServerConfigurationCoordinatorDelagete
    func testServerConfigurationDidFinishRunsAuthenticationFlow() throws {
        //Arrange
        storyboardsManagerMock.serverConfigurationController = ServerConfigurationViewControllerMock()
        storyboardsManagerMock.loginController = LoginViewControllerMock()
        coordinator.start(finishCompletion: { (_, _) in })
        let url = try URL(string: "www.example.com").unwrap()
        let configuration = ServerConfiguration(host: url, shouldRememberHost: true)
        //Act
        XCTAssertEqual(coordinator.navigationController.children.count, 1)
        XCTAssertNotNil(coordinator.navigationController.children[0] as? ServerConfigurationViewControlleralbe)
        coordinator.serverConfigurationDidFinish(with: configuration)
        //Assert
        DispatchQueue.main.async {
            XCTAssertEqual(self.coordinator.navigationController.children.count, 2)
            XCTAssertNotNil(self.coordinator.navigationController.children[0] as? ServerConfigurationViewControlleralbe)
            XCTAssertNotNil(self.coordinator.navigationController.children[1] as? LoginViewControllerable)
        }
    }
    
    // MARK: - LoginCoordinatorDelegate
    func testLoginDidFinishWithStateChangeAddress() throws {
        //Arrange
        let url = try URL(string: "www.example.com").unwrap()
        storyboardsManagerMock.serverConfigurationController = ServerConfigurationViewControllerMock()
        storyboardsManagerMock.loginController = LoginViewControllerMock()
        serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        coordinator.start(finishCompletion: { (_, _) in })
        accessServiceMock.getSessionCompletion?(.failure(TestError(message: "ERROR")))
        //Act
        coordinator.loginDidFinish(with: .changeAddress)
        //Assert
        DispatchQueue.main.async {
            XCTAssertEqual(self.coordinator.navigationController.children.count, 1)
            XCTAssertNotNil(self.coordinator.navigationController.children[0] as? ServerConfigurationViewControlleralbe)
        }
    }
    
    func testLoginDidFinishWithStateLoggedInCorrectly() throws {
        //Arrange
        let url = try URL(string: "www.example.com").unwrap()
        storyboardsManagerMock.serverConfigurationController = ServerConfigurationViewControllerMock()
        storyboardsManagerMock.loginController = LoginViewControllerMock()
        serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        accessServiceMock.getSessionCompletion?(.failure(TestError(message: "ERROR")))
        let data = try self.json(from: SessionResponse.signInResponse)
        let sessionReponse = try decoder.decode(SessionDecoder.self, from: data)
        coordinator.start(finishCompletion: { (configuration, apiClient) in
            //Assert
            XCTAssertEqual(configuration.host, url)
            XCTAssertEqual(configuration.shouldRememberHost, true)
            XCTAssertEqual(apiClient.networking.headerFields?["token"], "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiJiMDhmODZhZi0zNWRhLTQ4ZjIt")
        })
        //Act
        coordinator.loginDidFinish(with: .loggedInCorrectly(sessionReponse))
    }
    
    // MARK: - State Equatable
    func testAuthenticationCoordinatorStateEquatableChangeAddress() {
        //Act
        let firstState = AuthenticationCoordinator.State.changeAddress
        let secoundState = AuthenticationCoordinator.State.changeAddress
        //Assert
        XCTAssertEqual(firstState, secoundState)
    }
    
    func testAuthenticationCoordinatorStateNotEquatableChangeAddressAndLoggedInCorrectly() throws {
        //Arrange
        let data = try self.json(from: SessionResponse.signInResponse)
        let sessionReponse = try decoder.decode(SessionDecoder.self, from: data)
        //Act
        let firstState = AuthenticationCoordinator.State.changeAddress
        let secoundState = AuthenticationCoordinator.State.loggedInCorrectly(sessionReponse)
        //Assert
        XCTAssertNotEqual(firstState, secoundState)
    }
    
    func testAuthenticationCoordinatorStateEquatableLoggedInCorrectly() throws {
        //Arrange
        let data = try self.json(from: SessionResponse.signInResponse)
        let sessionReponse = try decoder.decode(SessionDecoder.self, from: data)
        //Act
        let firstState = AuthenticationCoordinator.State.loggedInCorrectly(sessionReponse)
        let secoundState = AuthenticationCoordinator.State.loggedInCorrectly(sessionReponse)
        //Assert
        XCTAssertEqual(firstState, secoundState)
    }
}
