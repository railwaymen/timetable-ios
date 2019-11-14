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
        XCTAssertTrue(self.userInterfaceMock.setUpCalled)
    }
    
    func testViewDidLoadDoesNotUpdateUserInterfaceAndThorwsErrorWhileLastUserIdetifierIsNil() {
        //Arrange
        self.accessServiceMock.getLastLoggedInUserIdentifierValue = nil
        //Act
        self.viewModel.viewDidLoad()
        //Assert
        XCTAssertNil(self.userInterfaceMock.setActivityIndicatorIsHidden)
        XCTAssertNil(self.errorHandlerMock.throwedError)
        XCTAssertNil(self.userInterfaceMock.updateValues.0)
        XCTAssertNil(self.userInterfaceMock.updateValues.1)
        XCTAssertNil(self.userInterfaceMock.updateValues.2)
    }
    
    func testViewDidLoadMakesRequest() {
        //Arrange
        self.accessServiceMock.getLastLoggedInUserIdentifierValue = 2
        //Act
        self.viewModel.viewDidLoad()
        //Assert
        XCTAssertFalse(try self.userInterfaceMock.setActivityIndicatorIsHidden.unwrap())
        XCTAssertNil(self.errorHandlerMock.throwedError)
        XCTAssertNil(self.userInterfaceMock.updateValues.0)
        XCTAssertNil(self.userInterfaceMock.updateValues.1)
        XCTAssertNil(self.userInterfaceMock.updateValues.2)
    }
    
    func testViewDidLoadFetchUserProfileFails() throws {
        //Arrange
        let error = TestError(message: "error")
        self.accessServiceMock.getLastLoggedInUserIdentifierValue = 2
        //Act
        self.viewModel.viewDidLoad()
        self.apiClientMock.fetchUserProfileCompletion?(.failure(error))
        //Assert
        XCTAssertTrue(try self.userInterfaceMock.setActivityIndicatorIsHidden.unwrap())
        XCTAssertEqual(try (self.errorHandlerMock.throwedError as? TestError).unwrap(), error)
        XCTAssertTrue(self.userInterfaceMock.showErrorViewCalled)
    }
    
    func testViewDidLoadFetchUserProfileSucceed() throws {
        //Arrange
        self.accessServiceMock.getLastLoggedInUserIdentifierValue = 2
        let data = try self.json(from: UserJSONResource.userFullResponse)
        let userDecoder = try self.decoder.decode(UserDecoder.self, from: data)
        //Act
        self.viewModel.viewDidLoad()
        self.apiClientMock.fetchUserProfileCompletion?(.success(userDecoder))
        //Assert
        XCTAssertTrue(try self.userInterfaceMock.setActivityIndicatorIsHidden.unwrap())
        XCTAssertEqual(self.userInterfaceMock.updateValues.0, "John")
        XCTAssertEqual(self.userInterfaceMock.updateValues.1, "Little")
        XCTAssertEqual(self.userInterfaceMock.updateValues.2, "john.little@example.com")
        XCTAssertTrue(self.userInterfaceMock.showScrollViewCalled)
    }
    
    func testViewRequestedForLogoutReturnsWhileUserIdentifierIsNil() {
        //Act
        self.viewModel.viewRequestedForLogout()
        //Assert
        XCTAssertNil(self.userInterfaceMock.setActivityIndicatorIsHidden)
        XCTAssertNil(self.errorHandlerMock.throwedError)
        XCTAssertFalse(self.coordinatorMock.userProfileDidLogoutUserCalled)
    }
    
    func testViewRequestedForLogoutMakesRequestToDeleteUser() {
        //Arrange
        self.accessServiceMock.getLastLoggedInUserIdentifierValue = 2
        //Act
        self.viewModel.viewRequestedForLogout()
        //Assert
        XCTAssertFalse(try self.userInterfaceMock.setActivityIndicatorIsHidden.unwrap())
        XCTAssertNil(self.errorHandlerMock.throwedError)
        XCTAssertNotNil(self.coreDataStackMock.deleteUserCompletion)
    }
    
    func testViewRequestedForLogoutThrowsAnError() {
        //Arrange
        let error = TestError(message: "error")
        self.accessServiceMock.getLastLoggedInUserIdentifierValue = 2
        //Act
        self.viewModel.viewRequestedForLogout()
        self.coreDataStackMock.deleteUserCompletion?(.failure(error))
        //Assert
        XCTAssertTrue(try self.userInterfaceMock.setActivityIndicatorIsHidden.unwrap())
        XCTAssertEqual(try (self.errorHandlerMock.throwedError as? TestError).unwrap(), error)
    }
    
    func testViewRequestedForLogoutSucceed() {
        //Arrange
        self.accessServiceMock.getLastLoggedInUserIdentifierValue = 2
        //Act
        self.viewModel.viewRequestedForLogout()
        self.coreDataStackMock.deleteUserCompletion?(.success(Void()))
        //Assert
        XCTAssertTrue(try self.userInterfaceMock.setActivityIndicatorIsHidden.unwrap())
        XCTAssertTrue(self.coordinatorMock.userProfileDidLogoutUserCalled)
    }
}
