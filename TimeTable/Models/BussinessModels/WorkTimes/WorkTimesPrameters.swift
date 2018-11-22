//
//  WorkTimesPrameters.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

struct WorkTimesPrameters: Encodable {
    let fromDate: Date?
    let toDate: Date?
    let projectIdentifier: Int?
    
    enum CodingKeys: String, CodingKey {
        case fromDate = "from"
        case toDate = "to"
        case projectIdentifier = "project_id"
    }
}

extension WorkTimesPrameters: Equatable {
    static func == (lhs: WorkTimesPrameters, rhs: WorkTimesPrameters) -> Bool {
        return lhs.fromDate == rhs.fromDate && lhs.toDate == rhs.toDate && lhs.projectIdentifier == rhs.projectIdentifier
    }
}
