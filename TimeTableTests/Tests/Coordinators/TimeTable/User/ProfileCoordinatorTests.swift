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
    private var parentMock: ProfileCoordinatorParentMock!
    
    private var viewControllerBuilderMock: ViewControllerBuilderMock {
        self.dependencyContainer.viewControllerBuilderMock
    }
    
    override func setUp() {
        super.setUp()
        self.dependencyContainer = DependencyContainerMock()
        self.parentMock = ProfileCoordinatorParentMock()
    }
}
 
// MARK: - start(finishHandler: (() -> Void)?)
extension ProfileCoordinatorTests {
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
        let error = "Error message"
        self.viewControllerBuilderMock.profileThrownError = error
        //Act
        sut.start {}
        //Assert
        XCTAssertTrue(sut.navigationController.children.isEmpty)
        XCTAssertEqual(self.dependencyContainer.errorHandlerMock.stopInDebugParams.count, 1)
        XCTAssertEqual(self.dependencyContainer.errorHandlerMock.stopInDebugParams.last?.message, error)
    }
    
    func testStartSetsChildViewController() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.start {}
        //Assert
        XCTAssertNotNil(sut.navigationController.children[0] as? ProfileViewControllerable)
    }
}

// MARK: - userProfileDidLogoutUser()
extension ProfileCoordinatorTests {
    func testUserProfileDidLogoutUser() {
        //Arrange
        let sut = self.buildSUT()
        var finishCompletionCalled = false
        self.viewControllerBuilderMock.profileReturnValue = ProfileViewControllerMock()
        sut.start {
            finishCompletionCalled = true
        }
        //Act
        sut.userProfileDidLogoutUser()
        //Assert
        XCTAssertFalse(finishCompletionCalled)
        XCTAssertEqual(self.parentMock.childDidRequestToFinishParams.count, 1)
    }
}

// MARK: - Private
extension ProfileCoordinatorTests {
    private func buildSUT() -> ProfileCoordinator {
        return ProfileCoordinator(
            dependencyContainer: self.dependencyContainer,
            parent: self.parentMock)
    }
}

// MARK: - Private Structures
private class ProfileCoordinatorParentMock: ProfileCoordinatorParentType {
    private(set) var childDidRequestToFinishParams: [ChildDidRequestToFinishParams] = []
    struct ChildDidRequestToFinishParams {}
    
    func childDidRequestToFinish() {
        self.childDidRequestToFinishParams.append(ChildDidRequestToFinishParams())
    }
}
