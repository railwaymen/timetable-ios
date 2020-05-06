//
//  RemoteWorkParameters.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 06/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation
import Restler

struct RemoteWorkParameters: RestlerQueryEncodable {
    let page: Int
    let perPage: Int
    
    private  enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
    }
    
    // MARK: - RestlerQueryEncodable
    func encodeToQuery(using encoder: RestlerQueryEncoderType) throws {
        let container = encoder.container(using: CodingKeys.self)
        try container.encode(self.page, forKey: .page)
        try container.encode(self.perPage, forKey: .perPage)
    }
}
