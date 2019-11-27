//
//  MatchingFullTimeEncoder.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 29/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

struct MatchingFullTimeEncoder {
    static var dateFormatter: DateFormatter = DateFormatter(type: .simple)
    
    let date: Date?
    let userId: Int64?
}

// MARK: - Encodable
extension MatchingFullTimeEncoder: Encodable {
    enum CodingKeys: String, CodingKey {
        case date
        case userId
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        guard let date = self.date else {
            throw EncodingError.invalidValue(
                MatchingFullTimeEncoder.self,
                EncodingError.Context(
                    codingPath: [CodingKeys.date],
                    debugDescription: "date"))
        }
        
        let dateString =  MatchingFullTimeEncoder.dateFormatter.string(from: date)
        try container.encode(dateString, forKey: .date)
        guard let identifier = self.userId else {
            throw EncodingError.invalidValue(
                MatchingFullTimeEncoder.self,
                EncodingError.Context(
                    codingPath: [CodingKeys.userId],
                    debugDescription: "user_id"))
        }
        try container.encode(identifier, forKey: .userId)
    }
}
