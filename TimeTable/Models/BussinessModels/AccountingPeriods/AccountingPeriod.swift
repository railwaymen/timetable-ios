//
//  AccountingPeriod.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 27/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

struct AccountingPeriod: Decodable {
    let id: Int
    let startsAt: Date?
    let endsAt: Date?
    let countedDuration: TimeInterval
    let duration: TimeInterval
    let isClosed: Bool
    let note: String?
    let isFullTime: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case startsAt = "starts_at"
        case endsAt = "ends_at"
        case countedDuration = "counted_duration"
        case duration = "duration"
        case isClosed = "closed"
        case note
        case isFullTime = "full_time"
    }
    
    // MARK: - Initialization
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.startsAt = try? container.decode(Date.self, forKey: .startsAt)
        self.endsAt = try? container.decode(Date.self, forKey: .endsAt)
        self.countedDuration = (try? container.decode(TimeInterval.self, forKey: .countedDuration)) ?? 0
        self.duration = try container.decode(TimeInterval.self, forKey: .duration)
        self.isClosed = try container.decode(Bool.self, forKey: .isClosed)
        self.note = try? container.decode(String.self, forKey: .note)
        self.isFullTime = try container.decode(Bool.self, forKey: .isFullTime)
    }
}
