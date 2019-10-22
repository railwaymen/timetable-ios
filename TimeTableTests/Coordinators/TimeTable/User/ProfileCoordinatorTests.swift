//
//  ProfileCoordinatorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 18/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ProfileCoordinatorTests: XCTestCase {
    private var window: UIWindow!
    private var storyboardsManagerMock: StoryboardsManagerMock!
    private var apiClientMock: ApiClientMock!
    private var accessServiceMock: AccessServiceMock!
    private var coreDataStackMock: CoreDataStackUserMock!
    private var errorHandlerMock: ErrorHandlerMock!
    private var messagePresenterMock: MessagePresenterMock!
    
    private var coordinator: ProfileCoordinator!
    
    override func setUp() {
        self.window = UIWindow(frame: .zero)
        self.storyboardsManagerMock = StoryboardsManagerMock()
        self.apiClientMock = ApiClientMock()
        self.accessServiceMock = AccessServiceMock()
        self.coreDataStackMock = CoreDataStackUserMock()
        self.errorHandlerMock = ErrorHandlerMock()
        self.messagePresenterMock = MessagePresenterMock()
        
        self.coordinator = ProfileCoordinator(window: self.window,
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
        XCTAssertFalse(coordinator.navigationController.navigationBar.isHidden)
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
        storyboardsManagerMock.userController = ProfileViewControllerMock()
        //Act
        coordinator.start(finishCompletion: {})
        //Assert
        XCTAssertNotNil(coordinator.navigationController.children[0] as? ProfileViewControllerable)
    }
    
    func testUserProfileDidLogoutUser() {
        //Arrange
        var finishCompletionCalled = false
        storyboardsManagerMock.userController = ProfileViewControllerMock()
        coordinator.start(finishCompletion: {
            finishCompletionCalled = true
        })
        //Act
        coordinator.userProfileDidLogoutUser()
        //Assert
        XCTAssertTrue(finishCompletionCalled)
    }
}
