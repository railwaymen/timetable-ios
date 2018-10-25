//
//  Optional+Unwrap.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 25/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest

extension Optional {
    func unwrap(file: StaticString = #file, line: UInt = #line) throws -> Wrapped {
        switch self {
        case .none:
            XCTFail(file: file, line: line)
            throw "Unwraping optional value failed"
        case .some(let wrappedValue):
            return wrappedValue
        }
    }
}
