//
//  VacationParameters.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 23/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation
import Restler

struct VacationParameters: Encodable, RestlerQueryEncodable {
    let year: Int
    
    // MARK: - RestlerQueryEncodable
    func encodeToQuery(using encoder: RestlerQueryEncoderType) throws {
        let container = encoder.container(using: CodingKeys.self)
        try container.encode(self.year, forKey: .year)
    }
}
