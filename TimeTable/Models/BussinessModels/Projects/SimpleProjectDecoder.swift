//
//  SimpleProjectDecoder.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 29/05/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

struct SimpleProjectDecoder {
    let projects: [ProjectDecoder]
    let tags: [ProjectTag]
}

// MARK: - Decodable
extension SimpleProjectDecoder: Decodable {
    enum CodingKeys: String, CodingKey {
        case projects
        case tags
    }
}
