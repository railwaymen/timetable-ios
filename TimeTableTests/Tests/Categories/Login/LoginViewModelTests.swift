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
        XCTAssertEqual(self.userInterface.setUpViewParams.count, 1)
    }
    
    func testViewDidSetsUpViewWithDefaultValueForCheckBoxButton() throws {
        //Arrange
        //Act
        self.viewModel.viewDidLoad()
        //Assert
        XCTAssertFalse(try (self.userInterface.setUpViewParams.last?.checkBoxIsActive).unwrap())
    }
    
    func testViewDidLoadUpdatesLoginFiledsWithEmptyValues() {
        //Arrange
        self.accessService.getUserCredentialsThrowError = TestError(message: "Test")
        let viewModel = self.buildViewModel()
        //Act
        viewModel.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterface.updateLoginFieldsParams.last?.email, "")
        XCTAssertEqual(self.userInterface.updateLoginFieldsParams.last?.password, "")
    }
    
    func testViewDidLoadUpdatesLoginFiledsWithFilledEmail() {
        //Arrange
        let email = "user@example.com"
        self.accessService.getUserCredentialsReturnValue = LoginCredentials(email: email, password: "")
        let viewModel = self.buildViewModel()
        //Act
        viewModel.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterface.updateLoginFieldsParams.last?.email, email)
        XCTAssertEqual(self.userInterface.updateLoginFieldsParams.last?.password, "")
    }
    
    func testViewDidLoadUpdatesLoginFiledsWithFilledPassword() {
        //
        let password = "password"
        self.accessService.getUserCredentialsReturnValue = LoginCredentials(email: "", password: password)
        let viewModel = self.buildViewModel()
        //Act
        viewModel.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterface.updateLoginFieldsParams.last?.email, "")
        XCTAssertEqual(self.userInterface.updateLoginFieldsParams.last?.password, password)
    }
    
    func testViewDidLoadUpdatesLoginFiledsWithCorrectLoginCredentials() {
        //Arrange
        let email = "user@example.com"
        let password = "password"
        self.accessService.getUserCredentialsReturnValue = LoginCredentials(email: email, password: password)
        self.viewModel = self.buildViewModel()
        //Act
        self.viewModel.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterface.updateLoginFieldsParams.last?.email, email)
        XCTAssertEqual(self.userInterface.updateLoginFieldsParams.last?.password, password)
    }
    
    func testViewRequestedToChangeServerAddressCallsLoginDidFinishOnTheCoordinator() {
        //Arrange
        //Act
        self.viewModel.viewRequestedToChangeServerAddress()
        //Assert
        XCTAssertEqual(self.coordinatorMock.loginDidFinishParams.count, 1)
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
        XCTAssertEqual(self.userInterface.focusOnPasswordTextFieldParams.count, 1)
    }
    
    func testLoginInputValueDidChangePassedNilValue() {
        //Arrange
        //Act
        self.viewModel.loginInputValueDidChange(value: nil)
        //Assert
        XCTAssertTrue(self.userInterface.passwordInputEnabledStateParams.isEmpty)
        XCTAssertTrue(self.userInterface.loginButtonEnabledStateParams.isEmpty)
    }
    
    func testLoginInputValueDidChange() throws {
        //Arrange
        //Act
        self.viewModel.loginInputValueDidChange(value: "login")
        //Assert
        XCTAssertEqual(self.userInterface.passwordInputEnabledStateParams.count, 1)
        XCTAssertTrue(try (self.userInterface.passwordInputEnabledStateParams.last?.isEnabled).unwrap())
        XCTAssertEqual(self.userInterface.loginButtonEnabledStateParams.count, 1)
        XCTAssertFalse(try (self.userInterface.loginButtonEnabledStateParams.last?.isEnabled).unwrap())
    }

    func testPasswordInputValueDidChangePassedNilValue() throws {
        //Arrange
        //Act
        self.viewModel.passwordInputValueDidChange(value: nil)
        //Assert
        XCTAssertTrue(self.userInterface.passwordInputEnabledStateParams.isEmpty)
        XCTAssertTrue(self.userInterface.loginButtonEnabledStateParams.isEmpty)
    }
    
    func testPasswordInputValueDidChangeWhileLoginValueIsNil() throws {
        //Arrange
        //Act
        self.viewModel.passwordInputValueDidChange(value: "password")
        //Assert
        XCTAssertEqual(self.userInterface.passwordInputEnabledStateParams.count, 1)
        XCTAssertTrue(try (self.userInterface.passwordInputEnabledStateParams.last?.isEnabled).unwrap())
        XCTAssertEqual(self.userInterface.loginButtonEnabledStateParams.count, 1)
        XCTAssertFalse(try (self.userInterface.loginButtonEnabledStateParams.last?.isEnabled).unwrap())
    }
    
    func testPasswordInputValueDidChangeWhileLoginValueIsNotNil() throws {
        //Arrange
        //Act
        self.viewModel.loginInputValueDidChange(value: "login")
        self.viewModel.passwordInputValueDidChange(value: "password")
        //Assert
        XCTAssertEqual(self.userInterface.passwordInputEnabledStateParams.count, 2)
        XCTAssertTrue(try (self.userInterface.passwordInputEnabledStateParams.last?.isEnabled).unwrap())
        XCTAssertEqual(self.userInterface.loginButtonEnabledStateParams.count, 2)
        XCTAssertTrue(try (self.userInterface.loginButtonEnabledStateParams.last?.isEnabled).unwrap())
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
        XCTAssertEqual(self.userInterface.checkBoxIsActiveStateParams.count, 1)
        XCTAssertTrue(try (self.userInterface.checkBoxIsActiveStateParams.last?.isActive).unwrap())
    }
    
    func testShouldRemeberUserBoxStatusDidChangeToTrue() throws {
        //Arrange
        //Act
        self.viewModel.shouldRemeberUserBoxStatusDidChange(isActive: false)
        //Assert
        XCTAssertEqual(self.userInterface.checkBoxIsActiveStateParams.count, 1)
        XCTAssertTrue(try (self.userInterface.checkBoxIsActiveStateParams.last?.isActive).unwrap())
    }
    
    func testViewRequestedToLoginWhileLoginIsEmpty() throws {
        //Arrange
        let expectedError = UIError.cannotBeEmpty(.loginTextField)
        //Act
        self.viewModel.viewRequestedToLogin()
        //Assert
        let error = try (self.errorHandler.throwingParams.last?.error as? UIError).unwrap()
        XCTAssertEqual(error, expectedError)
        XCTAssertTrue(self.userInterface.setActivityIndicatorParams.isEmpty)
    }
    
    func testViewRequestedToLoginWhilePasswordIsEmpty() throws {
        //Arrange
        let expectedError = UIError.cannotBeEmpty(.passwordTextField)
        self.viewModel.loginInputValueDidChange(value: "login")
        //Act
        self.viewModel.viewRequestedToLogin()
        //Assert
        let error = try (self.errorHandler.throwingParams.last?.error as? UIError).unwrap()
        XCTAssertEqual(error, expectedError)
        XCTAssertTrue(self.userInterface.setActivityIndicatorParams.isEmpty)
    }
    
    func testViewRequestedToLoginWithCorrectCredentials() throws {
        //Arrange
        self.viewModel.loginInputValueDidChange(value: "login")
        self.viewModel.passwordInputValueDidChange(value: "password")
        let data = try self.json(from: SessionJSONResource.signInResponse)
        let sessionReponse = try self.decoder.decode(SessionDecoder.self, from: data)
        //Act
        self.viewModel.viewRequestedToLogin()
        self.contentProvider.loginParams.last?.fetchCompletion(.success(sessionReponse))
        //Assert
        XCTAssertEqual(self.coordinatorMock.loginDidFinishParams.count, 1)
        XCTAssertEqual(self.coordinatorMock.loginDidFinishParams.last?.state, .loggedInCorrectly(sessionReponse))
        XCTAssertEqual(self.userInterface.setActivityIndicatorParams.count, 1)
        XCTAssertFalse(try (self.userInterface.setActivityIndicatorParams.last?.isHidden).unwrap())
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
        self.contentProvider.loginParams.last?.fetchCompletion(.success(sessionReponse))
        self.contentProvider.loginParams.last?.saveCompletion(.failure(expectedError))
        //Assert
        XCTAssertEqual(self.userInterface.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try (self.userInterface.setActivityIndicatorParams.last?.isHidden).unwrap())
        switch self.errorHandler.throwingParams.last?.error as? AppError {
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
        let thrownError = TestError(message: "Test")
        self.accessService.saveUserThrowError = thrownError
        let data = try self.json(from: SessionJSONResource.signInResponse)
        let sessionReponse = try self.decoder.decode(SessionDecoder.self, from: data)
        //Act
        self.viewModel.viewRequestedToLogin()
        self.contentProvider.loginParams.last?.fetchCompletion(.success(sessionReponse))
        self.contentProvider.loginParams.last?.saveCompletion(.success(Void()))
        //Assert
        XCTAssertEqual(self.userInterface.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try (self.userInterface.setActivityIndicatorParams.last?.isHidden).unwrap())
        XCTAssertEqual(self.coordinatorMock.loginDidFinishParams.count, 1)
        XCTAssertEqual(self.coordinatorMock.loginDidFinishParams.last?.state, .loggedInCorrectly(sessionReponse))
        XCTAssertEqual(try (self.errorHandler.throwingParams.last?.error as? TestError).unwrap(), thrownError)
    }
    
    func testRequestedToLoginWithCorrectCredentialsAndShouldSaveUserCredenailsSucceed() throws {
        //Arrange
        self.viewModel.loginInputValueDidChange(value: "login")
        self.viewModel.passwordInputValueDidChange(value: "password")
        self.viewModel.shouldRemeberUserBoxStatusDidChange(isActive: false)
        self.accessService.saveUserThrowError = TestError(message: "Test")
        let data = try self.json(from: SessionJSONResource.signInResponse)
        let sessionReponse = try self.decoder.decode(SessionDecoder.self, from: data)
        //Act
        self.viewModel.viewRequestedToLogin()
        self.contentProvider.loginParams.last?.fetchCompletion(.success(sessionReponse))
        self.contentProvider.loginParams.last?.saveCompletion(.success(Void()))
        //Assert
        XCTAssertEqual(self.userInterface.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try (self.userInterface.setActivityIndicatorParams.last?.isHidden).unwrap())
        XCTAssertEqual(self.coordinatorMock.loginDidFinishParams.count, 1)
        XCTAssertEqual(self.coordinatorMock.loginDidFinishParams.last?.state, .loggedInCorrectly(sessionReponse))
        XCTAssertEqual(self.accessService.saveUserParams.count, 1)
    }
    
    func testViewRequestedToLoginContentProviderReturnsAnError() throws {
        //Arrange
        let expectedError = TestError(message: "errorOccured")
        self.viewModel.loginInputValueDidChange(value: "login")
        self.viewModel.passwordInputValueDidChange(value: "password")
        //Act
        self.viewModel.viewRequestedToLogin()
        self.contentProvider.loginParams.last?.fetchCompletion(.failure(expectedError))
        //Assert
        let error = try (self.errorHandler.throwingParams.last?.error as? TestError).unwrap()
        XCTAssertEqual(error, expectedError)
        XCTAssertEqual(self.userInterface.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try (self.userInterface.setActivityIndicatorParams.last?.isHidden).unwrap())
    }
}

// MARK: - Private
extension LoginViewModelTests {
    private func buildViewModel() -> LoginViewModel {
        return LoginViewModel(userInterface: self.userInterface,
                              coordinator: self.coordinatorMock,
                              accessService: self.accessService,
                              contentProvider: self.contentProvider,
                              errorHandler: self.errorHandler)
    }
}
