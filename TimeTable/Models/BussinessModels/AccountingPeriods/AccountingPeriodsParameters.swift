//
//  AccountingPeriodsParameters.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 28/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation
import Restler

struct AccountingPeriodsParameters: Encodable, RestlerQueryEncodable {
    let page: Int
    let recordsPerPage: Int
    
    private enum CodingKeys: String, CodingKey {
        case page
        case recordsPerPage = "per_page"
    }
    
    func encodeToQuery(using encoder: RestlerQueryEncoderType) throws {
        let container = encoder.container(using: CodingKeys.self)
        try container.encode(self.page, forKey: .page)
        try container.encode(self.recordsPerPage, forKey: .recordsPerPage)
    }
}
