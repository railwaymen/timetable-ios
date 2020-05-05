//
//  VacationDecoder.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 29/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

struct VacationDecoder: Decodable {
    let id: Int
    let startDate: Date
    let endDate: Date
    let type: VacationType
    let status: VacationStatus
    let fullName: String
    let businessDaysCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case startDate = "start_date"
        case endDate = "end_date"
        case type = "vacation_type"
        case status
        case fullName = "full_name"
        case businessDaysCount = "business_days_count"
    }
    
    // MARK: - Initialization
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.type = try container.decode(VacationType.self, forKey: .type)
        self.status = try container.decode(VacationStatus.self, forKey: .status)
        self.fullName = try container.decode(String.self, forKey: .fullName)
        self.businessDaysCount = try container.decode(Int.self, forKey: .businessDaysCount)
        
        let startDateString = try container.decode(String.self, forKey: .startDate)
        if let startDate = DateFormatter.simple.date(from: startDateString) {
            self.startDate = startDate
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .startDate,
                in: container,
                debugDescription: "decoding_error.start_date.wrong_date_format.yyyy-MM-dd")
        }
        
        let endDateString = try container.decode(String.self, forKey: .endDate)
        if let endDate = DateFormatter.simple.date(from: endDateString) {
            self.endDate = endDate
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .endDate,
                in: container,
                debugDescription: "decoding_error.end_date.wrong_date_format.yyyy-MM-dd")
        }
    }
}

// MARK: - Equatable
extension VacationDecoder: Equatable {}
