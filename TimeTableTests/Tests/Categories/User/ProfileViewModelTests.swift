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
    
    func testViewDidLoadDoesNotUpdateUserInterfaceAndThorwsErrorWhileLastUserIdetifierIsNil() {
        //Arrange
        let sut = self.buildSUT()
        self.accessServiceMock.getLastLoggedInUserIdentifierReturnValue = nil
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertTrue(self.userInterfaceMock.setActivityIndicatorParams.isEmpty)
        XCTAssertTrue(self.errorHandlerMock.throwingParams.isEmpty)
        XCTAssertTrue(self.userInterfaceMock.updateParams.isEmpty)
    }
    
    func testViewDidLoadMakesRequest() {
        //Arrange
        let sut = self.buildSUT()
        self.accessServiceMock.getLastLoggedInUserIdentifierReturnValue = 2
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 1)
        XCTAssertFalse(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
        XCTAssertTrue(self.errorHandlerMock.throwingParams.isEmpty)
        XCTAssertTrue(self.userInterfaceMock.updateParams.isEmpty)
    }
    
    func testViewDidLoadFetchUserProfileFails() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = TestError(message: "error")
        self.accessServiceMock.getLastLoggedInUserIdentifierReturnValue = 2
        //Act
        sut.viewDidLoad()
        self.apiClientMock.fetchUserProfileParams.last?.completion(.failure(error))
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
        XCTAssertEqual(try XCTUnwrap(self.errorHandlerMock.throwingParams.last?.error as? TestError), error)
        XCTAssertEqual(self.userInterfaceMock.showErrorViewParams.count, 1)
    }
    
    func testViewDidLoadFetchUserProfileSucceed() throws {
        //Arrange
        let sut = self.buildSUT()
        self.accessServiceMock.getLastLoggedInUserIdentifierReturnValue = 2
        let data = try self.json(from: UserJSONResource.userFullResponse)
        let userDecoder = try self.decoder.decode(UserDecoder.self, from: data)
        //Act
        sut.viewDidLoad()
        self.apiClientMock.fetchUserProfileParams.last?.completion(.success(userDecoder))
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
        XCTAssertEqual(self.userInterfaceMock.updateParams.last?.firstName, "John")
        XCTAssertEqual(self.userInterfaceMock.updateParams.last?.lastName, "Little")
        XCTAssertEqual(self.userInterfaceMock.updateParams.last?.email, "john.little@example.com")
        XCTAssertEqual(self.userInterfaceMock.showScrollViewParams.count, 1)
    }
}

// MARK: - viewRequestedForLogout()
extension ProfileViewModelTests {
    func testViewRequestedForLogoutThrowsAnError() {
        //Arrange
        let sut = self.buildSUT()
        let error = TestError(message: "error")
        self.accessServiceMock.removeSessionThrownError = error
        //Act
        sut.viewRequestedForLogout()
        //Assert
        XCTAssertEqual(self.errorHandlerMock.throwingParams.last?.error as? TestError, error)
        XCTAssertEqual(self.coordinatorMock.userProfileDidLogoutUserParams.count, 0)
    }
    
    func testViewRequestedForLogoutSucceed() {
        //Arrange
        let sut = self.buildSUT()
        self.accessServiceMock.getLastLoggedInUserIdentifierReturnValue = 2
        //Act
        sut.viewRequestedForLogout()
        //Assert
        XCTAssertEqual(self.coordinatorMock.userProfileDidLogoutUserParams.count, 1)
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
