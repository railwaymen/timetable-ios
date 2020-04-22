//
//  JSONFactorable+Extension.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 21/01/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
import JSONFactorable
@testable import TimeTable

extension JSONFactorable {
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.dateAndTimeExtended)
        return decoder
    }
}

extension Date: JSONObjectType {
    public func jsonConvertible() throws -> JSONConvertible {
        return try self.toString(codingStrategy: .formatted(DateFormatter.dateAndTimeExtended))
    }
}
