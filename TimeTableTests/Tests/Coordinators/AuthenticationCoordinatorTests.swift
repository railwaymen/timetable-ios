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
    private var dependencyContainer: DependencyContainerMock!
        
    override func setUp() {
        super.setUp()
        self.navigationController = UINavigationController()
        self.dependencyContainer = DependencyContainerMock()
        self.dependencyContainer.window = UIWindow()
    }
    
    func testStartDoesNotRunServerConfigurationFlowWhileReturnedControllerIsInvalid() {
        //Arrange
        let sut = self.buildSUT()
        self.dependencyContainer.storyboardsManagerMock.controllerReturnValue[.serverConfiguration] = [.initial: UIViewController()]
        //Act
        sut.start(finishCompletion: { (_, _) in })
        //Assert
        XCTAssertTrue(sut.navigationController.children.isEmpty)
    }
    
    func testStartRunsServerConfigurationFlow() {
        //Arrange
        let sut = self.buildSUT()
        self.dependencyContainer.storyboardsManagerMock.controllerReturnValue[.serverConfiguration] = [.initial: ServerConfigurationViewControllerMock()]
        //Act
        sut.start(finishCompletion: { (_, _) in })
        //Assert
        XCTAssertNotNil(sut.navigationController.children[0] as? ServerConfigurationViewControllerable)
    }

    func testStartRunsServerConfigurationFlowWhileServerConfigurationShouldRemeberHostIsFalse() {
        //Arrange
        let sut = self.buildSUT()
        self.dependencyContainer.storyboardsManagerMock.controllerReturnValue[.serverConfiguration] = [.initial: ServerConfigurationViewController()]
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(host: nil, shouldRememberHost: false)
        //Act
        sut.start(finishCompletion: { (_, _) in })
        //Assert
        XCTAssertNotNil(sut.navigationController.children[0] as? ServerConfigurationViewControllerable)
    }
    
    func testStartDoesNotRunAuthenticationFlowWhileServerControllerHasNilHost() throws {
        //Arrange
        let sut = self.buildSUT()
        self.dependencyContainer.storyboardsManagerMock.controllerReturnValue[.serverConfiguration] = [.initial: ServerConfigurationViewControllerMock()]
        self.dependencyContainer.storyboardsManagerMock.controllerReturnValue[.login] = [.initial: LoginViewControllerMock()]
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(host: nil, shouldRememberHost: true)
        //Act
        sut.start(finishCompletion: { (_, _) in })
        self.dependencyContainer.accessServiceMock.getSessionParams.last?.completion(.failure(TestError(message: "ERROR")))
        //Assert
        XCTAssertEqual(sut.navigationController.children.count, 1)
        XCTAssertNotNil(sut.navigationController.children[0] as? ServerConfigurationViewControllerable)
    }
    
    func testStartDoesNotRunAuthenticationFlowWhileServerControllerIsInvalid() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try URL(string: "www.example.com").unwrap()
        self.dependencyContainer.storyboardsManagerMock.controllerReturnValue[.serverConfiguration] = [.initial: UIViewController()]
        self.dependencyContainer.storyboardsManagerMock.controllerReturnValue[.login] = [.initial: UIViewController()]
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(host: url, shouldRememberHost: true)
        //Act
        sut.start(finishCompletion: { (_, _) in })
        self.dependencyContainer.accessServiceMock.getSessionParams.last?.completion(.failure(TestError(message: "ERROR")))
        //Assert
        XCTAssertTrue(sut.navigationController.children.isEmpty)
    }
    
    func testStartDoesNotRunAuthenticationFlowWhileLoginControllerIsInvalid() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try URL(string: "www.example.com").unwrap()
        self.dependencyContainer.storyboardsManagerMock.controllerReturnValue[.serverConfiguration] = [.initial: ServerConfigurationViewControllerMock()]
        self.dependencyContainer.storyboardsManagerMock.controllerReturnValue[.login] = [.initial: UIViewController()]
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(host: url, shouldRememberHost: true)
        //Act
        sut.start(finishCompletion: { (_, _) in })
        self.dependencyContainer.accessServiceMock.getSessionParams.last?.completion(.failure(TestError(message: "ERROR")))
        //Assert
        XCTAssertEqual(sut.navigationController.children.count, 1)
        XCTAssertNotNil(sut.navigationController.children[0] as? ServerConfigurationViewControllerable)
    }
    
    func testStartRunsAuthenticationFlow() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try URL(string: "www.example.com").unwrap()
        self.dependencyContainer.storyboardsManagerMock.controllerReturnValue[.serverConfiguration] = [.initial: ServerConfigurationViewControllerMock()]
        self.dependencyContainer.storyboardsManagerMock.controllerReturnValue[.login] = [.initial: LoginViewControllerMock()]
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(host: url, shouldRememberHost: true)
        //Act
        sut.start(finishCompletion: { (_, _) in })
        self.dependencyContainer.accessServiceMock.getSessionParams.last?.completion(.failure(TestError(message: "ERROR")))
        //Assert
        XCTAssertEqual(sut.navigationController.children.count, 2)
        XCTAssertNotNil(sut.navigationController.children[0] as? ServerConfigurationViewControllerable)
        XCTAssertNotNil(sut.navigationController.children[1] as? LoginViewControllerable)
    }
    
    func testFinishOnStart() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try URL(string: "www.example.com").unwrap()
        self.dependencyContainer.storyboardsManagerMock.controllerReturnValue[.serverConfiguration] = [.initial: ServerConfigurationViewControllerMock()]
        self.dependencyContainer.storyboardsManagerMock.controllerReturnValue[.login] = [.initial: LoginViewControllerMock()]
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(host: url, shouldRememberHost: true)
        let data = try self.json(from: SessionJSONResource.signInResponse)
        let sessionReponse = try self.decoder.decode(SessionDecoder.self, from: data)
        //Act
        sut.start(finishCompletion: { (configuration, apiClient) in
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
        let sut = self.buildSUT()
        let url = try URL(string: "www.example.com").unwrap()
        self.dependencyContainer.storyboardsManagerMock.controllerReturnValue[.serverConfiguration] = [.initial: ServerConfigurationViewControllerMock()]
        self.dependencyContainer.storyboardsManagerMock.controllerReturnValue[.login] = [.initial: LoginViewControllerMock()]
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(host: url, shouldRememberHost: true)
        self.dependencyContainer.accessServiceMock.getSessionParams.last?.completion(.failure(TestError(message: "ERROR")))
        let data = try self.json(from: SessionJSONResource.signInResponse)
        let sessionReponse = try self.decoder.decode(SessionDecoder.self, from: data)
        sut.start(finishCompletion: { (configuration, apiClient) in
            //Assert
            XCTAssertEqual(configuration.host, url)
            XCTAssertEqual(configuration.shouldRememberHost, true)
            XCTAssertEqual(apiClient.networking.headerFields?["token"], "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiJiMDhmODZhZi0zNWRhLTQ4ZjIt")
        })
        //Act
        sut.loginDidFinish(with: .loggedInCorrectly(sessionReponse))
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

// MARK: - Private
extension AuthenticationCoordinatorTests {
    private func buildSUT() -> AuthenticationCoordinator {
        return AuthenticationCoordinator(dependencyContainer: self.dependencyContainer)
    }
}
