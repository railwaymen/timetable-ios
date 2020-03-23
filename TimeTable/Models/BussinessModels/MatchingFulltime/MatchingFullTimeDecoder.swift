//
//  MatchingFullTimeDecoder.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 28/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

struct MatchingFullTimeDecoder: Decodable {
    let period: Period?
    let shouldWorked: TimeInterval?
    
    enum CodingKeys: String, CodingKey {
        case period
        case shouldWorked
    }
}

// MARK: - Structures
extension MatchingFullTimeDecoder {
    struct Period: Decodable {
        let identifier: Int
        let countedDuration: TimeInterval
        let duration: TimeInterval
        
        enum CodingKeys: String, CodingKey {
            case identifier = "id"
            case countedDuration
            case duration
        }
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
