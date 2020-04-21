//
//  ServerConfigurationUIElements.swift
//  TimeTableUITests
//
//  Created by Bartłomiej Świerad on 25/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest

struct ServerConfigurationUIElements: UIElements {
    let serverURLTextField: XCUIElement
    let loginButton: XCUIElement
    let keyboard: XCUIElement
    let scrollView: XCUIElement
    
    var requiredElements: [XCUIElement] {
        [self.serverURLTextField, self.loginButton, self.scrollView]
    }
    
    // MARK: - Initialization
    init(app: XCUIApplication) {
        self.serverURLTextField = app.textFields[ElementKey.serverURLTextField.rawValue]
        self.loginButton = app.buttons[ElementKey.loginButton.rawValue]
        self.keyboard = app.keyboards.firstMatch
        self.scrollView = app.scrollViews.firstMatch
    }
}

// MARK: - Structures
extension ServerConfigurationUIElements {
    private enum ElementKey: String {
        case loginButton
        case serverURLTextField
    }
}
