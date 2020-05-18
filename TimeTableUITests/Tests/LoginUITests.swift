//
//  LoginUITests.swift
//  TimeTableUITests
//
//  Created by Bartłomiej Świerad on 24/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest

class LoginUITests: DefaultUITestCase {
    var elements: LoginUIElements {
        self.getElements()
    }
    
    // MARK: - Overridden
    override var screenToTest: ScreenToTest {
        .login
    }
}

// MARK: - Login button state
extension LoginUITests {
    func testLoginButtonState_withoutPassword_blocksLoginButton() {
        //Arrange
        self.elements.loginTextField.tap()
        self.elements.loginTextField.typeText("user")
        //Assert
        XCTAssertFalse(self.elements.loginButton.isEnabled)
    }
    
    func testLoginButtonState_withoutUser_blocksLoginButton() {
        //Arrange
        self.elements.passwordTextField.tap()
        self.elements.passwordTextField.typeText("password")
        //Assert
        XCTAssertFalse(self.elements.loginButton.isEnabled)
    }
    
    func testLoginButtonState_withCredentials_enablesLoginButton() {
        //Arrange
        self.elements.loginTextField.tap()
        self.elements.loginTextField.typeText("u")
        self.elements.passwordTextField.tap()
        self.elements.passwordTextField.typeText("p")
        //Assert
        XCTAssertTrue(self.elements.loginButton.isEnabled)
    }
}

// MARK: - Login button action
extension LoginUITests {
    func testLoginButtonAction_withInvalidCredentials_showsAlert() throws {
        //Arrange
        let validationErrorData = try self.buildValidationErrorData()
        self.elements.loginTextField.tap()
        self.elements.loginTextField.typeText("user")
        self.elements.passwordTextField.tap()
        self.elements.passwordTextField.typeText("password")
        Self.server.setResponse(.validationError(data: validationErrorData), method: .post, endpoint: .signIn)
        //Act
        self.elements.loginButton.tap()
        //Assert
        XCTAssertTrue(self.app.alerts.firstMatch.waitToAppear(timeout: self.defaultTimeout))
    }

    func testLoginButtonAction_withValidCredentials_passesToMainFlowAfterLoginClick() {
        //Arrange
        self.elements.loginTextField.tap()
        self.elements.loginTextField.typeText("user")
        self.elements.passwordTextField.tap()
        self.elements.passwordTextField.typeText("password")
        //Act
        self.elements.loginButton.tap()
        //Assert
        XCTAssertTrue(self.app.tabBars.firstMatch.waitToAppear(timeout: self.defaultTimeout))
    }
}

// MARK: - Private
extension LoginUITests {
    private func buildValidationErrorData() throws -> Data {
        return try self.json(from: MockResponse.signInValidationErrorBaseInvalidEmailOrPassword)
    }
}
