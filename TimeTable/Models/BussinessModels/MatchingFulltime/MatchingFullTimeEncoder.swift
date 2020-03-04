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
    
    let date: Date
    let userId: Int64
}

// MARK: - Encodable
extension MatchingFullTimeEncoder: Encodable {
    enum CodingKeys: String, CodingKey {
        case date
        case userId
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let dateString = MatchingFullTimeEncoder.dateFormatter.string(from: self.date)
        try container.encode(dateString, forKey: .date)
        try container.encode(self.userId, forKey: .userId)
    }
}
