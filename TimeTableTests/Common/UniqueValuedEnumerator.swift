//
//  UniqueValuedEnumerator.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 19/02/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

protocol UniqueValuedEnumerator {
    var uniqueValue: Int { get }
}

extension ApiClientError: UniqueValuedEnumerator {
    var uniqueValue: Int {
        switch self.type {
        case .invalidHost: return 0
        case .invalidParameters: return 1
        case .invalidResponse: return 2
        case .noConnection: return 3
        case .serverError: return 4
        case .timeout: return 5
        case .unauthorized: return 6
        }
    }
}
