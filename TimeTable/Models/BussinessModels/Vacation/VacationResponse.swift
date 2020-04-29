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
    let records: [Vacation]
    
    private enum CodingKeys: String, CodingKey {
        case availableVacationDays = "available_vacation_days"
        case usedVacationDays = "used_vacation_days"
        case records
    }
}

// MARK: - Structs
extension VacationResponse {
    struct Vacation: Decodable {
        let id: Int64
        let startDate: Date
        let endDate: Date
        let type: VacationType
        let status: Status
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
            self.id = try container.decode(Int64.self, forKey: .id)
            self.type = try container.decode(VacationType.self, forKey: .type)
            self.status = try container.decode(Status.self, forKey: .status)
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

extension VacationResponse.Vacation {
    enum VacationType: String, Decodable {
        case planned, requested, compassionate, others
        
        var localizableString: String {
            switch self {
            case .planned: return R.string.localizable.vacation_type_planned()
            case .requested: return R.string.localizable.vacation_type_requested()
            case .compassionate: return R.string.localizable.vacation_type_compassionate()
            case .others: return R.string.localizable.vacation_type_others()
            }
        }
    }
    
    enum Status: String, Decodable {
        case unconfirmed, declined, approved, accepted
        
        var localizableString: String {
            switch self {
            case .unconfirmed: return R.string.localizable.vacation_status_unconfirmed()
            case .declined: return R.string.localizable.vacation_status_declined()
            case .approved: return R.string.localizable.vacation_status_approved()
            case .accepted: return R.string.localizable.vacation_status_accepted()
            }
        }
        
        var color: UIColor {
            switch self {
            case .unconfirmed: return .statusUnconfirmed
            case .declined: return .statusDeclined
            case .approved: return .statusAccepted
            case .accepted: return .statusAccepted
            }
        }
    }
}

// MARK: - Equatable
extension VacationResponse: Equatable {}
extension VacationResponse.Vacation: Equatable {}
extension VacationResponse.UsedVacationDays: Equatable {}
