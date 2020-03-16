//
//  WorkTimesParameters.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
import Restler

struct WorkTimesParameters: Encodable, RestlerQueryEncodable {
    let fromDate: Date?
    let toDate: Date?
    let projectId: Int?
    
    enum CodingKeys: String, CodingKey {
        case fromDate = "from"
        case toDate = "to"
        case projectId
    }
    
    func encodeToQuery(using encoder: RestlerQueryEncoderType) throws {
        let container = encoder.container(using: CodingKeys.self)
        try container.encode(self.fromDate, forKey: .fromDate)
        try container.encode(self.toDate, forKey: .toDate)
        try container.encode(self.projectId, forKey: .projectId)
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
