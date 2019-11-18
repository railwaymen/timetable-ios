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
    private var coreDataStackMock: CoreDataStackMock!
    private var errorHandlerMock: ErrorHandlerMock!
    private var viewModel: ProfileViewModel!
    
    private lazy var decoder = JSONDecoder()
    
    override func setUp() {
        super.setUp()
        self.userInterfaceMock = ProfileViewControllerMock()
        self.coordinatorMock = ProfileCoordinatorMock()
        self.apiClientMock = ApiClientMock()
        self.accessServiceMock = AccessServiceMock()
        self.coreDataStackMock = CoreDataStackMock()
        self.errorHandlerMock = ErrorHandlerMock()
        
        self.viewModel = ProfileViewModel(userInterface: self.userInterfaceMock,
                                          coordinator: self.coordinatorMock,
                                          apiClient: self.apiClientMock,
                                          accessService: self.accessServiceMock,
                                          coreDataStack: self.coreDataStackMock,
                                          errorHandler: self.errorHandlerMock)
    }
    
    func testViewDidLoadCallsSetUpViewOnTheUserInterface() {
        //Act
        self.viewModel.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setUpParams.count, 1)
    }
    
    func testViewDidLoadDoesNotUpdateUserInterfaceAndThorwsErrorWhileLastUserIdetifierIsNil() {
        //Arrange
        self.accessServiceMock.getLastLoggedInUserIdentifierReturnValue = nil
        //Act
        self.viewModel.viewDidLoad()
        //Assert
        XCTAssertTrue(self.userInterfaceMock.setActivityIndicatorParams.isEmpty)
        XCTAssertNil(self.errorHandlerMock.throwedError)
        XCTAssertTrue(self.userInterfaceMock.updateParams.isEmpty)
    }
    
    func testViewDidLoadMakesRequest() {
        //Arrange
        self.accessServiceMock.getLastLoggedInUserIdentifierReturnValue = 2
        //Act
        self.viewModel.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 1)
        XCTAssertFalse(try (self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden).unwrap())
        XCTAssertNil(self.errorHandlerMock.throwedError)
        XCTAssertTrue(self.userInterfaceMock.updateParams.isEmpty)
    }
    
    func testViewDidLoadFetchUserProfileFails() throws {
        //Arrange
        let error = TestError(message: "error")
        self.accessServiceMock.getLastLoggedInUserIdentifierReturnValue = 2
        //Act
        self.viewModel.viewDidLoad()
        self.apiClientMock.fetchUserProfileCompletion?(.failure(error))
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try (self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden).unwrap())
        XCTAssertEqual(try (self.errorHandlerMock.throwedError as? TestError).unwrap(), error)
        XCTAssertEqual(self.userInterfaceMock.showErrorViewParams.count, 1)
    }
    
    func testViewDidLoadFetchUserProfileSucceed() throws {
        //Arrange
        self.accessServiceMock.getLastLoggedInUserIdentifierReturnValue = 2
        let data = try self.json(from: UserJSONResource.userFullResponse)
        let userDecoder = try self.decoder.decode(UserDecoder.self, from: data)
        //Act
        self.viewModel.viewDidLoad()
        self.apiClientMock.fetchUserProfileCompletion?(.success(userDecoder))
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try (self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden).unwrap())
        XCTAssertEqual(self.userInterfaceMock.updateParams.last?.firstName, "John")
        XCTAssertEqual(self.userInterfaceMock.updateParams.last?.lastName, "Little")
        XCTAssertEqual(self.userInterfaceMock.updateParams.last?.email, "john.little@example.com")
        XCTAssertEqual(self.userInterfaceMock.showScrollViewParams.count, 1)
    }
    
    func testViewRequestedForLogoutReturnsWhileUserIdentifierIsNil() {
        //Act
        self.viewModel.viewRequestedForLogout()
        //Assert
        XCTAssertTrue(self.userInterfaceMock.setActivityIndicatorParams.isEmpty)
        XCTAssertNil(self.errorHandlerMock.throwedError)
        XCTAssertTrue(self.coordinatorMock.userProfileDidLogoutUserParams.isEmpty)
    }
    
    func testViewRequestedForLogoutMakesRequestToDeleteUser() {
        //Arrange
        self.accessServiceMock.getLastLoggedInUserIdentifierReturnValue = 2
        //Act
        self.viewModel.viewRequestedForLogout()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 1)
        XCTAssertFalse(try (self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden).unwrap())
        XCTAssertNil(self.errorHandlerMock.throwedError)
        XCTAssertNotNil(self.coreDataStackMock.deleteUserCompletion)
    }
    
    func testViewRequestedForLogoutThrowsAnError() {
        //Arrange
        let error = TestError(message: "error")
        self.accessServiceMock.getLastLoggedInUserIdentifierReturnValue = 2
        //Act
        self.viewModel.viewRequestedForLogout()
        self.coreDataStackMock.deleteUserCompletion?(.failure(error))
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try (self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden).unwrap())
        XCTAssertEqual(try (self.errorHandlerMock.throwedError as? TestError).unwrap(), error)
    }
    
    func testViewRequestedForLogoutSucceed() {
        //Arrange
        self.accessServiceMock.getLastLoggedInUserIdentifierReturnValue = 2
        //Act
        self.viewModel.viewRequestedForLogout()
        self.coreDataStackMock.deleteUserCompletion?(.success(Void()))
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try (self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden).unwrap())
        XCTAssertEqual(self.coordinatorMock.userProfileDidLogoutUserParams.count, 1)
    }
}
