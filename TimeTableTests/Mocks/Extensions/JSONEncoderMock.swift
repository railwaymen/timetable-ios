//
//  JSONEncoderMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class JSONEncoderMock {
    private lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter.dateAndTimeExtended)
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
    
    var shouldThrowError = false
    
    var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .iso8601
}

// MARK: - JSONEncoderType
extension JSONEncoderMock: JSONEncoderType {
    func encode<T>(_ value: T) throws -> Data where T: Encodable {
        if self.shouldThrowError {
            throw TestError(message: "encode error")
        } else {
            return try self.encoder.encode(value)
        }
    }
}
