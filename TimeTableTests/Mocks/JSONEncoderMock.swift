//
//  JSONEncoderMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class JSONEncoderMock: JSONEncoderType {
    private lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter.init(type: .dateAndTimeExtended))
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
    
    var isThrowingError = false
    
    var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .iso8601
    func encode<T>(_ value: T) throws -> Data where T: Encodable {
        if self.isThrowingError {
            throw TestError(message: "encode error")
        } else {
            return try self.encoder.encode(value)
        }
    }
}
