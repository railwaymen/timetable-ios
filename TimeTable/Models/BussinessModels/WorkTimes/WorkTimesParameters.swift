//
//  WorkTimesParameters.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

struct WorkTimesParameters {
    let fromDate: Date?
    let toDate: Date?
    let projectId: Int?
}

// MARK: - Encodable
extension WorkTimesParameters: Encodable {
    enum CodingKeys: String, CodingKey {
        case fromDate = "from"
        case toDate = "to"
        case projectId
    }
}

// MARK: - Equatable
extension WorkTimesParameters: Equatable {
    static func == (lhs: WorkTimesParameters, rhs: WorkTimesParameters) -> Bool {
        return lhs.fromDate == rhs.fromDate
            && lhs.toDate == rhs.toDate
            && lhs.projectId == rhs.projectId
    }
}
