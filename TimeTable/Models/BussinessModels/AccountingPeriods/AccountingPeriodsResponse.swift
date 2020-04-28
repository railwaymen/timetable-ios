//
//  AccountingPeriodsResponse.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 28/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

struct AccountingPeriodsResponse: Decodable {
    let totalPages: Int
    let records: [AccountingPeriod]
    
    private enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case records
    }
}
