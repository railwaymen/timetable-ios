//
//  AuthenticationCoordinatorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 30/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
import CoreData
@testable import TimeTable

class AuthenticationCoordinatorTests: XCTestCase {
 
    private var navigationController: UINavigationController!
    private var storyboardsManagerMock: StoryboardsManagerMock!
    private var errorHandlerMock: ErrorHandlerMock!
    private var apiClientMock: ApiClientMock!
    private var coreDataStackMock: CoreDataStackMock!
    private var accessServiceMock: AccessServiceMock!
    
    override func setUp() {
        self.navigationController = UINavigationController()
        self.storyboardsManagerMock = StoryboardsManagerMock()
        self.errorHandlerMock = ErrorHandlerMock()
        self.apiClientMock = ApiClientMock()
        self.coreDataStackMock = CoreDataStackMock()
        self.accessServiceMock = AccessServiceMock()
        super.setUp()
    }
    
    func testStartAuthenticationCoorinatorDoNotContainChildControllers() {
        //Arrange
        let coordinator = AuthenticationCoordinator(navigationController: navigationController,
                                                    storyboardsManager: storyboardsManagerMock,
                                                    accessService: accessServiceMock,
                                                    apiClient: apiClientMock,
                                                    errorHandler: errorHandlerMock,
                                                    coreDataStack: coreDataStackMock)
        //Act
        coordinator.start(finishCompletion: { _ in })
        //Assert
        XCTAssertTrue(coordinator.navigationController.children.isEmpty)
    }
    
    func testStartAuthenticationCoorinatorContainsChildControllers() {
        //Arrange
        let coordinator = AuthenticationCoordinator(navigationController: navigationController,
                                                    storyboardsManager: storyboardsManagerMock,
                                                    accessService: accessServiceMock,
                                                    apiClient: apiClientMock,
                                                    errorHandler: errorHandlerMock,
                                                    coreDataStack: coreDataStackMock)
        storyboardsManagerMock.controller = LoginViewControllerMock()
        //Act
        coordinator.start(finishCompletion: { _ in })
        //Assert
        XCTAssertEqual(coordinator.navigationController.children.count, 1)
    }
    
    func testFinishCompletionExecutedWhileLoginDidFinishDelegateCalled() {
        //Arrange
        var finishCompletionCalled = false
        let coordinator = AuthenticationCoordinator(navigationController: navigationController,
                                                    storyboardsManager: storyboardsManagerMock,
                                                    accessService: accessServiceMock,
                                                    apiClient: apiClientMock,
                                                    errorHandler: errorHandlerMock,
                                                    coreDataStack: coreDataStackMock)
        storyboardsManagerMock.controller = LoginViewControllerMock()
        coordinator.start(finishCompletion: {
            finishCompletionCalled = true
        })
        //Act
        coordinator.loginDidFinish(with: .loggedInCorrectly)
        //Assert
        XCTAssertTrue(finishCompletionCalled)
    }
}

private class StoryboardsManagerMock: StoryboardsManagerType {
    var controller: UIViewController?
    func controller<T>(storyboard: StoryboardsManager.StoryboardName, controllerIdentifier: StoryboardsManager.ControllerIdentifier) -> T? {
        return controller as? T
    }
}

private class ErrorHandlerMock: ErrorHandlerType {
    func catchingError(action: @escaping (Error) throws -> Void) -> ErrorHandlerType {
        return ErrorHandler(action: action)
    }
    
    func throwing(error: Error, finally: @escaping (Bool) -> Void) {}
}

private class LoginViewControllerMock: LoginViewControllerable {
    func configure(notificationCenter: NotificationCenterType, viewModel: LoginViewModelType) {}
    func setUpView(checkBoxIsActive: Bool) {}
    func updateLoginFields(email: String, password: String) {}    
    func tearDown() {}
    func passwordInputEnabledState(_ isEnabled: Bool) {}
    func loginButtonEnabledState(_ isEnabled: Bool) {}
    func checkBoxIsActiveState(_ isActive: Bool) {}
    func focusOnPasswordTextField() {}
}

private class ApiClientMock: ApiClientSessionType {
    
    private(set) var signInCredentials: LoginCredentials?
    private(set) var signInCompletion: ((Result<SessionDecoder>) -> Void)?
    
    func signIn(with credentials: LoginCredentials, completion: @escaping ((Result<SessionDecoder>) -> Void)) {
        signInCredentials = credentials
        signInCompletion = completion
    }
}

private class CoreDataStackMock: CoreDataStackType {
    func save<CDT>(userDecoder: SessionDecoder,
                   coreDataTypeTranslation: @escaping ((AsynchronousDataTransactionType) -> CDT),
                   completion: @escaping (Result<CDT>) -> Void) where CDT: NSManagedObject {}
    func fetchUser(forIdentifier identifier: Int, completion: @escaping (Result<UserEntity>) -> Void) {}
}

private class AccessServiceMock: AccessServiceLoginCredentialsType {
    func saveUser(credentails: LoginCredentials) throws {}
    func getUserCredentials() throws -> LoginCredentials {
        return LoginCredentials(email: "", password: "")
    }
}
