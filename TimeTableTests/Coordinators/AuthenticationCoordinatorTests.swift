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
    private var storyboardsManagerMock: StoryboardsManagerMock!
    private var errorHandlerMock: ErrorHandlerMock!
    private var apiClientMock: ApiClientMock!
    private var coreDataStackMock: CoreDataStackUserMock!
    private var accessServiceMock: AccessServiceMock!
    
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
        super.setUp()
    }
    
    func testStartAuthenticationCoorinatorDoNotContainChildControllers() {
        //Arrange
        let coordinator = AuthenticationCoordinator(navigationController: navigationController,
                                                    storyboardsManager: storyboardsManagerMock,
                                                    accessService: accessServiceMock,
                                                    apiClient: apiClientMock,
                                                    errorHandler: errorHandlerMock,
                                                    coreDataStack: coreDataStackMock)
        //Act
        coordinator.start(finishCompletion: { _ in })
        //Assert
        XCTAssertTrue(coordinator.navigationController.children.isEmpty)
    }
    
    func testStartAuthenticationCoorinatorContainsChildControllers() {
        //Arrange
        let coordinator = AuthenticationCoordinator(navigationController: navigationController,
                                                    storyboardsManager: storyboardsManagerMock,
                                                    accessService: accessServiceMock,
                                                    apiClient: apiClientMock,
                                                    errorHandler: errorHandlerMock,
                                                    coreDataStack: coreDataStackMock)
        storyboardsManagerMock.controller = LoginViewControllerMock()
        //Act
        coordinator.start(finishCompletion: { _ in })
        //Assert
        XCTAssertEqual(coordinator.navigationController.children.count, 1)
    }
    
    func testFinishCompletionExecutedWhileLoginDidFinishDelegateCalled() throws {
        //Arrange
        var finishCompletionCalled = false
        let coordinator = AuthenticationCoordinator(navigationController: navigationController,
                                                    storyboardsManager: storyboardsManagerMock,
                                                    accessService: accessServiceMock,
                                                    apiClient: apiClientMock,
                                                    errorHandler: errorHandlerMock,
                                                    coreDataStack: coreDataStackMock)
        storyboardsManagerMock.controller = LoginViewControllerMock()
        coordinator.start(finishCompletion: {
            finishCompletionCalled = true
        })
        let data = try self.json(from: SessionResponse.signInResponse)
        let sessionReponse = try decoder.decode(SessionDecoder.self, from: data)
        //Act
        coordinator.loginDidFinish(with: .loggedInCorrectly(sessionReponse))
        //Assert
        XCTAssertTrue(finishCompletionCalled)
    }
    
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
