//
//  MatchingFullTimeEncoder.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 29/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
import Restler

struct MatchingFullTimeEncoder: Encodable, RestlerQueryEncodable {
    let date: Date
    let userId: Int64
    
    enum CodingKeys: String, CodingKey {
        case date
        case userId
    }
    
    func encodeToQuery(using encoder: RestlerQueryEncoderType) throws {
        let container = encoder.container(using: CodingKeys.self)
        let dateString = DateFormatter.simple.string(from: self.date)
        try container.encode(dateString, forKey: .date)
        try container.encode(self.userId, forKey: .userId)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let dateString = DateFormatter.simple.string(from: self.date)
        try container.encode(dateString, forKey: .date)
        try container.encode(self.userId, forKey: .userId)
    }
}
