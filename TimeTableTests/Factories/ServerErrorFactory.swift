//
//  ServerErrorFactory.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 21/01/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
import JSONFactorable
@testable import TimeTable

class ServerErrorFactory: JSONFactorable {
    func build(wrapper: ServerErrorWrapper = ServerErrorWrapper()) throws -> ServerError {
        return try self.buildObject(of: wrapper.jsonConvertible())
    }
}

// MARK: - Helper extensions
extension ServerError: JSONObjectType {
    public func jsonConvertible() throws -> JSONConvertible {
        let wrapper = ServerErrorWrapper(
            error: self.error,
            status: self.status)
        return wrapper.jsonConvertible()
    }
}

// MARK: - Structures
struct ServerErrorWrapper {
    let error: String
    let status: Int
    
    init(
        error: String = "error",
        status: Int = 0
    ) {
        self.error = error
        self.status = status
    }
    
    func jsonConvertible() -> AnyJSONConvertible {
        return [
            "error": AnyJSONConvertible(self.error),
            "status": AnyJSONConvertible(self.status)
        ]
    }
}
