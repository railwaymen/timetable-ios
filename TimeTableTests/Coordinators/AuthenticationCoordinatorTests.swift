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
    private var coordinator: AuthenticationCoordinator!
    private var dependencyContainer: DependencyContainerMock!
    
    private enum SessionResponse: String, JSONFileResource {
        case signInResponse
    }
    
    private lazy var decoder = JSONDecoder()
    
    override func setUp() {
        navigationController = UINavigationController()
        dependencyContainer = DependencyContainerMock()
        dependencyContainer.window = UIWindow()
        coordinator = AuthenticationCoordinator(dependencyContainer: dependencyContainer)
        super.setUp()
    }
    
    func testStartDoesNotRunServerConfigurationFlowWhileReturnedControllerIsInvalid() {
        //Arrange
        dependencyContainer.storyboardsManagerMock.serverConfigurationController = UIViewController()
        //Act
        coordinator.start(finishCompletion: { (_, _) in })
        //Assert
        XCTAssertTrue(coordinator.navigationController.children.isEmpty)
    }
    
    func testStartRunsServerConfigurationFlow() {
        //Arrange
        dependencyContainer.storyboardsManagerMock.serverConfigurationController = ServerConfigurationViewControllerMock()
        //Act
        coordinator.start(finishCompletion: { (_, _) in })
        //Assert
        XCTAssertNotNil(coordinator.navigationController.children[0] as? ServerConfigurationViewControllerable)
    }

    func testStartRunsServerConfigurationFlowWhileServerConfigurationShouldRemeberHostIsFalse() {
        //Arrange
        dependencyContainer.storyboardsManagerMock.serverConfigurationController = ServerConfigurationViewController()
        dependencyContainer.serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: nil, shouldRememberHost: false)
        //Act
        coordinator.start(finishCompletion: { (_, _) in })
        //Assert
        XCTAssertNotNil(coordinator.navigationController.children[0] as? ServerConfigurationViewControllerable)
    }
    
    func testStartDoesNotRunAuthenticationFlowWhileServerControllerHasNilHost() throws {
        //Arrange
        dependencyContainer.storyboardsManagerMock.serverConfigurationController = ServerConfigurationViewControllerMock()
        dependencyContainer.storyboardsManagerMock.loginController = LoginViewControllerMock()
        dependencyContainer.serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: nil, shouldRememberHost: true)
        //Act
        coordinator.start(finishCompletion: { (_, _) in })
        dependencyContainer.accessServiceMock.getSessionCompletion?(.failure(TestError(message: "ERROR")))
        //Assert
        XCTAssertEqual(coordinator.navigationController.children.count, 1)
        XCTAssertNotNil(coordinator.navigationController.children[0] as? ServerConfigurationViewControllerable)
    }
    
    func testStartDoesNotRunAuthenticationFlowWhileServerControllerIsInvalid() throws {
        //Arrange
        let url = try URL(string: "www.example.com").unwrap()
        dependencyContainer.storyboardsManagerMock.serverConfigurationController = UIViewController()
        dependencyContainer.storyboardsManagerMock.loginController = UIViewController()
        dependencyContainer.serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        //Act
        coordinator.start(finishCompletion: { (_, _) in })
        dependencyContainer.accessServiceMock.getSessionCompletion?(.failure(TestError(message: "ERROR")))
        //Assert
        XCTAssertTrue(coordinator.navigationController.children.isEmpty)
    }
    
    func testStartDoesNotRunAuthenticationFlowWhileLoginControllerIsInvalid() throws {
        //Arrange
        let url = try URL(string: "www.example.com").unwrap()
        dependencyContainer.storyboardsManagerMock.serverConfigurationController = ServerConfigurationViewControllerMock()
        dependencyContainer.storyboardsManagerMock.loginController = UIViewController()
        dependencyContainer.serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        //Act
        coordinator.start(finishCompletion: { (_, _) in })
        dependencyContainer.accessServiceMock.getSessionCompletion?(.failure(TestError(message: "ERROR")))
        //Assert
        XCTAssertEqual(coordinator.navigationController.children.count, 1)
        XCTAssertNotNil(coordinator.navigationController.children[0] as? ServerConfigurationViewControllerable)
    }
    
    func testStartRunsAuthenticationFlow() throws {
        //Arrange
        let url = try URL(string: "www.example.com").unwrap()
        dependencyContainer.storyboardsManagerMock.serverConfigurationController = ServerConfigurationViewControllerMock()
        dependencyContainer.storyboardsManagerMock.loginController = LoginViewControllerMock()
        dependencyContainer.serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        //Act
        coordinator.start(finishCompletion: { (_, _) in })
        dependencyContainer.accessServiceMock.getSessionCompletion?(.failure(TestError(message: "ERROR")))
        //Assert
        XCTAssertEqual(coordinator.navigationController.children.count, 2)
        XCTAssertNotNil(coordinator.navigationController.children[0] as? ServerConfigurationViewControllerable)
        XCTAssertNotNil(coordinator.navigationController.children[1] as? LoginViewControllerable)
    }
    
    func testFinishOnStart() throws {
        //Arrange
        let url = try URL(string: "www.example.com").unwrap()
        dependencyContainer.storyboardsManagerMock.serverConfigurationController = ServerConfigurationViewControllerMock()
        dependencyContainer.storyboardsManagerMock.loginController = LoginViewControllerMock()
        dependencyContainer.serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        let data = try self.json(from: SessionResponse.signInResponse)
        let sessionReponse = try decoder.decode(SessionDecoder.self, from: data)
        
        //Act
        coordinator.start(finishCompletion: { (configuration, apiClient) in
            //Assert
            XCTAssertEqual(configuration.host, url)
            XCTAssertEqual(configuration.shouldRememberHost, true)
            XCTAssertEqual(apiClient.networking.headerFields?["token"], "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiJiMDhmODZhZi0zNWRhLTQ4ZjIt")
        })
        dependencyContainer.accessServiceMock.getSessionCompletion?(.success(sessionReponse))
    }

    // MARK: - LoginCoordinatorDelegate
    func testLoginDidFinishWithStateLoggedInCorrectly() throws {
        //ERROR: Completion handler needs multithreading
        //Arrange
        let url = try URL(string: "www.example.com").unwrap()
        dependencyContainer.storyboardsManagerMock.serverConfigurationController = ServerConfigurationViewControllerMock()
        dependencyContainer.storyboardsManagerMock.loginController = LoginViewControllerMock()
        dependencyContainer.serverConfigurationManagerMock.oldConfiguration = ServerConfiguration(host: url, shouldRememberHost: true)
        dependencyContainer.accessServiceMock.getSessionCompletion?(.failure(TestError(message: "ERROR")))
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
