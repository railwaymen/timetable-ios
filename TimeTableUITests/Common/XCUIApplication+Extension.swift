//
//  XCUIApplication+Extension.swift
//  TimeTableUITests
//
//  Created by Bartłomiej Świerad on 25/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest

extension XCUIApplication {
    func setServerURL(_ url: URL) {
        self.setEnvironment(url.absoluteString, forKey: .serverURL)
    }
    
    func setScreenToTest(_ screenToTest: ScreenToTest) {
        self.setEnvironment(screenToTest.rawValue, forKey: .screenToTest)
    }
}

// MARK: - Structures
extension XCUIApplication {
    private enum Key: String {
        case serverURL
        case screenToTest
    }
}

// MARK: - Private
extension XCUIApplication {
    private func setEnvironment(_ value: String, forKey key: Key) {
        self.launchEnvironment[key.rawValue] = value
    }
}
