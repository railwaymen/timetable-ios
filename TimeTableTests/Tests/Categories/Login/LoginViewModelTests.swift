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
    private var userInterfaceMock: LoginViewControllerMock!
    private var coordinatorMock: LoginCoordinatorMock!
    private var contentProviderMock: LoginContentProviderMock!
    private var errorHandlerMock: ErrorHandlerMock!
    private var accessServiceMock: AccessServiceMock!
    private var notificationCenterMock: NotificationCenterMock!
        
    override func setUp() {
        super.setUp()
        self.userInterfaceMock = LoginViewControllerMock()
        self.coordinatorMock = LoginCoordinatorMock()
        self.contentProviderMock = LoginContentProviderMock()
        self.errorHandlerMock = ErrorHandlerMock()
        self.accessServiceMock = AccessServiceMock()
        self.notificationCenterMock = NotificationCenterMock()
    }
    
    func testViewDidLoadCallsSetUpView() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setUpViewParams.count, 1)
    }
    
    func testViewDidLoad_withUserCredentials() throws {
        //Arrange
        let loginCredentials = LoginCredentials(email: "email", password: "password")
        self.accessServiceMock.getUserCredentialsReturnValue = loginCredentials
        let sut = self.buildSUT()
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setUpViewParams.last?.checkBoxIsActive))
        XCTAssertEqual(self.userInterfaceMock.updateLoginFieldsParams.last?.email, loginCredentials.email)
        XCTAssertEqual(self.userInterfaceMock.updateLoginFieldsParams.last?.password, loginCredentials.password)
    }
    
    func testViewDidLoad_withGetUserCredentialsThrownError() {
        //Arrange
        self.accessServiceMock.getUserCredentialsThrowError = TestError(message: "Test")
        let sut = self.buildSUT()
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertFalse(try XCTUnwrap(self.userInterfaceMock.setUpViewParams.last?.checkBoxIsActive))
        XCTAssertEqual(self.userInterfaceMock.updateLoginFieldsParams.last?.email, "")
        XCTAssertEqual(self.userInterfaceMock.updateLoginFieldsParams.last?.password, "")
    }
    
    func testViewDidLoadUpdatesLoginFiledsWithFilledEmail() {
        //Arrange
        let email = "user@example.com"
        self.accessServiceMock.getUserCredentialsReturnValue = LoginCredentials(email: email, password: "")
        let sut = self.buildSUT()
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateLoginFieldsParams.last?.email, email)
        XCTAssertEqual(self.userInterfaceMock.updateLoginFieldsParams.last?.password, "")
    }
    
    func testViewDidLoadUpdatesLoginFiledsWithFilledPassword() {
        //
        let password = "password"
        self.accessServiceMock.getUserCredentialsReturnValue = LoginCredentials(email: "", password: password)
        let sut = self.buildSUT()
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateLoginFieldsParams.last?.email, "")
        XCTAssertEqual(self.userInterfaceMock.updateLoginFieldsParams.last?.password, password)
    }
    
    func testViewDidLoadUpdatesLoginFiledsWithCorrectLoginCredentials() {
        //Arrange
        let email = "user@example.com"
        let password = "password"
        self.accessServiceMock.getUserCredentialsReturnValue = LoginCredentials(email: email, password: password)
        let sut = self.buildSUT()
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateLoginFieldsParams.last?.email, email)
        XCTAssertEqual(self.userInterfaceMock.updateLoginFieldsParams.last?.password, password)
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
        XCTAssertEqual(self.userInterfaceMock.focusOnPasswordTextFieldParams.count, 1)
    }
    
    func testLoginInputValueDidChangePassedNilValue() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.loginInputValueDidChange(value: nil)
        //Assert
        XCTAssertTrue(self.userInterfaceMock.passwordInputEnabledStateParams.isEmpty)
        XCTAssertTrue(self.userInterfaceMock.loginButtonEnabledStateParams.isEmpty)
    }
    
    func testLoginInputValueDidChange() throws {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.loginInputValueDidChange(value: "login")
        //Assert
        XCTAssertEqual(self.userInterfaceMock.passwordInputEnabledStateParams.count, 1)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.passwordInputEnabledStateParams.last?.isEnabled))
        XCTAssertEqual(self.userInterfaceMock.loginButtonEnabledStateParams.count, 1)
        XCTAssertFalse(try XCTUnwrap(self.userInterfaceMock.loginButtonEnabledStateParams.last?.isEnabled))
    }

    func testPasswordInputValueDidChangePassedNilValue() throws {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.passwordInputValueDidChange(value: nil)
        //Assert
        XCTAssertTrue(self.userInterfaceMock.passwordInputEnabledStateParams.isEmpty)
        XCTAssertTrue(self.userInterfaceMock.loginButtonEnabledStateParams.isEmpty)
    }
    
    func testPasswordInputValueDidChangeWhileLoginValueIsNil() throws {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.passwordInputValueDidChange(value: "password")
        //Assert
        XCTAssertEqual(self.userInterfaceMock.passwordInputEnabledStateParams.count, 1)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.passwordInputEnabledStateParams.last?.isEnabled))
        XCTAssertEqual(self.userInterfaceMock.loginButtonEnabledStateParams.count, 1)
        XCTAssertFalse(try XCTUnwrap(self.userInterfaceMock.loginButtonEnabledStateParams.last?.isEnabled))
    }
    
    func testPasswordInputValueDidChangeWhileLoginValueIsNotNil() throws {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.loginInputValueDidChange(value: "login")
        sut.passwordInputValueDidChange(value: "password")
        //Assert
        XCTAssertEqual(self.userInterfaceMock.passwordInputEnabledStateParams.count, 2)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.passwordInputEnabledStateParams.last?.isEnabled))
        XCTAssertEqual(self.userInterfaceMock.loginButtonEnabledStateParams.count, 2)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.loginButtonEnabledStateParams.last?.isEnabled))
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
        XCTAssertEqual(self.userInterfaceMock.checkBoxIsActiveStateParams.count, 1)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.checkBoxIsActiveStateParams.last?.isActive))
    }
    
    func testShouldRemeberUserBoxStatusDidChangeToTrue() throws {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.shouldRemeberUserBoxStatusDidChange(isActive: false)
        //Assert
        XCTAssertEqual(self.userInterfaceMock.checkBoxIsActiveStateParams.count, 1)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.checkBoxIsActiveStateParams.last?.isActive))
    }
    
    func testViewRequestedToLoginWhileLoginIsEmpty() throws {
        //Arrange
        let expectedError = UIError.cannotBeEmpty(.loginTextField)
        let sut = self.buildSUT()
        //Act
        sut.viewRequestedToLogin()
        //Assert
        let error = try XCTUnwrap(self.errorHandlerMock.throwingParams.last?.error as? UIError)
        XCTAssertEqual(error, expectedError)
        XCTAssertTrue(self.userInterfaceMock.setActivityIndicatorParams.isEmpty)
    }
    
    func testViewRequestedToLoginWhilePasswordIsEmpty() throws {
        //Arrange
        let expectedError = UIError.cannotBeEmpty(.passwordTextField)
        let sut = self.buildSUT()
        sut.loginInputValueDidChange(value: "login")
        //Act
        sut.viewRequestedToLogin()
        //Assert
        let error = try XCTUnwrap(self.errorHandlerMock.throwingParams.last?.error as? UIError)
        XCTAssertEqual(error, expectedError)
        XCTAssertTrue(self.userInterfaceMock.setActivityIndicatorParams.isEmpty)
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
        self.contentProviderMock.loginParams.last?.fetchCompletion(.success(sessionReponse))
        //Assert
        XCTAssertEqual(self.coordinatorMock.loginDidFinishParams.count, 1)
        XCTAssertEqual(self.coordinatorMock.loginDidFinishParams.last?.state, .loggedInCorrectly(sessionReponse))
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 1)
        XCTAssertFalse(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
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
        self.contentProviderMock.loginParams.last?.fetchCompletion(.success(sessionReponse))
        self.contentProviderMock.loginParams.last?.saveCompletion(.failure(expectedError))
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
        switch self.errorHandlerMock.throwingParams.last?.error as? AppError {
        case .cannotRemeberUserCredentials(let error)?:
               XCTAssertEqual(try XCTUnwrap(error as? TestError), expectedError)
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
        self.accessServiceMock.saveUserThrowError = thrownError
        let data = try self.json(from: SessionJSONResource.signInResponse)
        let sessionReponse = try self.decoder.decode(SessionDecoder.self, from: data)
        //Act
        sut.viewRequestedToLogin()
        self.contentProviderMock.loginParams.last?.fetchCompletion(.success(sessionReponse))
        self.contentProviderMock.loginParams.last?.saveCompletion(.success(Void()))
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
        XCTAssertEqual(self.coordinatorMock.loginDidFinishParams.count, 1)
        XCTAssertEqual(self.coordinatorMock.loginDidFinishParams.last?.state, .loggedInCorrectly(sessionReponse))
        XCTAssertEqual(try XCTUnwrap(self.errorHandlerMock.throwingParams.last?.error as? TestError), thrownError)
    }
    
    func testRequestedToLoginWithCorrectCredentialsAndShouldSaveUserCredenailsSucceed() throws {
        //Arrange
        let sut = self.buildSUT()
        sut.loginInputValueDidChange(value: "login")
        sut.passwordInputValueDidChange(value: "password")
        sut.shouldRemeberUserBoxStatusDidChange(isActive: false)
        self.accessServiceMock.saveUserThrowError = TestError(message: "Test")
        let data = try self.json(from: SessionJSONResource.signInResponse)
        let sessionReponse = try self.decoder.decode(SessionDecoder.self, from: data)
        //Act
        sut.viewRequestedToLogin()
        self.contentProviderMock.loginParams.last?.fetchCompletion(.success(sessionReponse))
        self.contentProviderMock.loginParams.last?.saveCompletion(.success(Void()))
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
        XCTAssertEqual(self.coordinatorMock.loginDidFinishParams.count, 1)
        XCTAssertEqual(self.coordinatorMock.loginDidFinishParams.last?.state, .loggedInCorrectly(sessionReponse))
        XCTAssertEqual(self.accessServiceMock.saveUserParams.count, 1)
    }
    
    func testViewRequestedToLoginContentProviderReturnsAnError() throws {
        //Arrange
        let expectedError = TestError(message: "errorOccured")
        let sut = self.buildSUT()
        sut.loginInputValueDidChange(value: "login")
        sut.passwordInputValueDidChange(value: "password")
        //Act
        sut.viewRequestedToLogin()
        self.contentProviderMock.loginParams.last?.fetchCompletion(.failure(expectedError))
        //Assert
        let error = try XCTUnwrap(self.errorHandlerMock.throwingParams.last?.error as? TestError)
        XCTAssertEqual(error, expectedError)
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
    }
}

// MARK: - Private
extension LoginViewModelTests {
    private func buildSUT() -> LoginViewModel {
        return LoginViewModel(
            userInterface: self.userInterfaceMock,
            coordinator: self.coordinatorMock,
            accessService: self.accessServiceMock,
            contentProvider: self.contentProviderMock,
            errorHandler: self.errorHandlerMock,
            notificationCenter: self.notificationCenterMock)
    }
}
// swiftlint:enable type_body_length
