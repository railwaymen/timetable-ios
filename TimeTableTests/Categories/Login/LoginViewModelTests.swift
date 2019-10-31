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
    
    private enum SessionResponse: String, JSONFileResource {
        case signInResponse
    }
    
    private lazy var decoder = JSONDecoder()
    
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
        accessService.getUserCredentialsReturnsError = true
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
        XCTAssertNil(userInterface.setActivityIndicatorIsHidden)
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
        XCTAssertNil(userInterface.setActivityIndicatorIsHidden)
    }
    
    func testViewRequestedToLoginWithCorrectCredentials() throws {
        //Arrange
        viewModel.loginInputValueDidChange(value: "login")
        viewModel.passwordInputValueDidChange(value: "password")
        let data = try self.json(from: SessionResponse.signInResponse)
        let sessionReponse = try decoder.decode(SessionDecoder.self, from: data)
        //Act
        viewModel.viewRequestedToLogin()
        contentProvider.fetchCompletion?(.success(sessionReponse))
        //Assert
        XCTAssertTrue(coordinatorMock.loginDidFinishCalled)
        XCTAssertEqual(coordinatorMock.loginDidFinishWithState, .loggedInCorrectly(sessionReponse))
        XCTAssertFalse(try userInterface.setActivityIndicatorIsHidden.unwrap())
    }
    
    func testViewRequestedToLoginFailsWhileSavingToDataBase() throws {
        //Arrange
        let expectedError = TestError(message: "")
        viewModel.loginInputValueDidChange(value: "login")
        viewModel.passwordInputValueDidChange(value: "password")
        viewModel.shouldRemeberUserBoxStatusDidChange(isActive: false)
        let data = try self.json(from: SessionResponse.signInResponse)
        let sessionReponse = try decoder.decode(SessionDecoder.self, from: data)
        //Act
        viewModel.viewRequestedToLogin()
        contentProvider.fetchCompletion?(.success(sessionReponse))
        contentProvider.saveCompletion?(.failure(expectedError))
        //Assert
        XCTAssertTrue(try userInterface.setActivityIndicatorIsHidden.unwrap())
        switch errorHandler.throwedError as? AppError {
        case .cannotRemeberUserCredentials(let error)?:
               XCTAssertEqual(try (error as? TestError).unwrap(), expectedError)
        default:
            XCTFail()
        }
    }
    
    func testRequestedToLoginWithCorrectCredentialsAndShouldSaveUserCredenailsFails() throws {
        //Arrange
        viewModel.loginInputValueDidChange(value: "login")
        viewModel.passwordInputValueDidChange(value: "password")
        viewModel.shouldRemeberUserBoxStatusDidChange(isActive: false)
        accessService.saveUserIsThrowingError = true
        let data = try self.json(from: SessionResponse.signInResponse)
        let sessionReponse = try decoder.decode(SessionDecoder.self, from: data)
        //Act
        viewModel.viewRequestedToLogin()
        contentProvider.fetchCompletion?(.success(sessionReponse))
        contentProvider.saveCompletion?(.success(Void()))
        //Assert
        XCTAssertTrue(try userInterface.setActivityIndicatorIsHidden.unwrap())
        XCTAssertTrue(coordinatorMock.loginDidFinishCalled)
        XCTAssertEqual(coordinatorMock.loginDidFinishWithState, .loggedInCorrectly(sessionReponse))
        XCTAssertEqual(try (errorHandler.throwedError as? TestError).unwrap(), TestError(message: "save user"))
    }
    
    func testRequestedToLoginWithCorrectCredentialsAndShouldSaveUserCredenailsSucceed() throws {
        //Arrange
        viewModel.loginInputValueDidChange(value: "login")
        viewModel.passwordInputValueDidChange(value: "password")
        viewModel.shouldRemeberUserBoxStatusDidChange(isActive: false)
        accessService.saveUserIsThrowingError = false
        let data = try self.json(from: SessionResponse.signInResponse)
        let sessionReponse = try decoder.decode(SessionDecoder.self, from: data)
        //Act
        viewModel.viewRequestedToLogin()
        contentProvider.fetchCompletion?(.success(sessionReponse))
        contentProvider.saveCompletion?(.success(Void()))
        //Assert
        XCTAssertTrue(try userInterface.setActivityIndicatorIsHidden.unwrap())
        XCTAssertTrue(coordinatorMock.loginDidFinishCalled)
        XCTAssertEqual(coordinatorMock.loginDidFinishWithState, .loggedInCorrectly(sessionReponse))
        XCTAssertTrue(accessService.saveUserCalled)
    }
    
    func testViewRequestedToLoginContentProviderReturnsAnError() throws {
        //Arrange
        let expectedError = TestError(message: "errorOccured")
        viewModel.loginInputValueDidChange(value: "login")
        viewModel.passwordInputValueDidChange(value: "password")
        //Act
        viewModel.viewRequestedToLogin()
        contentProvider.fetchCompletion?(.failure(expectedError))
        //Assert
        let error = try (errorHandler.throwedError as? TestError).unwrap()
        XCTAssertEqual(error, expectedError)
        XCTAssertTrue(try userInterface.setActivityIndicatorIsHidden.unwrap())
    }
}
