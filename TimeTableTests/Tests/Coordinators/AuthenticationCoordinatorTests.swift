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
    
    private var viewControllerBuilderMock: ViewControllerBuilderMock {
        self.dependencyContainer.viewControllerBuilderMock
    }
        
    override func setUp() {
        super.setUp()
        self.navigationController = UINavigationController()
        self.dependencyContainer = DependencyContainerMock()
        self.dependencyContainer.window = UIWindow()
    }
}

// MARK: - start(finishCompletion:)
extension AuthenticationCoordinatorTests {
    func testStart_viewControllerBuilderThrowsError_doesNotRunServerConfigurationFlow() {
        //Arrange
        let sut = self.buildSUT()
        self.viewControllerBuilderMock.serverConfigurationThrownError = "Error message"
        //Act
        sut.start { (_, _) in }
        //Assert
        XCTAssertTrue(sut.navigationController.children.isEmpty)
    }
    
    func testStartRunsServerConfigurationFlow() {
        //Arrange
        let sut = self.buildSUT()
        self.viewControllerBuilderMock.serverConfigurationReturnValue = ServerConfigurationViewControllerMock()
        //Act
        sut.start { (_, _) in }
        //Assert
        XCTAssertNotNil(sut.navigationController.children[0] as? ServerConfigurationViewControllerable)
    }

    func testStartRunsServerConfigurationFlowWhileServerConfigurationShouldRemeberHostIsFalse() {
        //Arrange
        let sut = self.buildSUT()
        self.viewControllerBuilderMock.serverConfigurationReturnValue = ServerConfigurationViewControllerMock()
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
        let serverConfiguration = ServerConfiguration(host: nil, shouldRememberHost: true)
        self.viewControllerBuilderMock.serverConfigurationReturnValue = ServerConfigurationViewControllerMock()
        self.viewControllerBuilderMock.loginReturnValue = LoginViewControllerMock()
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
        self.viewControllerBuilderMock.serverConfigurationThrownError = "Error message"
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = serverConfiguration
        self.dependencyContainer.accessServiceMock.getSessionThrownError = TestError(message: "ERROR")
        //Act
        sut.start { (_, _) in }
        //Assert
        XCTAssertEqual(self.dependencyContainer.errorHandlerMock.stopInDebugParams.count, 1)
    }
    
    func testStartDoesNotRunAuthenticationFlowWhileLoginControllerIsInvalid() throws {
        //Arrange
        let sut = self.buildSUT()
        self.viewControllerBuilderMock.serverConfigurationReturnValue = ServerConfigurationViewControllerMock()
        self.viewControllerBuilderMock.loginThrownError = "Error message"
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
        self.viewControllerBuilderMock.serverConfigurationReturnValue = ServerConfigurationViewControllerMock()
        self.viewControllerBuilderMock.loginReturnValue = LoginViewControllerMock()
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
    
//    func testFinishOnStart() throws {
//        //Arrange
//        let expectedToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiJiMDhmODZhZi0zNWRhLTQ4ZjIt"
//        let sut = self.buildSUT()
//        self.viewControllerBuilderMock.serverConfigurationReturnValue = ServerConfigurationViewControllerMock()
//        self.viewControllerBuilderMock.loginReturnValue = LoginViewControllerMock()
//        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(
//            host: self.exampleURL,
//            shouldRememberHost: true)
//        let data = try self.json(from: SessionJSONResource.signInResponse)
//        let sessionResponse = try self.decoder.decode(SessionDecoder.self, from: data)
//        var optionalConfiguration: ServerConfiguration?
//        var optionalApiClient: ApiClientType?
//        self.dependencyContainer.accessServiceMock.getSessionReturnValue = sessionResponse
//        //Act
//        sut.start { (returnedConfiguration, returnedApiClient) in
//            optionalConfiguration = returnedConfiguration
//            optionalApiClient = returnedApiClient
//        }
//        //Assert
//        let configuration = try XCTUnwrap(optionalConfiguration)
//        let apiClient = try XCTUnwrap(optionalApiClient)
//        XCTAssertEqual(configuration.host, self.exampleURL)
//        XCTAssertEqual(configuration.shouldRememberHost, true)
//        let apiClientMock = self.dependencyContainer.apiClientFactoryMock.buildAPIClientReturnValue
//        XCTAssertTrue(apiClient === apiClientMock)
//        XCTAssertEqual(apiClientMock.setAuthenticationTokenParams.count, 1)
//        XCTAssertEqual(apiClientMock.setAuthenticationTokenParams.last?.token, expectedToken)
//    }
}
    
// MARK: - State.Equatable
extension AuthenticationCoordinatorTests {
    func testAuthenticationCoordinatorStateEquatableChangeAddress() {
        //Arrange
        let firstState = AuthenticationCoordinator.State.changeAddress
        let secoundState = AuthenticationCoordinator.State.changeAddress
        //Assert
        XCTAssertEqual(firstState, secoundState)
    }
    
    func testAuthenticationCoordinatorStateNotEquatableChangeAddressAndLoggedInCorrectly() throws {
        //Arrange
        let firstState = AuthenticationCoordinator.State.changeAddress
        let secoundState = AuthenticationCoordinator.State.loggedInCorrectly
        //Assert
        XCTAssertNotEqual(firstState, secoundState)
    }
    
    func testAuthenticationCoordinatorStateEquatableLoggedInCorrectly() throws {
        //Arrange
        let firstState = AuthenticationCoordinator.State.loggedInCorrectly
        let secoundState = AuthenticationCoordinator.State.loggedInCorrectly
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
