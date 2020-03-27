//
//  ServerConfigurationUITests.swift
//  TimeTableUITests
//
//  Created by Bartłomiej Świerad on 24/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest

class ServerConfigurationUITests: DefaultUITestCase {
    var elements: ServerConfigurationUIElements {
        self.getElements()
    }
    
    // MARK: - Overridden
    override var screenToTest: ScreenToTest {
        .serverConfiguration
    }
}

// MARK: - Tap on background
extension ServerConfigurationUITests {
    func testTapOnBackground_hidesKeyboard() {
        //Arrange
        self.elements.serverURLTextField.tap()
        guard self.elements.keyboard.waitForExistence(timeout: self.defaultTimeout) else { return XCTFail() }
        //Act
        self.elements.scrollView.tap()
        //Assert
        XCTAssertTrue(self.elements.keyboard.waitToDisappear(timeout: self.defaultTimeout))
    }
}

// MARK: - Login button state
extension ServerConfigurationUITests {
    func testLoginButtonState_withoutURL_blocksTheButton() {
        //Arrange
        self.elements.serverURLTextField.tap()
        self.elements.serverURLTextField.typeText("")
        //Assert
        XCTAssertFalse(self.elements.loginButton.isEnabled)
    }
    
    func testLoginButtonState_withInvalidURL_blocksTheButton() {
        //Arrange
        self.elements.serverURLTextField.tap()
        self.elements.serverURLTextField.typeText("someText")
        //Assert
        XCTAssertTrue(self.elements.loginButton.isEnabled)
    }
}

// MARK: - Login button action
extension ServerConfigurationUITests {
    func testLoginButtonAction_withInvalidURL_showsAlert() {
        //Arrange
        self.elements.serverURLTextField.tap()
        self.elements.serverURLTextField.typeText("someText")
        //Act
        self.elements.loginButton.tap()
        //Assert
        XCTAssertTrue(self.app.alerts.firstMatch.waitToAppear(timeout: self.defaultTimeout))
    }
    
    func testLoginButtonAction_withValidURL_passesToLogin() {
        //Arrange
        self.elements.serverURLTextField.tap()
        self.elements.serverURLTextField.typeText(Self.server.baseURL.absoluteString)
        //Act
        self.elements.loginButton.tap()
        //Assert
        XCTAssertTrue(LoginUIElements(app: self.app).waitToAppear(timeout: 5))
    }
}
