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
    
    struct Period: Decodable {
        let identifier: Int
        let countedDuration: TimeInterval
        let duration: TimeInterval
        
        enum CodingKeys: String, CodingKey {
            case identifier = "id"
            case countedDuration = "counted_duration"
            case duration
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case period
        case shouldWorked = "should_worked"
    }
}
