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
    
    private lazy var decoder = JSONDecoder()
    
    override func setUp() {
        self.userInterface = LoginViewControllerMock()
        self.coordinatorMock = LoginCoordinatorMock()
        self.contentProvider = LoginContentProviderMock()
        self.errorHandler = ErrorHandlerMock()
        self.accessService = AccessServiceMock()
        self.viewModel = self.buildViewModel()
        super.setUp()
    }
    
    func testViewDidLoadCallsSetUpView() {
        //Arrange
        //Act
        self.viewModel.viewDidLoad()
        //Assert
        XCTAssertTrue(self.userInterface.setUpViewCalledData.called)
    }
    
    func testViewDidSetsUpViewWithDefaultValueForCheckBoxButton() throws {
        //Arrange
        //Act
        self.viewModel.viewDidLoad()
        //Assert
        XCTAssertFalse(try self.userInterface.setUpViewCalledData.isActive.unwrap())
    }
    
    func testViewDidLoadUpdatesLoginFiledsWithEmptyValues() {
        //Arrange
        self.accessService.getUserCredentialsReturnsError = true
        let viewModel = self.buildViewModel()
        //Act
        viewModel.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterface.updateLoginFieldsData.email, "")
        XCTAssertEqual(self.userInterface.updateLoginFieldsData.password, "")
    }
    
    func testViewDidLoadUpdatesLoginFiledsWithFilledEmail() {
        //Arrange
        let email = "user@example.com"
        self.accessService.userCredentials = LoginCredentials(email: email, password: "")
        let viewModel = self.buildViewModel()
        //Act
        viewModel.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterface.updateLoginFieldsData.email, email)
        XCTAssertEqual(self.userInterface.updateLoginFieldsData.password, "")
    }
    
    func testViewDidLoadUpdatesLoginFiledsWithFilledPassword() {
        //
        let password = "password"
        self.accessService.userCredentials = LoginCredentials(email: "", password: password)
        let viewModel = self.buildViewModel()
        //Act
        viewModel.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterface.updateLoginFieldsData.email, "")
        XCTAssertEqual(self.userInterface.updateLoginFieldsData.password, password)
    }
    
    func testViewDidLoadUpdatesLoginFiledsWithCorrectLoginCredentials() {
        //Arrange
        let email = "user@example.com"
        let password = "password"
        self.accessService.userCredentials = LoginCredentials(email: email, password: password)
        self.viewModel = self.buildViewModel()
        //Act
        self.viewModel.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterface.updateLoginFieldsData.email, email)
        XCTAssertEqual(self.userInterface.updateLoginFieldsData.password, password)
    }
    
    func testViewRequestedToChangeServerAddressCallsLoginDidFinishOnTheCoordinator() {
        //Arrange
        //Act
        self.viewModel.viewRequestedToChangeServerAddress()
        //Assert
        XCTAssertTrue(self.coordinatorMock.loginDidFinishCalled)
    }
    
    func testLoginTextFieldDidRequestForReturnWhileLoginCredentialsAreNil() {
        //Arrange
        //Act
        let value = self.viewModel.loginTextFieldDidRequestForReturn()
        //Assert
        XCTAssertFalse(value)
    }
    
    func testLoginTextFieldDidRequestForReturnWhilePasswordIsNil() {
        //Arrange
        self.viewModel.loginInputValueDidChange(value: "login")
        //Act
        let value = self.viewModel.loginTextFieldDidRequestForReturn()
        //Assert
        XCTAssertTrue(value)
    }
    
    func testLoginTextFieldDidRequestForReturnCallsFocusOnThePasswordTextField() {
        //Arrange
        self.viewModel.loginInputValueDidChange(value: "login")
        //Act
        _ = self.viewModel.loginTextFieldDidRequestForReturn()
        //Assert
        XCTAssertTrue(self.userInterface.focusOnPasswordTextFieldCalled)
    }
    
    func testLoginInputValueDidChangePassedNilValue() {
        //Arrange
        //Act
        self.viewModel.loginInputValueDidChange(value: nil)
        //Assert
        XCTAssertFalse(self.userInterface.passwordInputEnabledStateValues.called)
        XCTAssertNil(self.userInterface.passwordInputEnabledStateValues.isEnabled)
        XCTAssertFalse(self.userInterface.loginButtonEnabledStateValues.called)
        XCTAssertNil(self.userInterface.loginButtonEnabledStateValues.isEnabled)
    }
    
    func testLoginInputValueDidChange() throws {
        //Arrange
        //Act
        self.viewModel.loginInputValueDidChange(value: "login")
        //Assert
        XCTAssertTrue(self.userInterface.passwordInputEnabledStateValues.called)
        XCTAssertTrue(try self.userInterface.passwordInputEnabledStateValues.isEnabled.unwrap())
        XCTAssertTrue(self.userInterface.loginButtonEnabledStateValues.called)
        XCTAssertFalse(try self.userInterface.loginButtonEnabledStateValues.isEnabled.unwrap())
    }

    func testPasswordInputValueDidChangePassedNilValue() throws {
        //Arrange
        //Act
        self.viewModel.passwordInputValueDidChange(value: nil)
        //Assert
        XCTAssertFalse(self.userInterface.passwordInputEnabledStateValues.called)
        XCTAssertNil(self.userInterface.passwordInputEnabledStateValues.isEnabled)
        XCTAssertFalse(self.userInterface.loginButtonEnabledStateValues.called)
        XCTAssertNil(self.userInterface.loginButtonEnabledStateValues.isEnabled)
    }
    
    func testPasswordInputValueDidChangeWhileLoginValueIsNil() throws {
        //Arrange
        //Act
        self.viewModel.passwordInputValueDidChange(value: "password")
        //Assert
        XCTAssertTrue(self.userInterface.passwordInputEnabledStateValues.called)
        XCTAssertTrue(try self.userInterface.passwordInputEnabledStateValues.isEnabled.unwrap())
        XCTAssertTrue(self.userInterface.loginButtonEnabledStateValues.called)
        XCTAssertFalse(try self.userInterface.loginButtonEnabledStateValues.isEnabled.unwrap())
    }
    
    func testPasswordInputValueDidChangeWhileLoginValueIsNotNil() throws {
        //Arrange
        //Act
        self.viewModel.loginInputValueDidChange(value: "login")
        self.viewModel.passwordInputValueDidChange(value: "password")
        //Assert
        XCTAssertTrue(self.userInterface.passwordInputEnabledStateValues.called)
        XCTAssertTrue(try self.userInterface.passwordInputEnabledStateValues.isEnabled.unwrap())
        XCTAssertTrue(self.userInterface.loginButtonEnabledStateValues.called)
        XCTAssertTrue(try self.userInterface.loginButtonEnabledStateValues.isEnabled.unwrap())
    }

    func testPasswordTextFieldDidRequestForReturnWhileLoginIsEmpty() {
        //Arrange
        self.viewModel.passwordInputValueDidChange(value: "password")
        //Act
        let value = self.viewModel.passwordTextFieldDidRequestForReturn()
        //Assert
        XCTAssertFalse(value)
    }
    
    func testPasswordTextFieldDidRequestForReturnWhilePasswordIsEmpty() {
        //Arrange
        self.viewModel.loginInputValueDidChange(value: "login")
        //Act
        let value = self.viewModel.passwordTextFieldDidRequestForReturn()
        //Assert
        XCTAssertFalse(value)
    }
    
    func testPasswordTextFieldDidRequestForReturnWhileCredentialsAreCorrect() {
        //Arrange
        self.viewModel.loginInputValueDidChange(value: "login")
        self.viewModel.passwordInputValueDidChange(value: "password")
        //Act
        let value = self.viewModel.passwordTextFieldDidRequestForReturn()
        //Assert
        XCTAssertTrue(value)
    }
    
    func testShouldRemeberUserBoxStatusDidChangeToFalse() throws {
        //Arrange
        //Act
        self.viewModel.shouldRemeberUserBoxStatusDidChange(isActive: false)
        //Assert
        XCTAssertTrue(self.userInterface.checkBoxIsActiveStateValues.called)
        XCTAssertTrue(try self.userInterface.checkBoxIsActiveStateValues.isActive.unwrap())
    }
    
    func testShouldRemeberUserBoxStatusDidChangeToTrue() throws {
        //Arrange
        //Act
        self.viewModel.shouldRemeberUserBoxStatusDidChange(isActive: false)
        //Assert
        XCTAssertTrue(self.userInterface.checkBoxIsActiveStateValues.called)
        XCTAssertTrue(try self.userInterface.checkBoxIsActiveStateValues.isActive.unwrap())
    }
    
    func testViewRequestedToLoginWhileLoginIsEmpty() throws {
        //Arrange
        let expectedError = UIError.cannotBeEmpty(.loginTextField)
        //Act
        self.viewModel.viewRequestedToLogin()
        //Assert
        let error = try (self.errorHandler.throwedError as? UIError).unwrap()
        XCTAssertEqual(error, expectedError)
        XCTAssertNil(self.userInterface.setActivityIndicatorIsHidden)
    }
    
    func testViewRequestedToLoginWhilePasswordIsEmpty() throws {
        //Arrange
        let expectedError = UIError.cannotBeEmpty(.passwordTextField)
        self.viewModel.loginInputValueDidChange(value: "login")
        //Act
        self.viewModel.viewRequestedToLogin()
        //Assert
        let error = try (self.errorHandler.throwedError as? UIError).unwrap()
        XCTAssertEqual(error, expectedError)
        XCTAssertNil(self.userInterface.setActivityIndicatorIsHidden)
    }
    
    func testViewRequestedToLoginWithCorrectCredentials() throws {
        //Arrange
        self.viewModel.loginInputValueDidChange(value: "login")
        self.viewModel.passwordInputValueDidChange(value: "password")
        let data = try self.json(from: SessionJSONResource.signInResponse)
        let sessionReponse = try self.decoder.decode(SessionDecoder.self, from: data)
        //Act
        self.viewModel.viewRequestedToLogin()
        self.contentProvider.fetchCompletion?(.success(sessionReponse))
        //Assert
        XCTAssertTrue(self.coordinatorMock.loginDidFinishCalled)
        XCTAssertEqual(self.coordinatorMock.loginDidFinishWithState, .loggedInCorrectly(sessionReponse))
        XCTAssertFalse(try self.userInterface.setActivityIndicatorIsHidden.unwrap())
    }
    
    func testViewRequestedToLoginFailsWhileSavingToDataBase() throws {
        //Arrange
        let expectedError = TestError(message: "")
        self.viewModel.loginInputValueDidChange(value: "login")
        self.viewModel.passwordInputValueDidChange(value: "password")
        self.viewModel.shouldRemeberUserBoxStatusDidChange(isActive: false)
        let data = try self.json(from: SessionJSONResource.signInResponse)
        let sessionReponse = try self.decoder.decode(SessionDecoder.self, from: data)
        //Act
        self.viewModel.viewRequestedToLogin()
        self.contentProvider.fetchCompletion?(.success(sessionReponse))
        self.contentProvider.saveCompletion?(.failure(expectedError))
        //Assert
        XCTAssertTrue(try self.userInterface.setActivityIndicatorIsHidden.unwrap())
        switch self.errorHandler.throwedError as? AppError {
        case .cannotRemeberUserCredentials(let error)?:
               XCTAssertEqual(try (error as? TestError).unwrap(), expectedError)
        default:
            XCTFail()
        }
    }
    
    func testRequestedToLoginWithCorrectCredentialsAndShouldSaveUserCredenailsFails() throws {
        //Arrange
        self.viewModel.loginInputValueDidChange(value: "login")
        self.viewModel.passwordInputValueDidChange(value: "password")
        self.viewModel.shouldRemeberUserBoxStatusDidChange(isActive: false)
        self.accessService.saveUserIsThrowingError = true
        let data = try self.json(from: SessionJSONResource.signInResponse)
        let sessionReponse = try self.decoder.decode(SessionDecoder.self, from: data)
        //Act
        self.viewModel.viewRequestedToLogin()
        self.contentProvider.fetchCompletion?(.success(sessionReponse))
        self.contentProvider.saveCompletion?(.success(Void()))
        //Assert
        XCTAssertTrue(try self.userInterface.setActivityIndicatorIsHidden.unwrap())
        XCTAssertTrue(self.coordinatorMock.loginDidFinishCalled)
        XCTAssertEqual(self.coordinatorMock.loginDidFinishWithState, .loggedInCorrectly(sessionReponse))
        XCTAssertEqual(try (self.errorHandler.throwedError as? TestError).unwrap(), TestError(message: "save user"))
    }
    
    func testRequestedToLoginWithCorrectCredentialsAndShouldSaveUserCredenailsSucceed() throws {
        //Arrange
        self.viewModel.loginInputValueDidChange(value: "login")
        self.viewModel.passwordInputValueDidChange(value: "password")
        self.viewModel.shouldRemeberUserBoxStatusDidChange(isActive: false)
        self.accessService.saveUserIsThrowingError = false
        let data = try self.json(from: SessionJSONResource.signInResponse)
        let sessionReponse = try self.decoder.decode(SessionDecoder.self, from: data)
        //Act
        self.viewModel.viewRequestedToLogin()
        self.contentProvider.fetchCompletion?(.success(sessionReponse))
        self.contentProvider.saveCompletion?(.success(Void()))
        //Assert
        XCTAssertTrue(try self.userInterface.setActivityIndicatorIsHidden.unwrap())
        XCTAssertTrue(self.coordinatorMock.loginDidFinishCalled)
        XCTAssertEqual(self.coordinatorMock.loginDidFinishWithState, .loggedInCorrectly(sessionReponse))
        XCTAssertTrue(self.accessService.saveUserCalled)
    }
    
    func testViewRequestedToLoginContentProviderReturnsAnError() throws {
        //Arrange
        let expectedError = TestError(message: "errorOccured")
        self.viewModel.loginInputValueDidChange(value: "login")
        self.viewModel.passwordInputValueDidChange(value: "password")
        //Act
        self.viewModel.viewRequestedToLogin()
        self.contentProvider.fetchCompletion?(.failure(expectedError))
        //Assert
        let error = try (self.errorHandler.throwedError as? TestError).unwrap()
        XCTAssertEqual(error, expectedError)
        XCTAssertTrue(try self.userInterface.setActivityIndicatorIsHidden.unwrap())
    }
    
    // MARK: - Private
    private func buildViewModel() -> LoginViewModel {
        return LoginViewModel(userInterface: self.userInterface,
                              coordinator: self.coordinatorMock,
                              accessService: self.accessService,
                              contentProvider: self.contentProvider,
                              errorHandler: self.errorHandler)
    }
}
