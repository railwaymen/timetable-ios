//
//  VacationType.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 29/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

enum VacationType: String, Codable {
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

// MARK: - Equatable
extension VacationType: Equatable {}
