//
//  UIApplicationMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 05/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class UIApplicationMock {
    private(set) var openParams: [OpenParams] = []
    
    // MARK: - Structures
    struct OpenParams {
        var url: URL
        var options: [UIApplication.OpenExternalURLOptionsKey: Any]
        var completion: ((Bool) -> Void)?
    }
}

// MARK: - UIApplicationType
extension UIApplicationMock: UIApplicationType {
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any], completionHandler completion: ((Bool) -> Void)?) {
        self.openParams.append(OpenParams(url: url, options: options, completion: completion))
    }
}
