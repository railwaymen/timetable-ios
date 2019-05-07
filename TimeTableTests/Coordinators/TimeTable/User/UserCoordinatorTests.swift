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
    private var messagePresenterMock: MessagePresenterMock!
    
    private var coordinator: UserCoordinator!
    
    override func setUp() {
        self.window = UIWindow(frame: .zero)
        self.storyboardsManagerMock = StoryboardsManagerMock()
        self.apiClientMock = ApiClientMock()
        self.accessServiceMock = AccessServiceMock()
        self.coreDataStackMock = CoreDataStackUserMock()
        self.errorHandlerMock = ErrorHandlerMock()
        self.messagePresenterMock = MessagePresenterMock()
        
        self.coordinator = UserCoordinator(window: self.window,
                                           messagePresenter: self.messagePresenterMock,
                                           storyboardsManager: self.storyboardsManagerMock,
                                           apiClient: self.apiClientMock,
                                           accessService: self.accessServiceMock,
                                           coreDataStack: self.coreDataStackMock,
                                           errorHandler: self.errorHandlerMock)
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
