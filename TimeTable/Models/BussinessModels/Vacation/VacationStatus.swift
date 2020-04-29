//
//  VacationStatus.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 29/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

enum VacationStatus: String, Decodable {
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

// MARK: - Equatable
extension VacationStatus: Equatable {}
