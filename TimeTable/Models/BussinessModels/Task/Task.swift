//
//  Task.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 19/02/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

struct Task: Encodable {
    var project: SimpleProjectRecordDecoder
    var body: String
    var url: URL?
    var startsAt: Date
    var endsAt: Date
    var tag: ProjectTag = .default
    
    private enum CodingKeys: String, CodingKey {
        case projectID = "project_id"
        case body
        case task
        case startsAt = "starts_at"
        case endsAt = "ends_at"
        case tag
    }
    
    // MARK: - Encodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.project.id, forKey: .projectID)
        try container.encode(self.body, forKey: .body)
        try container.encode(self.url, forKey: .task)
        try container.encode(self.startsAt, forKey: .startsAt)
        try container.encode(self.endsAt, forKey: .endsAt)
        try container.encode(self.tag, forKey: .tag)
    }
}
