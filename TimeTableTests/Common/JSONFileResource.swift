//
//  JSONFileResource.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 02/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
import Foundation

protocol JSONFileResource: RawRepresentable {
    var fileName: String {get}
}

extension XCTestCase {
    func json<T>(from element: T, file: StaticString = #file, line: UInt = #line) throws -> Data where T: JSONFileResource {
        guard let url = Bundle(for: type(of: self)).url(forResource: element.fileName, withExtension: "json") else {
            XCTFail(file: file, line: line)
            throw "Missing json: \(element)"
        }
        return try Data(contentsOf: url)
    }
}

extension JSONFileResource where RawValue == String {
    var fileName: String {
        return self.rawValue
    }
}
