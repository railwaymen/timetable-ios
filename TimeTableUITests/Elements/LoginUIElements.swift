//
//  LoginUIElements.swift
//  TimeTableUITests
//
//  Created by Bartłomiej Świerad on 26/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest

class LoginUIElements: UIElements {
    let loginButton: XCUIElement
    let loginTextField: XCUIElement
    let passwordTextField: XCUIElement
    let keyboard: XCUIElement
    let scrollView: XCUIElement
    
    var requiredElements: [XCUIElement] {
        [self.loginButton, self.loginTextField, self.passwordTextField, self.scrollView]
    }
    
    // MARK: - Initialization
    required init(app: XCUIApplication) {
        self.loginButton = app.buttons[ElementKey.loginButton.rawValue]
        self.loginTextField = app.textFields[ElementKey.loginTextField.rawValue]
        self.passwordTextField = app.secureTextFields[ElementKey.passwordTextField.rawValue]
        self.keyboard = app.keyboards.firstMatch
        self.scrollView = app.scrollViews.firstMatch
    }
}

// MARK: - Structures
extension LoginUIElements {
    private enum ElementKey: String {
        case loginButton
        case loginTextField
        case passwordTextField
    }
}
