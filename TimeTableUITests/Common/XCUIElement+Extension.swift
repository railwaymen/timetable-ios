//
//  XCUIElement+Extension.swift
//  TimeTableUITests
//
//  Created by Bartłomiej Świerad on 25/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest

extension XCUIElement {
    func waitToAppear(timeout: TimeInterval) -> Bool {
        guard !self.exists else { return true }
        return self.waitForExistence(timeout: timeout)
    }
    
    func waitToDisappear(timeout: TimeInterval, spec: XCTestCase = .init()) -> Bool {
        guard self.exists else { return true }
        let predicate = NSPredicate(format: "exists == false")
        let expectation = spec.expectation(for: predicate, evaluatedWith: self, handler: nil)
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
}

extension Array where Element == XCUIElement {
    func waitForAllToAppear(timeout: TimeInterval, spec: XCTestCase = .init()) -> Bool {
        guard !self.allSatisfy({ $0.exists }) else { return true }
        let predicate = NSPredicate(format: "exists == true")
        let expectations = self.map { element in
            return spec.expectation(for: predicate, evaluatedWith: element, handler: nil)
        }
        let result = XCTWaiter().wait(for: expectations, timeout: timeout)
        return result == .completed
    }
}
