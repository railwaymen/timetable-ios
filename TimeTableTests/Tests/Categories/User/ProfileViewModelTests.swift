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
    private var apiClientMock: ApiClientMock!
    private var accessServiceMock: AccessServiceMock!
    private var errorHandlerMock: ErrorHandlerMock!
        
    override func setUp() {
        super.setUp()
        self.userInterfaceMock = ProfileViewControllerMock()
        self.coordinatorMock = ProfileCoordinatorMock()
        self.apiClientMock = ApiClientMock()
        self.accessServiceMock = AccessServiceMock()
        self.errorHandlerMock = ErrorHandlerMock()
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
            apiClient: self.apiClientMock,
            accessService: self.accessServiceMock,
            errorHandler: self.errorHandlerMock)
    }
}
