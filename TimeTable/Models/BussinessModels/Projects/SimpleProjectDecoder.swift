//
//  SimpleProjectDecoder.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 29/05/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

struct SimpleProjectDecoder: Decodable {
    let projects: [ProjectDecoder]
    let tags: [ProjectTag]
    
    enum CodingKeys: String, CodingKey {
        case projects
        case tags
    }
}
