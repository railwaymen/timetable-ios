//
//  JSONDecoderMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class JSONDecoderMock: JSONDecoderType {
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.init(type: .dateAndTimeExtended))
        return decoder
    }()
    
    var isThrowingError = false
    private(set) var decodeType: Decodable.Type?
    private(set) var decodeData: Data?
    
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .formatted(DateFormatter.init(type: .dateAndTimeExtended))
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        decodeType = type
        decodeData = data
        if isThrowingError {
            throw TestError(message: "decoder error")
        } else {
            return try decoder.decode(T.self, from: data)
        }
    }
}
