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
    
    override func setUp() {
        super.setUp()
        self.dependencyContainer = DependencyContainerMock()
    }
    
    func testStartSetsNavigationBarHidden() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.start {}
        //Assert
        XCTAssertFalse(sut.navigationController.navigationBar.isHidden)
    }
    
    func testStartInvalidControllerReturned() {
        //Arrange
        let sut = self.buildSUT()
        self.dependencyContainer.storyboardsManagerMock.controllerReturnValue[.profile] = [.initial: UIViewController()]
        //Act
        sut.start {}
        //Assert
        XCTAssertTrue(sut.navigationController.children.isEmpty)
    }
    
    func testStartSetsChildViewController() {
        //Arrange
        let sut = self.buildSUT()
        self.dependencyContainer.storyboardsManagerMock.controllerReturnValue[.profile] = [.initial: ProfileViewControllerMock()]
        //Act
        sut.start {}
        //Assert
        XCTAssertNotNil(sut.navigationController.children[0] as? ProfileViewControllerable)
    }
    
    func testUserProfileDidLogoutUser() {
        //Arrange
        let sut = self.buildSUT()
        var finishCompletionCalled = false
        self.dependencyContainer.storyboardsManagerMock.controllerReturnValue[.profile] = [.initial: ProfileViewControllerMock()]
        sut.start {
            finishCompletionCalled = true
        }
        //Act
        sut.userProfileDidLogoutUser()
        //Assert
        XCTAssertTrue(finishCompletionCalled)
    }
}

// MARK: - Private
extension ProfileCoordinatorTests {
    private func buildSUT() -> ProfileCoordinator {
        return ProfileCoordinator(dependencyContainer: self.dependencyContainer)
    }
}
