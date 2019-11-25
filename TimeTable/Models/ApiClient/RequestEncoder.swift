//
//  RequestEncoder.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 07/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol EncoderType: class {
    func encode<T: Encodable>(wrapper: T) throws -> Data
}

protocol RequestEncoderType: class {
    func encodeToDictionary<T: Encodable>(wrapper: T) throws -> [String: Any]
}

class RequestEncoder {
    private let encoder: JSONEncoderType
    private let serialization: JSONSerializationType
    
    // MARK: - Initialization
    init(
        encoder: JSONEncoderType,
        serialization: JSONSerializationType
    ) {
        self.encoder = encoder
        self.serialization = serialization
    }
}
 
// MARK: - EncoderType
extension RequestEncoder: EncoderType {
    func encode<T: Encodable>(wrapper: T) throws -> Data {
        return try self.encoder.encode(wrapper)
    }
}
 
// MARK: - RequestEncoderType
extension RequestEncoder: RequestEncoderType {
    func encodeToDictionary<T: Encodable>(wrapper: T) throws -> [String: Any] {
        let data = try self.encode(wrapper: wrapper)
        let json = try self.serialization.jsonObject(with: data, options: .allowFragments)
        guard let jsonDictionary = json as? [String: Any] else {
            throw ApiClientError(type: .invalidParameters)
        }
        return jsonDictionary
    }
}
