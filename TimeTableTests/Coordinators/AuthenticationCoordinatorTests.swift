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
    private var coreDataStackMock: CoreDataStackMock!
    private var accessServiceMock: AccessServiceMock!
    
    override func setUp() {
        self.navigationController = UINavigationController()
        self.storyboardsManagerMock = StoryboardsManagerMock()
        self.errorHandlerMock = ErrorHandlerMock()
        self.apiClientMock = ApiClientMock()
        self.coreDataStackMock = CoreDataStackMock()
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
    
    func testFinishCompletionExecutedWhileLoginDidFinishDelegateCalled() {
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
        //Act
        coordinator.loginDidFinish(with: .loggedInCorrectly)
        //Assert
        XCTAssertTrue(finishCompletionCalled)
    }
}
