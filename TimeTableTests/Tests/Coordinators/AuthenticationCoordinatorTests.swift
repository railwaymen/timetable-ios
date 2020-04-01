//
//  AuthenticationCoordinatorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 30/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class AuthenticationCoordinatorTests: XCTestCase {
    private var navigationController: UINavigationController!
    private var dependencyContainer: DependencyContainerMock!
    
    private var storyboardsManagerMock: StoryboardsManagerMock {
        self.dependencyContainer.storyboardsManagerMock
    }
        
    override func setUp() {
        super.setUp()
        self.navigationController = UINavigationController()
        self.dependencyContainer = DependencyContainerMock()
        self.dependencyContainer.window = UIWindow()
    }
}

// MARK: - start(finishCompletion: ((ServerConfiguration, ApiClientType) -> Void)?)
extension AuthenticationCoordinatorTests {
    func testStartDoesNotRunServerConfigurationFlowWhileReturnedControllerIsInvalid() {
        //Arrange
        let sut = self.buildSUT()
        self.storyboardsManagerMock.controllerReturnValue[.serverConfiguration] = [.initial: UIViewController()]
        //Act
        sut.start { (_, _) in }
        //Assert
        XCTAssertTrue(sut.navigationController.children.isEmpty)
    }
    
    func testStartRunsServerConfigurationFlow() {
        //Arrange
        let sut = self.buildSUT()
        self.storyboardsManagerMock.controllerReturnValue[.serverConfiguration] = [
            .initial: ServerConfigurationViewControllerMock()
        ]
        //Act
        sut.start { (_, _) in }
        //Assert
        XCTAssertNotNil(sut.navigationController.children[0] as? ServerConfigurationViewControllerable)
    }

    func testStartRunsServerConfigurationFlowWhileServerConfigurationShouldRemeberHostIsFalse() {
        //Arrange
        let sut = self.buildSUT()
        let vcMock = ServerConfigurationViewControllerMock()
        self.storyboardsManagerMock.controllerReturnValue[.serverConfiguration] = [.initial: vcMock]
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(
            host: nil,
            shouldRememberHost: false)
        //Act
        sut.start { (_, _) in }
        //Assert
        XCTAssertNotNil(sut.navigationController.children[0] as? ServerConfigurationViewControllerable)
    }
    
    func testStartDoesNotRunAuthenticationFlowWhileServerControllerHasNilHost() throws {
        //Arrange
        let sut = self.buildSUT()
        let serverConfigurationVCMock = ServerConfigurationViewControllerMock()
        let loginVCMock = LoginViewControllerMock()
        let serverConfiguration = ServerConfiguration(host: nil, shouldRememberHost: true)
        self.storyboardsManagerMock.controllerReturnValue[.serverConfiguration] = [.initial: serverConfigurationVCMock]
        self.storyboardsManagerMock.controllerReturnValue[.login] = [.initial: loginVCMock]
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = serverConfiguration
        self.dependencyContainer.accessServiceMock.getSessionThrownError = TestError(message: "ERROR")
        //Act
        sut.start { (_, _) in }
        //Assert
        XCTAssertEqual(sut.navigationController.children.count, 1)
        XCTAssertNotNil(sut.navigationController.children[0] as? ServerConfigurationViewControllerable)
    }
    
    func testStartDoesNotRunAuthenticationFlowWhileServerControllerIsInvalid() throws {
        //Arrange
        let sut = self.buildSUT()
        let serverConfiguration = ServerConfiguration(host: self.exampleURL, shouldRememberHost: true)
        self.storyboardsManagerMock.controllerReturnValue[.serverConfiguration] = [.initial: UIViewController()]
        self.storyboardsManagerMock.controllerReturnValue[.login] = [.initial: UIViewController()]
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = serverConfiguration
        self.dependencyContainer.accessServiceMock.getSessionThrownError = TestError(message: "ERROR")
        //Act
        sut.start { (_, _) in }
        //Assert
        XCTAssertTrue(sut.navigationController.children.isEmpty)
    }
    
    func testStartDoesNotRunAuthenticationFlowWhileLoginControllerIsInvalid() throws {
        //Arrange
        let sut = self.buildSUT()
        let serverConfigurationVCMock = ServerConfigurationViewControllerMock()
        self.storyboardsManagerMock.controllerReturnValue[.serverConfiguration] = [.initial: serverConfigurationVCMock]
        self.storyboardsManagerMock.controllerReturnValue[.login] = [.initial: UIViewController()]
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(
            host: self.exampleURL,
            shouldRememberHost: true)
        self.dependencyContainer.accessServiceMock.getSessionThrownError = TestError(message: "ERROR")
        //Act
        sut.start { (_, _) in }
        //Assert
        XCTAssertEqual(sut.navigationController.children.count, 1)
        XCTAssertNotNil(sut.navigationController.children[0] as? ServerConfigurationViewControllerable)
    }
    
    func testStartRunsAuthenticationFlow() throws {
        //Arrange
        let sut = self.buildSUT()
        let serverConfigurationVCMock = ServerConfigurationViewControllerMock()
        let loginVCMock = LoginViewControllerMock()
        self.storyboardsManagerMock.controllerReturnValue[.serverConfiguration] = [.initial: serverConfigurationVCMock]
        self.storyboardsManagerMock.controllerReturnValue[.login] = [.initial: loginVCMock]
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(
            host: self.exampleURL,
            shouldRememberHost: true)
        self.dependencyContainer.accessServiceMock.getSessionThrownError = TestError(message: "ERROR")
        //Act
        sut.start { (_, _) in }
        //Assert
        XCTAssertEqual(sut.navigationController.children.count, 2)
        XCTAssertNotNil(sut.navigationController.children[0] as? ServerConfigurationViewControllerable)
        XCTAssertNotNil(sut.navigationController.children[1] as? LoginViewControllerable)
    }
    
    func testFinishOnStart() throws {
        //Arrange
        let expectedToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiJiMDhmODZhZi0zNWRhLTQ4ZjIt"
        let sut = self.buildSUT()
        self.storyboardsManagerMock.controllerReturnValue[.serverConfiguration] = [
            .initial: ServerConfigurationViewControllerMock()
        ]
        self.storyboardsManagerMock.controllerReturnValue[.login] = [.initial: LoginViewControllerMock()]
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(
            host: self.exampleURL,
            shouldRememberHost: true)
        let data = try self.json(from: SessionJSONResource.signInResponse)
        let sessionResponse = try self.decoder.decode(SessionDecoder.self, from: data)
        var optionalConfiguration: ServerConfiguration?
        var optionalApiClient: ApiClientType?
        self.dependencyContainer.accessServiceMock.getSessionReturnValue = sessionResponse
        //Act
        sut.start { (returnedConfiguration, returnedApiClient) in
            optionalConfiguration = returnedConfiguration
            optionalApiClient = returnedApiClient
        }
        //Assert
        let configuration = try XCTUnwrap(optionalConfiguration)
        let apiClient = try XCTUnwrap(optionalApiClient)
        XCTAssertEqual(configuration.host, self.exampleURL)
        XCTAssertEqual(configuration.shouldRememberHost, true)
        let apiClientMock = self.dependencyContainer.apiClientFactoryMock.buildAPIClientReturnValue
        XCTAssertTrue(apiClient === apiClientMock)
        XCTAssertEqual(apiClientMock.setAuthenticationTokenParams.count, 1)
        XCTAssertEqual(apiClientMock.setAuthenticationTokenParams.last?.token, expectedToken)
    }
}

// MARK: - loginDidFinish(with state: AuthenticationCoordinator.State)
extension AuthenticationCoordinatorTests {
    func testLoginDidFinishWithStateLoggedInCorrectly() throws {
        //Arrange
        let expectedToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiJiMDhmODZhZi0zNWRhLTQ4ZjIt"
        let sut = self.buildSUT()
        self.storyboardsManagerMock.controllerReturnValue[.serverConfiguration] = [
            .initial: ServerConfigurationViewControllerMock()
        ]
        self.storyboardsManagerMock.controllerReturnValue[.login] = [.initial: LoginViewControllerMock()]
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(
            host: self.exampleURL,
            shouldRememberHost: true)
        let data = try self.json(from: SessionJSONResource.signInResponse)
        let sessionReponse = try self.decoder.decode(SessionDecoder.self, from: data)
        var optionalConfiguration: ServerConfiguration?
        var optionalApiClient: ApiClientType?
        self.dependencyContainer.accessServiceMock.getSessionReturnValue = sessionReponse
        sut.start { (returnedConfiguration, returnedApiClient) in
            optionalConfiguration = returnedConfiguration
            optionalApiClient = returnedApiClient
        }
        //Act
        sut.loginDidFinish(with: .loggedInCorrectly(sessionReponse))
        //Assert
        let configuration = try XCTUnwrap(optionalConfiguration)
        let apiClient = try XCTUnwrap(optionalApiClient)
        XCTAssertEqual(configuration.host, self.exampleURL)
        XCTAssertEqual(configuration.shouldRememberHost, true)
        let apiClientMock = self.dependencyContainer.apiClientFactoryMock.buildAPIClientReturnValue
        XCTAssertTrue(apiClient === apiClientMock)
        XCTAssertEqual(apiClientMock.setAuthenticationTokenParams.count, 2)
        XCTAssertEqual(apiClientMock.setAuthenticationTokenParams.last?.token, expectedToken)
    }
}
    
// MARK: - State.Equatable
extension AuthenticationCoordinatorTests {
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
