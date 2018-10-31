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
    
    override func setUp() {
        userInterface = LoginViewControllerMock()
        coordinatorMock = LoginCoordinatorMock()
        super.setUp()
    }
    
    func testViewDidLoadCallsSetUpView() {
        //Arrange
        let viewModel = LoginViewModel(userInterface: userInterface, coordinator: coordinatorMock)
        //Act
        viewModel.viewDidLoad()
        //Assert
        XCTAssertTrue(userInterface.setUpViewCalled)
    }
    
    func testViewWillDisappearCallsTearDownOnTheUserInerface() {
        //Arrange
        let viewModel = LoginViewModel(userInterface: userInterface, coordinator: coordinatorMock)
        //Act
        viewModel.viewWillDisappear()
        //Assert
        XCTAssertTrue(userInterface.tearDownCalled)
    }
    
    func testViewWillDisappearCallsLoginDidFinishOnTheCoordinator() {
        //Arrange
        let viewModel = LoginViewModel(userInterface: userInterface, coordinator: coordinatorMock)
        //Act
        viewModel.viewWillDisappear()
        //Assert
        XCTAssertTrue(coordinatorMock.loginDidfinishCalled)
    }
    
    func testLoginTextFieldDidRequestForReturnWhileLoginCredentialsAreNil() {
        //Arrange
        let viewModel = LoginViewModel(userInterface: userInterface, coordinator: coordinatorMock)
        //Act
        let value = viewModel.loginTextFieldDidRequestForReturn()
        //Assert
        XCTAssertFalse(value)
    }
    
    func testLoginTextFieldDidRequestForReturnWhilePasswordIsNil() {
        //Arrange
        let viewModel = LoginViewModel(userInterface: userInterface, coordinator: coordinatorMock)
        viewModel.loginInputValueDidChange(value: "login")
        //Act
        let value = viewModel.loginTextFieldDidRequestForReturn()
        //Assert
        XCTAssertTrue(value)
    }
    
    func testLoginTextFieldDidRequestForReturnCallsFocusOnThePasswordTextField() {
        //Arrange
        let viewModel = LoginViewModel(userInterface: userInterface, coordinator: coordinatorMock)
        viewModel.loginInputValueDidChange(value: "login")
        //Act
        _ = viewModel.loginTextFieldDidRequestForReturn()
        //Assert
        XCTAssertTrue(userInterface.focusOnPasswordTextFieldCalled)
    }
    
    func testLoginInputValueDidChangePassedNilValue() {
        //Arrange
        let viewModel = LoginViewModel(userInterface: userInterface, coordinator: coordinatorMock)
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
        let viewModel = LoginViewModel(userInterface: userInterface, coordinator: coordinatorMock)
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
        let viewModel = LoginViewModel(userInterface: userInterface, coordinator: coordinatorMock)
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
        let viewModel = LoginViewModel(userInterface: userInterface, coordinator: coordinatorMock)
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
        let viewModel = LoginViewModel(userInterface: userInterface, coordinator: coordinatorMock)
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
        let viewModel = LoginViewModel(userInterface: userInterface, coordinator: coordinatorMock)
        viewModel.passwordInputValueDidChange(value: "password")
        //Act
        let value = viewModel.passwordTextFieldDidRequestForReturn()
        //Assert
        XCTAssertFalse(value)
    }
    
    func testPasswordTextFieldDidRequestForReturnWhilePasswordIsEmpty() {
        let viewModel = LoginViewModel(userInterface: userInterface, coordinator: coordinatorMock)
        viewModel.loginInputValueDidChange(value: "login")
        //Act
        let value = viewModel.passwordTextFieldDidRequestForReturn()
        //Assert
        XCTAssertFalse(value)
    }
    
    func testPasswordTextFieldDidRequestForReturnWhileCredentialsAreCorrect() {
        let viewModel = LoginViewModel(userInterface: userInterface, coordinator: coordinatorMock)
        viewModel.loginInputValueDidChange(value: "login")
        viewModel.passwordInputValueDidChange(value: "password")
        //Act
        let value = viewModel.passwordTextFieldDidRequestForReturn()
        //Assert
        XCTAssertTrue(value)
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
    private(set) var loginDidfinishCalled = false
    
    func loginDidfinish() {
        loginDidfinishCalled = true
    }
}
