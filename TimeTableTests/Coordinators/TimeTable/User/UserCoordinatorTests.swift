//
//  UserCoordinatorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 18/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class UserCoordinatorTests: XCTestCase {
    private var window: UIWindow!
    private var storyboardsManagerMock: StoryboardsManagerMock!
    private var apiClientMock: ApiClientMock!
    private var accessServiceMock: AccessServiceMock!
    private var coreDataStackMock: CoreDataStackUserMock!
    private var errorHandlerMock: ErrorHandlerMock!
    
    private var coordinator: UserCoordinator!
    
    override func setUp() {
        window = UIWindow(frame: .zero)
        storyboardsManagerMock = StoryboardsManagerMock()
        apiClientMock = ApiClientMock()
        accessServiceMock = AccessServiceMock()
        coreDataStackMock = CoreDataStackUserMock()
        errorHandlerMock = ErrorHandlerMock()
        coordinator = UserCoordinator(window: window,
                                      storyboardsManager: storyboardsManagerMock,
                                      apiClient: apiClientMock,
                                      accessService: accessServiceMock,
                                      coreDataStack: coreDataStackMock,
                                      errorHandler: errorHandlerMock)
        super.setUp()
    }
    
    func testStartSetsNavigationBarHidden() {
        //Act
        coordinator.start(finishCompletion: {})
        //Assert
        XCTAssertTrue(coordinator.navigationController.navigationBar.isHidden)
    }
    
    func testStartInvalidControllerReturned() {
        //Arrange
        storyboardsManagerMock.userController = UIViewController()
        //Act
        coordinator.start(finishCompletion: {})
        //Assert
        XCTAssertTrue(coordinator.navigationController.children.isEmpty)
    }
    
    func testStartSetsChildViewController() {
        //Arrange
        storyboardsManagerMock.userController = UserProfileViewMock()
        //Act
        coordinator.start(finishCompletion: {})
        //Assert
        XCTAssertNotNil(coordinator.navigationController.children[0] as? UserProfileViewControllerable)
    }
    
    func testUserProfileDidLogoutUser() {
        //Arrange
        var finishCompletionCalled = false
        storyboardsManagerMock.userController = UserProfileViewMock()
        coordinator.start(finishCompletion: {
            finishCompletionCalled = true
        })
        //Act
        coordinator.userProfileDidLogoutUser()
        //Assert
        XCTAssertTrue(finishCompletionCalled)
    }
}
