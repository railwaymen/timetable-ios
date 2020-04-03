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
