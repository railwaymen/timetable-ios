//
//  VacationEncoder.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 29/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

struct VacationEncoder: Encodable {
    let type: VacationType
    let description: String?
    let startDate: Date
    let endDate: Date
    
    enum CodingKeys: String, CodingKey {
        case type = "vacation_type"
        case description
        case startDate = "start_date"
        case endDate = "end_date"
    }
    
    // MARK: - Encodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.type, forKey: .type)
        try container.encode(self.description, forKey: .description)
        try container.encode(DateFormatter.simple.string(from: self.startDate), forKey: .startDate)
        try container.encode(DateFormatter.simple.string(from: self.endDate), forKey: .endDate)
    }
}
