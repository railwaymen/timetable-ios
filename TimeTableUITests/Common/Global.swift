//
//  Global.swift
//  TimeTableUITests
//
//  Created by Bartłomiej Świerad on 24/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest

func GetJSONResource<T>(
    from element: T,
    file: StaticString = #file,
    line: UInt = #line
) throws -> Data where T: JSONFileResource {
    guard let url = Bundle(for: LoginUIElements.self).url(forResource: element.fileName, withExtension: "json") else {
        let error = "Missing json \(element)"
        XCTFail(error, file: file, line: line)
        throw error
    }
    return try Data(contentsOf: url)
}
