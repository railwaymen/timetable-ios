//
//  UIApplicationMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 05/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

// swiftlint:disable large_tuple
class UIApplicationMock: UIApplicationType {
    private(set) var openURLCalledCount = 0
    private(set) var openURLValues: (url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any], completion: ((Bool) -> Void)?)?
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any] = [:], completionHandler completion: ((Bool) -> Void)? = nil) {
        openURLCalledCount += 1
        openURLValues = (url, options, completion)
    }
}
// swiftlint:enable large_tuple
