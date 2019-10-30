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
    
    private enum UserResponse: String, JSONFileResource {
        case userFullResponse
    }
    
    private lazy var decoder = JSONDecoder()
    
    override func setUp() {
        userInterfaceMock = ProfileViewControllerMock()
        coordinatorMock = ProfileCoordinatorMock()
        apiClientMock = ApiClientMock()
        accessServiceMock = AccessServiceMock()
        coreDataStackMock = CoreDataStackMock()
        errorHandlerMock = ErrorHandlerMock()
        
        viewModel = ProfileViewModel(userInterface: userInterfaceMock,
                                         coordinator: coordinatorMock,
                                         apiClient: apiClientMock,
                                         accessService: accessServiceMock,
                                         coreDataStack: coreDataStackMock,
                                         errorHandler: errorHandlerMock)
        super.setUp()
    }
    
    func testViewDidLoadCallsSetUpViewOnTheUserInterface() {
        //Act
        viewModel.viewDidLoad()
        //Assert
        XCTAssertTrue(userInterfaceMock.setUpCalled)
    }
    
    func testViewDidLoadDoesNotUpdateUserInterfaceAndThorwsErrorWhileLastUserIdetifierIsNil() {
        //Arrange
        accessServiceMock.getLastLoggedInUserIdentifierValue = nil
        //Act
        viewModel.viewDidLoad()
        //Assert
        XCTAssertNil(errorHandlerMock.throwedError)
        XCTAssertNil(userInterfaceMock.updateValues.0)
        XCTAssertNil(userInterfaceMock.updateValues.1)
        XCTAssertNil(userInterfaceMock.updateValues.2)
    }
    
    func testViewDidLoadFetchUserProfileFails() throws {
        //Arrange
        let error = TestError(message: "error")
        accessServiceMock.getLastLoggedInUserIdentifierValue = 2
        //Act
        viewModel.viewDidLoad()
        apiClientMock.fetchUserProfileCompletion?(.failure(error))
        //Assert
        XCTAssertEqual(try (errorHandlerMock.throwedError as? TestError).unwrap(), error)
    }
    
    func testViewDidLoadFetchUserProfileSucceed() throws {
        //Arrange
        accessServiceMock.getLastLoggedInUserIdentifierValue = 2
        let data = try self.json(from: UserResponse.userFullResponse)
        let userDecoder = try decoder.decode(UserDecoder.self, from: data)
        //Act
        viewModel.viewDidLoad()
        apiClientMock.fetchUserProfileCompletion?(.success(userDecoder))
        //Assert
        XCTAssertEqual(userInterfaceMock.updateValues.0, "John")
        XCTAssertEqual(userInterfaceMock.updateValues.1, "Little")
        XCTAssertEqual(userInterfaceMock.updateValues.2, "john.little@example.com")
    }
    
    func testViewRequestedForLogoutReturnsWhileUserIdentifierIsNil() {
        //Act
        viewModel.viewRequestedForLogout()
        //Assert
        XCTAssertNil(errorHandlerMock.throwedError)
        XCTAssertFalse(coordinatorMock.userProfileDidLogoutUserCalled)
    }
    
    func testViewRequestedForLogoutThorwsAnError() {
        //Arrange
        let error = TestError(message: "error")
        accessServiceMock.getLastLoggedInUserIdentifierValue = 2
        //Act
        viewModel.viewRequestedForLogout()
        coreDataStackMock.deleteUserCompletion?(.failure(error))
        //Assert
        XCTAssertEqual(try (errorHandlerMock.throwedError as? TestError).unwrap(), error)
    }
    
    func testViewRequestedForLogoutSucceed() {
        //Arrange
        accessServiceMock.getLastLoggedInUserIdentifierValue = 2
        //Act
        viewModel.viewRequestedForLogout()
        coreDataStackMock.deleteUserCompletion?(.success(Void()))
        //Assert
        XCTAssertTrue(self.coordinatorMock.userProfileDidLogoutUserCalled)
    }
}
