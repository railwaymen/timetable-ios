//
//  RequestEncoderMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class RequestEncoderMock: RequestEncoderType {
    private lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter.init(type: .dateAndTimeExtended))
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
    
    private(set) var encodeWrapper: Encodable?
    var isThrowingError = false
    
    func encode<T>(wrapper: T) throws -> Data where T: Encodable {
        self.encodeWrapper = wrapper
        if isThrowingError {
            throw TestError(message: "encode error")
        } else {
            return try encoder.encode(wrapper)
        }
    }
    
    private(set) var encodeToDictionaryWrapper: Encodable?
    var isEncodeToDictionaryThrowingError = false
    
    func encodeToDictionary<T>(wrapper: T) throws -> [String: Any] where T: Encodable {
        self.encodeToDictionaryWrapper = wrapper
        if isEncodeToDictionaryThrowingError {
            throw TestError(message: "encode to dictionary error")
        } else {
            let data = try encoder.encode(wrapper)
            guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                throw TestError(message: "JSONSerialization.jsonObject error")
            }
            return json
        }
    }
}
