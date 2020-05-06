//
//  RemoteWorkResponse.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 06/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

struct RemoteWorkResponse: Decodable {
    let totalPages: Int
    let records: [RemoteWork]
    
    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case records
    }
}
