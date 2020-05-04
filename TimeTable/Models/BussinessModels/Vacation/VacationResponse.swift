//
//  VacationResponse.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 22/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

struct VacationResponse: Decodable {
    let availableVacationDays: Int
    let usedVacationDays: UsedVacationDays
    let records: [VacationDecoder]
    
    private enum CodingKeys: String, CodingKey {
        case availableVacationDays = "available_vacation_days"
        case usedVacationDays = "used_vacation_days"
        case records
    }
    
    // MARK: - Initialization
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.availableVacationDays = try container.decode(Int.self, forKey: .availableVacationDays)
        self.usedVacationDays = try container.decode(UsedVacationDays.self, forKey: .usedVacationDays)
        let records = try container.decode([VacationDecoder].self, forKey: .records)
        self.records = records.sorted(by: { $0.startDate > $1.startDate })
    }
}

// MARK: - Structs
extension VacationResponse {
    struct UsedVacationDays: Decodable {
        let care: Int
        let compassionate: Int
        let illness: Int
        let parental: Int
        let paternity: Int
        let planned: Int
        let rehabilitation: Int
        let requested: Int
        let unpaid: Int
        let upbringing: Int
    }
}

// MARK: - Equatable
extension VacationResponse: Equatable {}
extension VacationResponse.UsedVacationDays: Equatable {}
