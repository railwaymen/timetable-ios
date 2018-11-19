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
    private var accessService: AccessServiceMock!
    private var viewModel: LoginViewModel!
    
    override func setUp() {
        userInterface = LoginViewControllerMock()
        coordinatorMock = LoginCoordinatorMock()
        contentProvider = LoginContentProviderMock()
        errorHandler = ErrorHandlerMock()
        accessService = AccessServiceMock()
        viewModel = LoginViewModel(userInterface: userInterface, coordinator: coordinatorMock, accessService: accessService,
                                   contentProvider: contentProvider, errorHandler: errorHandler)
        super.setUp()
    }
    
    func testViewDidLoadCallsSetUpView() {
        //Arrange
        //Act
        viewModel.viewDidLoad()
        //Assert
        XCTAssertTrue(userInterface.setUpViewCalledData.called)
    }
    
    func testViewDidSetsUpViewWithDefaultValueForCheckBoxButton() throws {
        //Arrange
        //Act
        viewModel.viewDidLoad()
        //Assert
        XCTAssertFalse(try userInterface.setUpViewCalledData.isActive.unwrap())
    }
    
    func testViewDidLoadUpdatesLoginFiledsWithEmptyValues() {
        //Arrange
        accessService.userCredentials = LoginCredentials(email: "", password: "")
        let viewModel = LoginViewModel(userInterface: userInterface, coordinator: coordinatorMock, accessService: accessService,
                                       contentProvider: contentProvider, errorHandler: errorHandler)
        //Act
        viewModel.viewDidLoad()
        //Assert
        XCTAssertEqual(userInterface.updateLoginFieldsData.email, "")
        XCTAssertEqual(userInterface.updateLoginFieldsData.password, "")
    }
    
    func testViewDidLoadUpdatesLoginFiledsWithFilledEmail() {
        //Arrange
        let email = "user@example.com"
        accessService.userCredentials = LoginCredentials(email: email, password: "")
        let viewModel = LoginViewModel(userInterface: userInterface, coordinator: coordinatorMock, accessService: accessService,
                                       contentProvider: contentProvider, errorHandler: errorHandler)
        //Act
        viewModel.viewDidLoad()
        //Assert
        XCTAssertEqual(userInterface.updateLoginFieldsData.email, email)
        XCTAssertEqual(userInterface.updateLoginFieldsData.password, "")
    }
    
    func testViewDidLoadUpdatesLoginFiledsWithFilledPassword() {
        //
        let password = "password"
        accessService.userCredentials = LoginCredentials(email: "", password: password)
        let viewModel = LoginViewModel(userInterface: userInterface,
                                       coordinator: coordinatorMock,
                                       accessService: accessService,
                                       contentProvider: contentProvider,
                                       errorHandler: errorHandler)
        //Act
        viewModel.viewDidLoad()
        //Assert
        XCTAssertEqual(userInterface.updateLoginFieldsData.email, "")
        XCTAssertEqual(userInterface.updateLoginFieldsData.password, password)
    }
    
    func testViewDidLoadUpdatesLoginFiledsWithCorrectLoginCredentials() {
        //Arrange
        let email = "user@example.com"
        let password = "password"
        accessService.userCredentials = LoginCredentials(email: email, password: password)
        let viewModel = LoginViewModel(userInterface: userInterface,
                                       coordinator: coordinatorMock,
                                       accessService: accessService,
                                       contentProvider: contentProvider,
                                       errorHandler: errorHandler)
        //Act
        viewModel.viewDidLoad()
        //Assert
        XCTAssertEqual(userInterface.updateLoginFieldsData.email, email)
        XCTAssertEqual(userInterface.updateLoginFieldsData.password, password)
    }
    
    func testViewRequestedToChangeServerAddressCallsTearDownOnTheUserInerface() {
        //Arrange
        //Act
        viewModel.viewRequestedToChangeServerAddress()
        //Assert
        XCTAssertTrue(userInterface.tearDownCalled)
    }
    
    func testViewRequestedToChangeServerAddressCallsLoginDidFinishOnTheCoordinator() {
        //Arrange
        //Act
        viewModel.viewRequestedToChangeServerAddress()
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
    
    func testShouldRemeberUserBoxStatusDidChangeToFalse() throws {
        //Arrange
        //Act
        viewModel.shouldRemeberUserBoxStatusDidChange(isActive: false)
        //Assert
        XCTAssertTrue(userInterface.checkBoxIsActiveStateValues.called)
        XCTAssertTrue(try userInterface.checkBoxIsActiveStateValues.isActive.unwrap())
    }
    
    func testShouldRemeberUserBoxStatusDidChangeToTrue() throws {
        //Arrange
        //Act
        viewModel.shouldRemeberUserBoxStatusDidChange(isActive: false)
        //Assert
        XCTAssertTrue(userInterface.checkBoxIsActiveStateValues.called)
        XCTAssertTrue(try userInterface.checkBoxIsActiveStateValues.isActive.unwrap())
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
        XCTAssertTrue(coordinatorMock.loginDidFinishCalled)
        XCTAssertEqual(coordinatorMock.loginDidFinishWithState, .loggedInCorrectly)
    }
    
    func testRequestedToLoginWithCorrectCredentialsAndShouldSaveUserCredenailsFails() throws {
        //Arrange
        viewModel.loginInputValueDidChange(value: "login")
        viewModel.passwordInputValueDidChange(value: "password")
        viewModel.shouldRemeberUserBoxStatusDidChange(isActive: false)
        accessService.saveUserIsThrowingError = true
        //Act
        viewModel.viewRequestedToLogin()
        contentProvider.completion?(.success(Void()))
        //Assert
        XCTAssertTrue(coordinatorMock.loginDidFinishCalled)
        XCTAssertEqual(coordinatorMock.loginDidFinishWithState, .loggedInCorrectly)
        XCTAssertEqual(try (errorHandler.throwedError as? TestError).unwrap(), TestError(messsage: "save user"))
    }
    
    func testRequestedToLoginWithCorrectCredentialsAndShouldSaveUserCredenailsSucceed() throws {
        //Arrange
        viewModel.loginInputValueDidChange(value: "login")
        viewModel.passwordInputValueDidChange(value: "password")
        viewModel.shouldRemeberUserBoxStatusDidChange(isActive: false)
        accessService.saveUserIsThrowingError = false
        //Act
        viewModel.viewRequestedToLogin()
        contentProvider.completion?(.success(Void()))
        //Assert
        XCTAssertTrue(coordinatorMock.loginDidFinishCalled)
        XCTAssertEqual(coordinatorMock.loginDidFinishWithState, .loggedInCorrectly)
        XCTAssertTrue(accessService.saveUserCalled)
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
    
    private(set) var setUpViewCalledData: (called: Bool, isActive: Bool?) = (false, nil)
    private(set) var updateLoginFieldsCalled = false
    private(set) var updateLoginFieldsData: (email: String?, password: String?)
    private(set) var tearDownCalled = false
    private(set) var passwordInputEnabledStateValues: (called: Bool, isEnabled: Bool?) = (false, nil)
    private(set) var loginButtonEnabledStateValues: (called: Bool, isEnabled: Bool?) = (false, nil)
    private(set) var checkBoxIsActiveStateValues: (called: Bool, isActive: Bool?) = (false, nil)
    private(set) var focusOnPasswordTextFieldCalled = false
    
    func setUpView(checkBoxIsActive: Bool) {
        setUpViewCalledData = (true, checkBoxIsActive)
    }
    
    func updateLoginFields(email: String, password: String) {
        updateLoginFieldsCalled = true
        updateLoginFieldsData = (email, password)
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
    
    func checkBoxIsActiveState(_ isActive: Bool) {
        checkBoxIsActiveStateValues = (true, isActive)
    }
    
    func focusOnPasswordTextField() {
        focusOnPasswordTextFieldCalled = true
    }
}

private class LoginCoordinatorMock: LoginCoordinatorDelegate {
    private(set) var loginDidFinishCalled = false
    private(set) var loginDidFinishWithState: AuthenticationCoordinator.State?
    
    func loginDidFinish(with state: AuthenticationCoordinator.State) {
        loginDidFinishCalled = true
        loginDidFinishWithState = state
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

private class AccessServiceMock: AccessServiceLoginCredentialsType {
    var saveUserIsThrowingError = false
    var userCredentials: LoginCredentials?
    private(set) var saveUserCalled = false
    
    func saveUser(credentails: LoginCredentials) throws {
        saveUserCalled = true
        if saveUserIsThrowingError {
            throw TestError(messsage: "save user")
        }
    }
    
    func getUserCredentials() throws -> LoginCredentials {
        if let credentails = userCredentials {
            return credentails
        } else {
            return LoginCredentials(email: "", password: "")
        }
    }
}
