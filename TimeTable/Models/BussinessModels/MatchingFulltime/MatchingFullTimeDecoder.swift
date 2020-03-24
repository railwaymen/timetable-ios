//
//  MatchingFullTimeDecoder.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 28/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

struct MatchingFullTimeDecoder: Decodable {
    let accountingPeriod: Period?
    let shouldWorked: TimeInterval?
    
    var accountingPeriodText: String? {
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        formatter.zeroFormattingBehavior = .default
        
        guard let shouldWorked = self.shouldWorked,
            let duration = self.accountingPeriod?.duration,
            let shouldWorkedText = formatter.string(from: shouldWorked),
            let durationText = formatter.string(from: duration) else {
                return nil
        }
        return "/ \(shouldWorkedText) / \(durationText)"
    }
    
    enum CodingKeys: String, CodingKey {
        case accountingPeriod
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
        return lhs.accountingPeriod == rhs.accountingPeriod && lhs.shouldWorked == rhs.shouldWorked
    }
}

extension MatchingFullTimeDecoder.Period: Equatable {
    static func == (lhs: MatchingFullTimeDecoder.Period, rhs: MatchingFullTimeDecoder.Period) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.countedDuration == rhs.countedDuration && lhs.duration == rhs.duration
    }
}
