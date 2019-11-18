//
//  JSONSerializationMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class JSONSerializationMock {
    var jsonObjectThrowError: Error?
    var jsonObjectReturnValue: Any?
    private(set) var jsonObjectParams: [JSONObjectParams] = []
    struct JSONObjectParams {
        var data: Data
        var options: JSONSerialization.ReadingOptions
    }
}

// MARK: - JSONSerializationType
extension JSONSerializationMock: JSONSerializationType {
    func jsonObject(with data: Data, options opt: JSONSerialization.ReadingOptions) throws -> Any {
        self.jsonObjectParams.append(JSONObjectParams(data: data, options: opt))
        if let error = self.jsonObjectThrowError {
            throw error
        }
        return try self.jsonObjectReturnValue ?? (try JSONSerialization.jsonObject(with: data, options: opt))
    }
}
