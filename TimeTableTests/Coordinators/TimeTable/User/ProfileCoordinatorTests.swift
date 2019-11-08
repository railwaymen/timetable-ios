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
        self.dependencyContainer = DependencyContainerMock()
        self.coordinator = ProfileCoordinator(dependencyContainer: self.dependencyContainer)
        super.setUp()
    }
    
    func testStartSetsNavigationBarHidden() {
        //Act
        self.coordinator.start(finishCompletion: {})
        //Assert
        XCTAssertFalse(coordinator.navigationController.navigationBar.isHidden)
    }
    
    func testStartInvalidControllerReturned() {
        //Arrange
        self.dependencyContainer.storyboardsManagerMock.userController = UIViewController()
        //Act
        self.coordinator.start(finishCompletion: {})
        //Assert
        XCTAssertTrue(self.coordinator.navigationController.children.isEmpty)
    }
    
    func testStartSetsChildViewController() {
        //Arrange
        self.dependencyContainer.storyboardsManagerMock.userController = ProfileViewControllerMock()
        //Act
        self.coordinator.start(finishCompletion: {})
        //Assert
        XCTAssertNotNil(self.coordinator.navigationController.children[0] as? ProfileViewControllerable)
    }
    
    func testUserProfileDidLogoutUser() {
        //Arrange
        var finishCompletionCalled = false
        self.dependencyContainer.storyboardsManagerMock.userController = ProfileViewControllerMock()
        self.coordinator.start(finishCompletion: {
            finishCompletionCalled = true
        })
        //Act
        self.coordinator.userProfileDidLogoutUser()
        //Assert
        XCTAssertTrue(finishCompletionCalled)
    }
}
