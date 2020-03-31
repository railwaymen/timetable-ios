//
//  RestlerFactoryMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 31/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
import Restler
@testable import TimeTable

class RestlerFactoryMock {
    
    // MARK: - RestlerFactoryType
    var buildRestlerReturnValue: RestlerMock = RestlerMock()
    private(set) var buildRestlerParams: [BuildRestlerParams] = []
    struct BuildRestlerParams {
        let baseURL: URL
    }
}

// MARK: - RestlerFactoryType
extension RestlerFactoryMock: RestlerFactoryType {
    func buildRestler(withBaseURL baseURL: URL) -> RestlerType {
        self.buildRestlerParams.append(BuildRestlerParams(baseURL: baseURL))
        return self.buildRestlerReturnValue
    }
}
