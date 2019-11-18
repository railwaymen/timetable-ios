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
 
    private var navigationController: UINavigationController!
    private var coordinator: AuthenticationCoordinator!
    private var dependencyContainer: DependencyContainerMock!
    
    private lazy var decoder = JSONDecoder()
    
    override func setUp() {
        super.setUp()
        self.navigationController = UINavigationController()
        self.dependencyContainer = DependencyContainerMock()
        self.dependencyContainer.window = UIWindow()
        self.coordinator = AuthenticationCoordinator(dependencyContainer: self.dependencyContainer)
    }
    
    func testStartDoesNotRunServerConfigurationFlowWhileReturnedControllerIsInvalid() {
        //Arrange
        self.dependencyContainer.storyboardsManagerMock.serverConfigurationController = UIViewController()
        //Act
        self.coordinator.start(finishCompletion: { (_, _) in })
        //Assert
        XCTAssertTrue(self.coordinator.navigationController.children.isEmpty)
    }
    
    func testStartRunsServerConfigurationFlow() {
        //Arrange
        self.dependencyContainer.storyboardsManagerMock.serverConfigurationController = ServerConfigurationViewControllerMock()
        //Act
        self.coordinator.start(finishCompletion: { (_, _) in })
        //Assert
        XCTAssertNotNil(self.coordinator.navigationController.children[0] as? ServerConfigurationViewControllerable)
    }

    func testStartRunsServerConfigurationFlowWhileServerConfigurationShouldRemeberHostIsFalse() {
        //Arrange
        self.dependencyContainer.storyboardsManagerMock.serverConfigurationController = ServerConfigurationViewController()
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(host: nil, shouldRememberHost: false)
        //Act
        self.coordinator.start(finishCompletion: { (_, _) in })
        //Assert
        XCTAssertNotNil(self.coordinator.navigationController.children[0] as? ServerConfigurationViewControllerable)
    }
    
    func testStartDoesNotRunAuthenticationFlowWhileServerControllerHasNilHost() throws {
        //Arrange
        self.dependencyContainer.storyboardsManagerMock.serverConfigurationController = ServerConfigurationViewControllerMock()
        self.dependencyContainer.storyboardsManagerMock.loginController = LoginViewControllerMock()
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(host: nil, shouldRememberHost: true)
        //Act
        self.coordinator.start(finishCompletion: { (_, _) in })
        self.dependencyContainer.accessServiceMock.getSessionParams.last?.completion(.failure(TestError(message: "ERROR")))
        //Assert
        XCTAssertEqual(self.coordinator.navigationController.children.count, 1)
        XCTAssertNotNil(self.coordinator.navigationController.children[0] as? ServerConfigurationViewControllerable)
    }
    
    func testStartDoesNotRunAuthenticationFlowWhileServerControllerIsInvalid() throws {
        //Arrange
        let url = try URL(string: "www.example.com").unwrap()
        self.dependencyContainer.storyboardsManagerMock.serverConfigurationController = UIViewController()
        self.dependencyContainer.storyboardsManagerMock.loginController = UIViewController()
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(host: url, shouldRememberHost: true)
        //Act
        self.coordinator.start(finishCompletion: { (_, _) in })
        self.dependencyContainer.accessServiceMock.getSessionParams.last?.completion(.failure(TestError(message: "ERROR")))
        //Assert
        XCTAssertTrue(self.coordinator.navigationController.children.isEmpty)
    }
    
    func testStartDoesNotRunAuthenticationFlowWhileLoginControllerIsInvalid() throws {
        //Arrange
        let url = try URL(string: "www.example.com").unwrap()
        self.dependencyContainer.storyboardsManagerMock.serverConfigurationController = ServerConfigurationViewControllerMock()
        self.dependencyContainer.storyboardsManagerMock.loginController = UIViewController()
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(host: url, shouldRememberHost: true)
        //Act
        self.coordinator.start(finishCompletion: { (_, _) in })
        self.dependencyContainer.accessServiceMock.getSessionParams.last?.completion(.failure(TestError(message: "ERROR")))
        //Assert
        XCTAssertEqual(self.coordinator.navigationController.children.count, 1)
        XCTAssertNotNil(self.coordinator.navigationController.children[0] as? ServerConfigurationViewControllerable)
    }
    
    func testStartRunsAuthenticationFlow() throws {
        //Arrange
        let url = try URL(string: "www.example.com").unwrap()
        self.dependencyContainer.storyboardsManagerMock.serverConfigurationController = ServerConfigurationViewControllerMock()
        self.dependencyContainer.storyboardsManagerMock.loginController = LoginViewControllerMock()
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(host: url, shouldRememberHost: true)
        //Act
        self.coordinator.start(finishCompletion: { (_, _) in })
        self.dependencyContainer.accessServiceMock.getSessionParams.last?.completion(.failure(TestError(message: "ERROR")))
        //Assert
        XCTAssertEqual(self.coordinator.navigationController.children.count, 2)
        XCTAssertNotNil(self.coordinator.navigationController.children[0] as? ServerConfigurationViewControllerable)
        XCTAssertNotNil(self.coordinator.navigationController.children[1] as? LoginViewControllerable)
    }
    
    func testFinishOnStart() throws {
        //Arrange
        let url = try URL(string: "www.example.com").unwrap()
        self.dependencyContainer.storyboardsManagerMock.serverConfigurationController = ServerConfigurationViewControllerMock()
        self.dependencyContainer.storyboardsManagerMock.loginController = LoginViewControllerMock()
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(host: url, shouldRememberHost: true)
        let data = try self.json(from: SessionJSONResource.signInResponse)
        let sessionReponse = try self.decoder.decode(SessionDecoder.self, from: data)
        //Act
        self.coordinator.start(finishCompletion: { (configuration, apiClient) in
            //Assert
            XCTAssertEqual(configuration.host, url)
            XCTAssertEqual(configuration.shouldRememberHost, true)
            XCTAssertEqual(apiClient.networking.headerFields?["token"], "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiJiMDhmODZhZi0zNWRhLTQ4ZjIt")
        })
        self.dependencyContainer.accessServiceMock.getSessionParams.last?.completion(.success(sessionReponse))
    }

    // MARK: - LoginCoordinatorDelegate
    func testLoginDidFinishWithStateLoggedInCorrectly() throws {
        //Arrange
        let url = try URL(string: "www.example.com").unwrap()
        self.dependencyContainer.storyboardsManagerMock.serverConfigurationController = ServerConfigurationViewControllerMock()
        self.dependencyContainer.storyboardsManagerMock.loginController = LoginViewControllerMock()
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(host: url, shouldRememberHost: true)
        self.dependencyContainer.accessServiceMock.getSessionParams.last?.completion(.failure(TestError(message: "ERROR")))
        let data = try self.json(from: SessionJSONResource.signInResponse)
        let sessionReponse = try self.decoder.decode(SessionDecoder.self, from: data)
        self.coordinator.start(finishCompletion: { (configuration, apiClient) in
            //Assert
            XCTAssertEqual(configuration.host, url)
            XCTAssertEqual(configuration.shouldRememberHost, true)
            XCTAssertEqual(apiClient.networking.headerFields?["token"], "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiJiMDhmODZhZi0zNWRhLTQ4ZjIt")
        })
        //Act
        self.coordinator.loginDidFinish(with: .loggedInCorrectly(sessionReponse))
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
        let data = try self.json(from: SessionJSONResource.signInResponse)
        let sessionReponse = try self.decoder.decode(SessionDecoder.self, from: data)
        //Act
        let firstState = AuthenticationCoordinator.State.changeAddress
        let secoundState = AuthenticationCoordinator.State.loggedInCorrectly(sessionReponse)
        //Assert
        XCTAssertNotEqual(firstState, secoundState)
    }
    
    func testAuthenticationCoordinatorStateEquatableLoggedInCorrectly() throws {
        //Arrange
        let data = try self.json(from: SessionJSONResource.signInResponse)
        let sessionReponse = try self.decoder.decode(SessionDecoder.self, from: data)
        //Act
        let firstState = AuthenticationCoordinator.State.loggedInCorrectly(sessionReponse)
        let secoundState = AuthenticationCoordinator.State.loggedInCorrectly(sessionReponse)
        //Assert
        XCTAssertEqual(firstState, secoundState)
    }
}
