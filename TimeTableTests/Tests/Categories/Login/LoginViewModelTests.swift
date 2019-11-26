//
//  LoginViewModelTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 31/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

// swiftlint:disable type_body_length
class LoginViewModelTests: XCTestCase {
    private var userInterface: LoginViewControllerMock!
    private var coordinatorMock: LoginCoordinatorMock!
    private var contentProvider: LoginContentProviderMock!
    private var errorHandler: ErrorHandlerMock!
    private var accessService: AccessServiceMock!
        
    override func setUp() {
        super.setUp()
        self.userInterface = LoginViewControllerMock()
        self.coordinatorMock = LoginCoordinatorMock()
        self.contentProvider = LoginContentProviderMock()
        self.errorHandler = ErrorHandlerMock()
        self.accessService = AccessServiceMock()
    }
    
    func testViewDidLoadCallsSetUpView() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterface.setUpViewParams.count, 1)
    }
    
    func testViewDidSetsUpViewWithDefaultValueForCheckBoxButton() throws {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertFalse(try (self.userInterface.setUpViewParams.last?.checkBoxIsActive).unwrap())
    }
    
    func testViewDidLoadUpdatesLoginFiledsWithEmptyValues() {
        //Arrange
        self.accessService.getUserCredentialsThrowError = TestError(message: "Test")
        let sut = self.buildSUT()
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterface.updateLoginFieldsParams.last?.email, "")
        XCTAssertEqual(self.userInterface.updateLoginFieldsParams.last?.password, "")
    }
    
    func testViewDidLoadUpdatesLoginFiledsWithFilledEmail() {
        //Arrange
        let email = "user@example.com"
        self.accessService.getUserCredentialsReturnValue = LoginCredentials(email: email, password: "")
        let sut = self.buildSUT()
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterface.updateLoginFieldsParams.last?.email, email)
        XCTAssertEqual(self.userInterface.updateLoginFieldsParams.last?.password, "")
    }
    
    func testViewDidLoadUpdatesLoginFiledsWithFilledPassword() {
        //
        let password = "password"
        self.accessService.getUserCredentialsReturnValue = LoginCredentials(email: "", password: password)
        let sut = self.buildSUT()
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterface.updateLoginFieldsParams.last?.email, "")
        XCTAssertEqual(self.userInterface.updateLoginFieldsParams.last?.password, password)
    }
    
    func testViewDidLoadUpdatesLoginFiledsWithCorrectLoginCredentials() {
        //Arrange
        let email = "user@example.com"
        let password = "password"
        self.accessService.getUserCredentialsReturnValue = LoginCredentials(email: email, password: password)
        let sut = self.buildSUT()
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterface.updateLoginFieldsParams.last?.email, email)
        XCTAssertEqual(self.userInterface.updateLoginFieldsParams.last?.password, password)
    }
    
    func testViewRequestedToChangeServerAddressCallsLoginDidFinishOnTheCoordinator() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.viewRequestedToChangeServerAddress()
        //Assert
        XCTAssertEqual(self.coordinatorMock.loginDidFinishParams.count, 1)
    }
    
    func testLoginTextFieldDidRequestForReturnWhileLoginCredentialsAreNil() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        let value = sut.loginTextFieldDidRequestForReturn()
        //Assert
        XCTAssertFalse(value)
    }
    
    func testLoginTextFieldDidRequestForReturnWhilePasswordIsNil() {
        //Arrange
        let sut = self.buildSUT()
        sut.loginInputValueDidChange(value: "login")
        //Act
        let value = sut.loginTextFieldDidRequestForReturn()
        //Assert
        XCTAssertTrue(value)
    }
    
    func testLoginTextFieldDidRequestForReturnCallsFocusOnThePasswordTextField() {
        //Arrange
        let sut = self.buildSUT()
        sut.loginInputValueDidChange(value: "login")
        //Act
        _ = sut.loginTextFieldDidRequestForReturn()
        //Assert
        XCTAssertEqual(self.userInterface.focusOnPasswordTextFieldParams.count, 1)
    }
    
    func testLoginInputValueDidChangePassedNilValue() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.loginInputValueDidChange(value: nil)
        //Assert
        XCTAssertTrue(self.userInterface.passwordInputEnabledStateParams.isEmpty)
        XCTAssertTrue(self.userInterface.loginButtonEnabledStateParams.isEmpty)
    }
    
    func testLoginInputValueDidChange() throws {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.loginInputValueDidChange(value: "login")
        //Assert
        XCTAssertEqual(self.userInterface.passwordInputEnabledStateParams.count, 1)
        XCTAssertTrue(try (self.userInterface.passwordInputEnabledStateParams.last?.isEnabled).unwrap())
        XCTAssertEqual(self.userInterface.loginButtonEnabledStateParams.count, 1)
        XCTAssertFalse(try (self.userInterface.loginButtonEnabledStateParams.last?.isEnabled).unwrap())
    }

    func testPasswordInputValueDidChangePassedNilValue() throws {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.passwordInputValueDidChange(value: nil)
        //Assert
        XCTAssertTrue(self.userInterface.passwordInputEnabledStateParams.isEmpty)
        XCTAssertTrue(self.userInterface.loginButtonEnabledStateParams.isEmpty)
    }
    
    func testPasswordInputValueDidChangeWhileLoginValueIsNil() throws {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.passwordInputValueDidChange(value: "password")
        //Assert
        XCTAssertEqual(self.userInterface.passwordInputEnabledStateParams.count, 1)
        XCTAssertTrue(try (self.userInterface.passwordInputEnabledStateParams.last?.isEnabled).unwrap())
        XCTAssertEqual(self.userInterface.loginButtonEnabledStateParams.count, 1)
        XCTAssertFalse(try (self.userInterface.loginButtonEnabledStateParams.last?.isEnabled).unwrap())
    }
    
    func testPasswordInputValueDidChangeWhileLoginValueIsNotNil() throws {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.loginInputValueDidChange(value: "login")
        sut.passwordInputValueDidChange(value: "password")
        //Assert
        XCTAssertEqual(self.userInterface.passwordInputEnabledStateParams.count, 2)
        XCTAssertTrue(try (self.userInterface.passwordInputEnabledStateParams.last?.isEnabled).unwrap())
        XCTAssertEqual(self.userInterface.loginButtonEnabledStateParams.count, 2)
        XCTAssertTrue(try (self.userInterface.loginButtonEnabledStateParams.last?.isEnabled).unwrap())
    }

    func testPasswordTextFieldDidRequestForReturnWhileLoginIsEmpty() {
        //Arrange
        let sut = self.buildSUT()
        sut.passwordInputValueDidChange(value: "password")
        //Act
        let value = sut.passwordTextFieldDidRequestForReturn()
        //Assert
        XCTAssertFalse(value)
    }
    
    func testPasswordTextFieldDidRequestForReturnWhilePasswordIsEmpty() {
        //Arrange
        let sut = self.buildSUT()
        sut.loginInputValueDidChange(value: "login")
        //Act
        let value = sut.passwordTextFieldDidRequestForReturn()
        //Assert
        XCTAssertFalse(value)
    }
    
    func testPasswordTextFieldDidRequestForReturnWhileCredentialsAreCorrect() {
        //Arrange
        let sut = self.buildSUT()
        sut.loginInputValueDidChange(value: "login")
        sut.passwordInputValueDidChange(value: "password")
        //Act
        let value = sut.passwordTextFieldDidRequestForReturn()
        //Assert
        XCTAssertTrue(value)
    }
    
    func testShouldRemeberUserBoxStatusDidChangeToFalse() throws {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.shouldRemeberUserBoxStatusDidChange(isActive: false)
        //Assert
        XCTAssertEqual(self.userInterface.checkBoxIsActiveStateParams.count, 1)
        XCTAssertTrue(try (self.userInterface.checkBoxIsActiveStateParams.last?.isActive).unwrap())
    }
    
    func testShouldRemeberUserBoxStatusDidChangeToTrue() throws {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.shouldRemeberUserBoxStatusDidChange(isActive: false)
        //Assert
        XCTAssertEqual(self.userInterface.checkBoxIsActiveStateParams.count, 1)
        XCTAssertTrue(try (self.userInterface.checkBoxIsActiveStateParams.last?.isActive).unwrap())
    }
    
    func testViewRequestedToLoginWhileLoginIsEmpty() throws {
        //Arrange
        let expectedError = UIError.cannotBeEmpty(.loginTextField)
        let sut = self.buildSUT()
        //Act
        sut.viewRequestedToLogin()
        //Assert
        let error = try (self.errorHandler.throwingParams.last?.error as? UIError).unwrap()
        XCTAssertEqual(error, expectedError)
        XCTAssertTrue(self.userInterface.setActivityIndicatorParams.isEmpty)
    }
    
    func testViewRequestedToLoginWhilePasswordIsEmpty() throws {
        //Arrange
        let expectedError = UIError.cannotBeEmpty(.passwordTextField)
        let sut = self.buildSUT()
        sut.loginInputValueDidChange(value: "login")
        //Act
        sut.viewRequestedToLogin()
        //Assert
        let error = try (self.errorHandler.throwingParams.last?.error as? UIError).unwrap()
        XCTAssertEqual(error, expectedError)
        XCTAssertTrue(self.userInterface.setActivityIndicatorParams.isEmpty)
    }
    
    func testViewRequestedToLoginWithCorrectCredentials() throws {
        //Arrange
        let sut = self.buildSUT()
        sut.loginInputValueDidChange(value: "login")
        sut.passwordInputValueDidChange(value: "password")
        let data = try self.json(from: SessionJSONResource.signInResponse)
        let sessionReponse = try self.decoder.decode(SessionDecoder.self, from: data)
        //Act
        sut.viewRequestedToLogin()
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
        let sut = self.buildSUT()
        sut.loginInputValueDidChange(value: "login")
        sut.passwordInputValueDidChange(value: "password")
        sut.shouldRemeberUserBoxStatusDidChange(isActive: false)
        let data = try self.json(from: SessionJSONResource.signInResponse)
        let sessionReponse = try self.decoder.decode(SessionDecoder.self, from: data)
        //Act
        sut.viewRequestedToLogin()
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
        let sut = self.buildSUT()
        sut.loginInputValueDidChange(value: "login")
        sut.passwordInputValueDidChange(value: "password")
        sut.shouldRemeberUserBoxStatusDidChange(isActive: false)
        let thrownError = TestError(message: "Test")
        self.accessService.saveUserThrowError = thrownError
        let data = try self.json(from: SessionJSONResource.signInResponse)
        let sessionReponse = try self.decoder.decode(SessionDecoder.self, from: data)
        //Act
        sut.viewRequestedToLogin()
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
        let sut = self.buildSUT()
        sut.loginInputValueDidChange(value: "login")
        sut.passwordInputValueDidChange(value: "password")
        sut.shouldRemeberUserBoxStatusDidChange(isActive: false)
        self.accessService.saveUserThrowError = TestError(message: "Test")
        let data = try self.json(from: SessionJSONResource.signInResponse)
        let sessionReponse = try self.decoder.decode(SessionDecoder.self, from: data)
        //Act
        sut.viewRequestedToLogin()
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
        let sut = self.buildSUT()
        sut.loginInputValueDidChange(value: "login")
        sut.passwordInputValueDidChange(value: "password")
        //Act
        sut.viewRequestedToLogin()
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
    private func buildSUT() -> LoginViewModel {
        return LoginViewModel(
            userInterface: self.userInterface,
            coordinator: self.coordinatorMock,
            accessService: self.accessService,
            contentProvider: self.contentProvider,
            errorHandler: self.errorHandler)
    }
}
// swiftlint:enable type_body_length
