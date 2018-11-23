//
//  JSONSerializationMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class JSONSerializationMock: JSONSerializationType {
    var isThrowingError = false
    var customObject: Any?
    
    func jsonObject(with data: Data, options opt: JSONSerialization.ReadingOptions) throws -> Any {
        if isThrowingError {
            throw TestError(message: "jsonObject error")
        } else if let object = customObject {
            return object
        } else {
            return try JSONSerialization.jsonObject(with: data, options: opt)
        }
    }
}
