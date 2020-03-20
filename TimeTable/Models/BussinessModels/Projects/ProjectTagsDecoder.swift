//
//  ProjectTagsDecoder.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 20/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

struct ProjectTagsDecoder: Decodable, Equatable {
    let tags: [ProjectTag]
    
    // MARK: - Initialization
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let tags = try container.decode([String].self)
        self.tags = tags.compactMap {
            return ProjectTag(rawValue: $0)
        }
    }
}
