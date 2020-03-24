//
//  XCTestCase+Extension.swift
//  TimeTableUITests
//
//  Created by Bartłomiej Świerad on 24/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest

extension XCTestCase {
    var defaultTimeout: TimeInterval {
        return 3
    }
    
    func json<T>(from element: T, file: StaticString = #file, line: UInt = #line) throws -> Data where T: JSONFileResource {
        return try GetJSONResource(from: element, file: file, line: line)
    }
}
