//
//  WorkTimeDecoder.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 21/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

struct WorkTimeDecoder: Decodable {
    
    let identifier: Int
    let updatedByAdmin: Bool
    let projectIdentifier: Int
    let startsAt: Date
    let endsAt: Date
    let duration: Int64
    let body: String?
    let task: String?
    let taskPreview: String?
    let userIdentifier: Int
    let project: ProjectDecoder
    let date: Date
    
    private static var simpleDateFormatter: DateFormatter {
        return DateFormatter(type: .simple)
    }
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case updatedByAdmin = "updated_by_admin"
        case projectIdentifier = "project_id"
        case startsAt = "starts_at"
        case endsAt = "ends_at"
        case duration
        case body
        case task
        case taskPreview = "task_preview"
        case userIdentifier = "user_id"
        case project
        case date
    }
    
    // MARK: - Initialization
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.identifier = try container.decode(Int.self, forKey: .identifier)
        self.updatedByAdmin = try container.decode(Bool.self, forKey: .updatedByAdmin)
        self.projectIdentifier = try container.decode(Int.self, forKey: .projectIdentifier)
        self.startsAt = try container.decode(Date.self, forKey: .startsAt)
        self.endsAt = try container.decode(Date.self, forKey: .endsAt)
        self.duration = try container.decode(Int64.self, forKey: .duration)
        self.body = try? container.decode(String.self, forKey: .body)
        self.task = try? container.decode(String.self, forKey: .task)
        self.taskPreview = try? container.decode(String.self, forKey: .taskPreview)
        self.userIdentifier = try container.decode(Int.self, forKey: .userIdentifier)
        self.project = try container.decode(ProjectDecoder.self, forKey: .project)
        
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
        return lhs.identifier == rhs.identifier && lhs.updatedByAdmin == rhs.updatedByAdmin
            && lhs.projectIdentifier == rhs.projectIdentifier && lhs.startsAt == rhs.startsAt
            && lhs.endsAt == rhs.endsAt && lhs.duration == rhs.duration && lhs.body == rhs.body
            && lhs.task == rhs.task && lhs.taskPreview == rhs.taskPreview && lhs.date == rhs.date
            && lhs.userIdentifier == rhs.userIdentifier && lhs.project == rhs.project
    }
}
