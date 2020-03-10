//
//  SimpleProjectDecoder.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 29/05/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

struct SimpleProjectDecoder: Decodable, Equatable {
    let projects: [ProjectDecoder]
    let tags: [ProjectTag]
    
    enum CodingKeys: String, CodingKey {
        case projects
        case tags
    }
    
    // MARK: - Initialization
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.projects = try container.decode([ProjectDecoder].self, forKey: .projects)
        self.tags = try container.decode([ProjectTag].self, forKey: .tags)
    }
}
