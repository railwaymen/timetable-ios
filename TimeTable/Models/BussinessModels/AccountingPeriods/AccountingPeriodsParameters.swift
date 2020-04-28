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
    
    func encodeToQuery(using encoder: RestlerQueryEncoderType) throws {
        // TODO
    }
}
