//
//  LoginViewModelTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 31/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class LoginViewModelTests: XCTestCase {
    
    private var userInterface: LoginViewControllerMock!
    private var coordinatorMock: LoginCoordinatorMock!
    private var contentProvider: LoginContentProviderMock!
    private var errorHandler: ErrorHandlerMock!
    private var viewModel: LoginViewModel!
    
    override func setUp() {
        userInterface = LoginViewControllerMock()
        coordinatorMock = LoginCoordinatorMock()
        contentProvider = LoginContentProviderMock()
        errorHandler = ErrorHandlerMock()
        viewModel = LoginViewModel(userInterface: userInterface, coordinator: coordinatorMock, contentProvider: contentProvider, errorHandler: errorHandler)
        super.setUp()
    }
    
    func testViewDidLoadCallsSetUpView() {
        //Arrange
        //Act
        viewModel.viewDidLoad()
        //Assert
        XCTAssertTrue(userInterface.setUpViewCalled)
    }
    
    func testViewWillDisappearCallsTearDownOnTheUserInerface() {
        //Arrange
        //Act
        viewModel.viewWillDisappear()
        //Assert
        XCTAssertTrue(userInterface.tearDownCalled)
    }
    
    func testViewWillDisappearCallsLoginDidFinishOnTheCoordinator() {
        //Arrange
        //Act
        viewModel.viewWillDisappear()
        //Assert
        XCTAssertTrue(coordinatorMock.loginDidFinishCalled)
    }
    
    func testLoginTextFieldDidRequestForReturnWhileLoginCredentialsAreNil() {
        //Arrange
        //Act
        let value = viewModel.loginTextFieldDidRequestForReturn()
        //Assert
        XCTAssertFalse(value)
    }
    
    func testLoginTextFieldDidRequestForReturnWhilePasswordIsNil() {
        //Arrange
        viewModel.loginInputValueDidChange(value: "login")
        //Act
        let value = viewModel.loginTextFieldDidRequestForReturn()
        //Assert
        XCTAssertTrue(value)
    }
    
    func testLoginTextFieldDidRequestForReturnCallsFocusOnThePasswordTextField() {
        //Arrange
        viewModel.loginInputValueDidChange(value: "login")
        //Act
        _ = viewModel.loginTextFieldDidRequestForReturn()
        //Assert
        XCTAssertTrue(userInterface.focusOnPasswordTextFieldCalled)
    }
    
    func testLoginInputValueDidChangePassedNilValue() {
        //Arrange
        //Act
        viewModel.loginInputValueDidChange(value: nil)
        //Assert
        XCTAssertFalse(userInterface.passwordInputEnabledStateValues.called)
        XCTAssertNil(userInterface.passwordInputEnabledStateValues.isEnabled)
        XCTAssertFalse(userInterface.loginButtonEnabledStateValues.called)
        XCTAssertNil(userInterface.loginButtonEnabledStateValues.isEnabled)
    }
    
    func testLoginInputValueDidChange() throws {
        //Arrange
        //Act
        viewModel.loginInputValueDidChange(value: "login")
        //Assert
        XCTAssertTrue(userInterface.passwordInputEnabledStateValues.called)
        XCTAssertTrue(try userInterface.passwordInputEnabledStateValues.isEnabled.unwrap())
        XCTAssertTrue(userInterface.loginButtonEnabledStateValues.called)
        XCTAssertFalse(try userInterface.loginButtonEnabledStateValues.isEnabled.unwrap())
    }

    func testPasswordInputValueDidChangePassedNilValue() throws {
        //Arrange
        //Act
        viewModel.passwordInputValueDidChange(value: nil)
        //Assert
        XCTAssertFalse(userInterface.passwordInputEnabledStateValues.called)
        XCTAssertNil(userInterface.passwordInputEnabledStateValues.isEnabled)
        XCTAssertFalse(userInterface.loginButtonEnabledStateValues.called)
        XCTAssertNil(userInterface.loginButtonEnabledStateValues.isEnabled)
    }
    
    func testPasswordInputValueDidChangeWhileLoginValueIsNil() throws {
        //Arrange
        //Act
        viewModel.passwordInputValueDidChange(value: "password")
        //Assert
        XCTAssertTrue(userInterface.passwordInputEnabledStateValues.called)
        XCTAssertTrue(try userInterface.passwordInputEnabledStateValues.isEnabled.unwrap())
        XCTAssertTrue(userInterface.loginButtonEnabledStateValues.called)
        XCTAssertFalse(try userInterface.loginButtonEnabledStateValues.isEnabled.unwrap())
    }
    
    func testPasswordInputValueDidChangeWhileLoginValueIsNotNil() throws {
        //Arrange
        //Act
        viewModel.loginInputValueDidChange(value: "login")
        viewModel.passwordInputValueDidChange(value: "password")
        //Assert
        XCTAssertTrue(userInterface.passwordInputEnabledStateValues.called)
        XCTAssertTrue(try userInterface.passwordInputEnabledStateValues.isEnabled.unwrap())
        XCTAssertTrue(userInterface.loginButtonEnabledStateValues.called)
        XCTAssertTrue(try userInterface.loginButtonEnabledStateValues.isEnabled.unwrap())
    }

    func testPasswordTextFieldDidRequestForReturnWhileLoginIsEmpty() {
        //Arrange
        viewModel.passwordInputValueDidChange(value: "password")
        //Act
        let value = viewModel.passwordTextFieldDidRequestForReturn()
        //Assert
        XCTAssertFalse(value)
    }
    
    func testPasswordTextFieldDidRequestForReturnWhilePasswordIsEmpty() {
        //Arrange
        viewModel.loginInputValueDidChange(value: "login")
        //Act
        let value = viewModel.passwordTextFieldDidRequestForReturn()
        //Assert
        XCTAssertFalse(value)
    }
    
    func testPasswordTextFieldDidRequestForReturnWhileCredentialsAreCorrect() {
        //Arrange
        viewModel.loginInputValueDidChange(value: "login")
        viewModel.passwordInputValueDidChange(value: "password")
        //Act
        let value = viewModel.passwordTextFieldDidRequestForReturn()
        //Assert
        XCTAssertTrue(value)
    }
    
    func testViewRequestedToLoginWhileLoginIsEmpty() throws {
        //Arrange
        let expectedError = UIError.cannotBeEmpty(.loginTextField)
        //Act
        viewModel.viewRequestedToLogin()
        //Assert
        let error = try (errorHandler.throwedError as? UIError).unwrap()
        XCTAssertEqual(error, expectedError)
    }
    
    func testViewRequestedToLoginWhilePasswordIsEmpty() throws {
        //Arrange
        let expectedError = UIError.cannotBeEmpty(.passwordTextField)
        viewModel.loginInputValueDidChange(value: "login")
        //Act
        viewModel.viewRequestedToLogin()
        //Assert
        let error = try (errorHandler.throwedError as? UIError).unwrap()
        XCTAssertEqual(error, expectedError)
    }
    
    func testViewRequestedToLoginWithCorrectCredentials() {
        //Arrange
        viewModel.loginInputValueDidChange(value: "login")
        viewModel.passwordInputValueDidChange(value: "password")
        //Act
        viewModel.viewRequestedToLogin()
        contentProvider.completion?(.success(Void()))
        //Assert
        XCTAssertTrue(coordinatorMock.loginDidFinishWithSuccessCalled)
    }
    
    func testViewRequestedToLoginContentProviderReturnsAnError() throws {
        //Arrange
        let expectedError = TestError(messsage: "errorOccured")
        viewModel.loginInputValueDidChange(value: "login")
        viewModel.passwordInputValueDidChange(value: "password")
        //Act
        viewModel.viewRequestedToLogin()
        contentProvider.completion?(.failure(expectedError))
        //Assert
        let error = try (errorHandler.throwedError as? TestError).unwrap()
        XCTAssertEqual(error, expectedError)
    }
}

private class LoginViewControllerMock: LoginViewModelOutput {
    private(set) var setUpViewCalled = false
    private(set) var tearDownCalled = false
    private(set) var passwordInputEnabledStateValues: (called: Bool, isEnabled: Bool?) = (false, nil)
    private(set) var loginButtonEnabledStateValues: (called: Bool, isEnabled: Bool?) = (false, nil)
    private(set) var focusOnPasswordTextFieldCalled = false
    
    func setUpView() {
        setUpViewCalled = true
    }
    
    func tearDown() {
        tearDownCalled = true
    }
    
    func passwordInputEnabledState(_ isEnabled: Bool) {
        passwordInputEnabledStateValues = (true, isEnabled)
    }
    
    func loginButtonEnabledState(_ isEnabled: Bool) {
        loginButtonEnabledStateValues = (true, isEnabled)
    }
    
    func focusOnPasswordTextField() {
        focusOnPasswordTextFieldCalled = true
    }
}

private class LoginCoordinatorMock: LoginCoordinatorDelegate {
    private(set) var loginDidFinishCalled = false
    private(set) var loginDidFinishWithSuccessCalled = false
    
    func loginDidFinish() {
        loginDidFinishCalled = true
    }
    
    func loginDidFinishWithSuccess() {
        loginDidFinishWithSuccessCalled = true
    }
}

private class ErrorHandlerMock: ErrorHandlerType {
    private(set) var throwedError: Error?
    private(set) var throwingFinallyBlock: ((Bool) -> Void)?
    private(set) var catchingErrorActionBlock: ((Error) throws -> Void)?
    
    func throwing(error: Error, finally: @escaping (Bool) -> Void) {
        throwedError = error
        throwingFinallyBlock = finally
    }
    
    func catchingError(action: @escaping (Error) throws -> Void) -> ErrorHandlerType {
        catchingErrorActionBlock = action
        return self
    }
}

private class LoginContentProviderMock: LoginContentProviderType {
    private(set) var loginCredentials: LoginCredentials?
    private(set) var completion: ((Result<Void>) -> Void)?
    
    func login(with credentials: LoginCredentials, completion: @escaping ((Result<Void>) -> Void)) {
        self.loginCredentials = credentials
        self.completion = completion
    }
}

private struct TestError: Error {
    let messsage: String
}

extension TestError: Equatable {
    static func == (lhs: TestError, rhs: TestError) -> Bool {
        return lhs.messsage == rhs.messsage
    }
}
