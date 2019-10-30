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
    private var dependencyContainer: DependencyContainerMock!
    private var coordinator: ProfileCoordinator!
    
    override func setUp() {
        dependencyContainer = DependencyContainerMock()
        coordinator = ProfileCoordinator(dependencyContainer: dependencyContainer)
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
        dependencyContainer.storyboardsManagerMock.userController = UIViewController()
        //Act
        coordinator.start(finishCompletion: {})
        //Assert
        XCTAssertTrue(coordinator.navigationController.children.isEmpty)
    }
    
    func testStartSetsChildViewController() {
        //Arrange
        dependencyContainer.storyboardsManagerMock.userController = ProfileViewControllerMock()
        //Act
        coordinator.start(finishCompletion: {})
        //Assert
        XCTAssertNotNil(coordinator.navigationController.children[0] as? ProfileViewControllerable)
    }
    
    func testUserProfileDidLogoutUser() {
        //Arrange
        var finishCompletionCalled = false
        dependencyContainer.storyboardsManagerMock.userController = ProfileViewControllerMock()
        coordinator.start(finishCompletion: {
            finishCompletionCalled = true
        })
        //Act
        coordinator.userProfileDidLogoutUser()
        //Assert
        XCTAssertTrue(finishCompletionCalled)
    }
}
