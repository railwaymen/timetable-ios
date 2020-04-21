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
        let error = "Error message"
        self.viewControllerBuilderMock.serverConfigurationThrownError = error
        //Act
        sut.start { _ in }
        //Assert
        XCTAssertTrue(sut.navigationController.children.isEmpty)
        XCTAssertEqual(self.dependencyContainer.errorHandlerMock.stopInDebugParams.count, 1)
        XCTAssertEqual(self.dependencyContainer.errorHandlerMock.stopInDebugParams.last?.message, error)
    }
    
    func testStart_withoutServerConfiguration_runsServerConfigurationFlow() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.start { _ in }
        //Assert
        XCTAssertEqual(sut.navigationController.children.count, 1)
        XCTAssert(sut.navigationController.children.last is ServerConfigurationViewControllerable)
    }
    
    func testStart_withServerConfiguration_runsLoginFlow() {
        //Arrange
        let sut = self.buildSUT()
        self.dependencyContainer.serverConfigurationManagerMock.getOldConfigurationReturnValue = ServerConfiguration(
            host: self.exampleURL)
        //Act
        sut.start { _ in }
        //Assert
        XCTAssertEqual(sut.navigationController.children.count, 2)
        XCTAssert(sut.navigationController.children.last is LoginViewControllerable)
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
