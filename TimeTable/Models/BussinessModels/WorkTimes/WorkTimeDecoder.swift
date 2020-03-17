//
//  WorkTimeDecoder.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 21/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

struct WorkTimeDecoder: Decodable {
    private static var simpleDateFormatter: DateFormatter = DateFormatter(type: .simple)
    
    let identifier: Int64
    let updatedByAdmin: Bool
    let projectId: Int
    let startsAt: Date
    let endsAt: Date
    let duration: Int64
    let body: String?
    let task: String?
    let taskPreview: String?
    let userId: Int
    let project: ProjectDecoder
    let date: Date
    let tag: ProjectTag
    let versions: [TaskVersion]
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case updatedByAdmin
        case projectId
        case startsAt
        case endsAt
        case duration
        case body
        case task
        case taskPreview
        case userId
        case project
        case date
        case tag
        case versions
    }
    
    // MARK: - Initialization
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.identifier = try container.decode(Int64.self, forKey: .identifier)
        self.updatedByAdmin = try container.decode(Bool.self, forKey: .updatedByAdmin)
        self.projectId = try container.decode(Int.self, forKey: .projectId)
        self.startsAt = try container.decode(Date.self, forKey: .startsAt)
        self.endsAt = try container.decode(Date.self, forKey: .endsAt)
        self.duration = try container.decode(Int64.self, forKey: .duration)
        self.body = try? container.decode(String.self, forKey: .body)
        self.task = try? container.decode(String.self, forKey: .task)
        self.taskPreview = try? container.decode(String.self, forKey: .taskPreview)
        self.userId = try container.decode(Int.self, forKey: .userId)
        self.project = try container.decode(ProjectDecoder.self, forKey: .project)
        self.tag = try container.decode(ProjectTag.self, forKey: .tag)
        self.versions = (try? container.decode([TaskVersion].self, forKey: .versions)) ?? []
        
        let dateString = try container.decode(String.self, forKey: .date)
        if let date = WorkTimeDecoder.simpleDateFormatter.date(from: dateString) {
            self.date = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "decoding_error.wrong_date_format.yyyy-MM-dd")
        }
    }
}

// MARK: - Equatable
extension WorkTimeDecoder: Equatable {
    static func == (lhs: WorkTimeDecoder, rhs: WorkTimeDecoder) -> Bool {
        return lhs.identifier == rhs.identifier
            && lhs.updatedByAdmin == rhs.updatedByAdmin
            && lhs.projectId == rhs.projectId
            && lhs.startsAt == rhs.startsAt
            && lhs.endsAt == rhs.endsAt
            && lhs.duration == rhs.duration
            && lhs.body == rhs.body
            && lhs.task == rhs.task
            && lhs.taskPreview == rhs.taskPreview
            && lhs.date == rhs.date
            && lhs.userId == rhs.userId
            && lhs.project == rhs.project
    }
}
