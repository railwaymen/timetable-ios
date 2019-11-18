//
//  RequestEncoderMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class RequestEncoderMock {
    private lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter.init(type: .dateAndTimeExtended))
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
    
    var encodeToDictionaryThrowError: Error?
    private(set) var encodeToDictionaryParams: [EncodeToDictionaryParams] = []
    struct EncodeToDictionaryParams {
        var wrapper: Encodable
    }
}

// MARK: - RequestEncoderType
extension RequestEncoderMock: RequestEncoderType {
    func encodeToDictionary<T>(wrapper: T) throws -> [String: Any] where T: Encodable {
        self.encodeToDictionaryParams.append(EncodeToDictionaryParams(wrapper: wrapper))
        if let error = self.encodeToDictionaryThrowError {
            throw error
        }
        let data = try self.encoder.encode(wrapper)
        guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw TestError(message: "JSONSerialization.jsonObject error")
        }
        return json
    }
}
