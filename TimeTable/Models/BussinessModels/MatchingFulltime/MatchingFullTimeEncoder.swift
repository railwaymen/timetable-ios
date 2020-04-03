//
//  MatchingFullTimeEncoder.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 29/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
import Restler

struct MatchingFullTimeEncoder: RestlerQueryEncodable {
    let date: Date
    let userId: Int64
    
    enum CodingKeys: String, CodingKey {
        case date
        case userId = "user_id"
    }
    
    func encodeToQuery(using encoder: RestlerQueryEncoderType) throws {
        let container = encoder.container(using: CodingKeys.self)
        let dateString = DateFormatter.simple.string(from: self.date)
        try container.encode(dateString, forKey: .date)
        try container.encode(self.userId, forKey: .userId)
    }
}
