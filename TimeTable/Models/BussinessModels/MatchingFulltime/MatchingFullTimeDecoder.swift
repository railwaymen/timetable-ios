//
//  MatchingFullTimeDecoder.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 28/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

protocol MatchingFullTimeDecoderFields {
    var accountingPeriod: MatchingFullTimeDecoder.Period? { get }
    var shouldWorked: TimeInterval? { get }
}

protocol MatchingFullTimePeriodDecoder {
    var id: Int { get }
    var countedDuration: TimeInterval { get }
    var duration: TimeInterval { get }
}

struct MatchingFullTimeDecoder: Decodable, MatchingFullTimeDecoderFields {
    let accountingPeriod: Period?
    let shouldWorked: TimeInterval?
    
    var accountingPeriodText: String? {
        let formatter = DateComponentsFormatter.timeAbbreviated
        
        guard let shouldWorked = self.shouldWorked,
            let duration = self.accountingPeriod?.duration,
            let shouldWorkedText = formatter.string(from: shouldWorked),
            let durationText = formatter.string(from: duration) else {
                return nil
        }
        return "/ \(shouldWorkedText) / \(durationText)"
    }
    
    enum CodingKeys: String, CodingKey {
        case accountingPeriod = "accounting_period"
        case shouldWorked = "should_worked"
    }
}

// MARK: - Structures
extension MatchingFullTimeDecoder {
    struct Period: Decodable, MatchingFullTimePeriodDecoder {
        let id: Int
        let countedDuration: TimeInterval
        let duration: TimeInterval
        
        enum CodingKeys: String, CodingKey {
            case id
            case countedDuration = "counted_duration"
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
        return lhs.id == rhs.id && lhs.countedDuration == rhs.countedDuration && lhs.duration == rhs.duration
    }
}
