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
}

// MARK: - viewDidLoad()
extension LoginViewModelTests {
    func testViewDidLoad() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setUpViewParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.updateLoginFieldsParams.first?.email, "")
        XCTAssertEqual(self.userInterfaceMock.updateLoginFieldsParams.first?.password, "")
    }
}

// MARK: - viewRequestedToChangeServerAddress()
extension LoginViewModelTests {
    func testViewRequestedToChangeServerAddressCallsLoginDidFinishOnTheCoordinator() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.viewRequestedToChangeServerAddress()
        //Assert
        XCTAssertEqual(self.coordinatorMock.loginDidFinishParams.count, 1)
    }
}

// MARK: - loginTextFieldDidRequestForReturn()
extension LoginViewModelTests {
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
}

// MARK: - loginInputValueDidChange(value:)
extension LoginViewModelTests {
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
}

// MARK: - passwordInputValueDidChange(value:)
extension LoginViewModelTests {
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
}

// MARK: - passwordTextFieldDidRequestForReturn()
extension LoginViewModelTests {
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
}

// MARK: - shouldRemeberUserBoxStatusDidChange(isActive:)
extension LoginViewModelTests {
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
}

// MARK: - viewRequestedToLogin()
extension LoginViewModelTests {
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
