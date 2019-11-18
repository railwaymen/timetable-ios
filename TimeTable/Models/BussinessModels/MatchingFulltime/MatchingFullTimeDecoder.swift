//
//  MatchingFullTimeDecoder.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 28/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

struct MatchingFullTimeDecoder {
    let period: Period?
    let shouldWorked: TimeInterval?
    
    struct Period {
        let identifier: Int
        let countedDuration: TimeInterval
        let duration: TimeInterval
    }
}

// MARK: - Decodable
extension MatchingFullTimeDecoder: Decodable {
    enum CodingKeys: String, CodingKey {
        case period
        case shouldWorked = "should_worked"
    }
}

extension MatchingFullTimeDecoder.Period: Decodable {
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case countedDuration = "counted_duration"
        case duration
    }
}

// MARK: - Equatable
extension MatchingFullTimeDecoder: Equatable {
    static func == (lhs: MatchingFullTimeDecoder, rhs: MatchingFullTimeDecoder) -> Bool {
        return lhs.period == rhs.period && lhs.shouldWorked == rhs.shouldWorked
    }
}

extension MatchingFullTimeDecoder.Period: Equatable {
    static func == (lhs: MatchingFullTimeDecoder.Period, rhs: MatchingFullTimeDecoder.Period) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.countedDuration == rhs.countedDuration && lhs.duration == rhs.duration
    }
}
