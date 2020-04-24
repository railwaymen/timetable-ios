//
//  ProfileViewModelTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 18/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ProfileViewModelTests: XCTestCase {
    private var userInterfaceMock: ProfileViewControllerMock!
    private var coordinatorMock: ProfileCoordinatorMock!
    private var contentProvider: ProfileContentProviderMock!
    private var errorHadler: ErrorHandlerMock!
        
    override func setUp() {
        super.setUp()
        self.userInterfaceMock = ProfileViewControllerMock()
        self.coordinatorMock = ProfileCoordinatorMock()
        self.contentProvider = ProfileContentProviderMock()
        self.errorHadler = ErrorHandlerMock()
    }
}

// MARK: - viewDidLoad()
extension ProfileViewModelTests {
    func testViewDidLoadCallsSetUpViewOnTheUserInterface() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setUpParams.count, 1)
    }
}
// MARK: - Private
extension ProfileViewModelTests {
    private func buildSUT() -> ProfileViewModel {
        return ProfileViewModel(
            userInterface: self.userInterfaceMock,
            coordinator: self.coordinatorMock,
            contentProvider: self.contentProvider,
            errorHandler: self.errorHadler)
    }
}
