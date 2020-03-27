//
//  UIElements.swift
//  TimeTableUITests
//
//  Created by Bartłomiej Świerad on 26/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest

protocol UIElements {
    var requiredElements: [XCUIElement] { get }
    init(app: XCUIApplication)
}

extension UIElements {
    var exist: Bool {
        self.requiredElements.allSatisfy { $0.exists }
    }
    
    func waitToAppear(timeout: TimeInterval) -> Bool {
        self.requiredElements.waitForAllToAppear(timeout: timeout)
    }
}
