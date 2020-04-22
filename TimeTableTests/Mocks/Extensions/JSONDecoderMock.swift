//
//  JSONDecoderMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class JSONDecoderMock {
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.dateAndTimeExtended)
        return decoder
    }()

    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .formatted(DateFormatter.dateAndTimeExtended)
    
    var shouldThrowError: Bool = false
    private(set) var decodeParams: [DecodeParams] = []
    struct DecodeParams {
        var type: Decodable.Type
        var data: Data
    }
}

// MARK: - JSONDecoderType
extension JSONDecoderMock: JSONDecoderType {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        self.decodeParams.append(DecodeParams(type: type, data: data))
        if self.shouldThrowError {
            throw TestError(message: "decoder error")
        } else {
            return try self.decoder.decode(T.self, from: data)
        }
    }
}
