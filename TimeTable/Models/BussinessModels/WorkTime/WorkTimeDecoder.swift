//
//  WorkTimeDecoder.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 21/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol WorkTimeDecoderFieldsProtocol {
    var id: Int64 { get }
    var updatedByAdmin: Bool { get }
    var projectID: Int { get }
    var startsAt: Date { get }
    var endsAt: Date { get }
    var duration: Int64 { get }
    var body: String? { get }
    var task: String? { get }
    var taskPreview: String? { get }
    var userID: Int { get }
    var project: SimpleProjectRecordDecoder { get }
    var date: Date { get }
    var tag: ProjectTag { get }
    var versions: [TaskVersion] { get }
}

struct WorkTimeDecoder: Decodable, WorkTimeDecoderFieldsProtocol {
    let id: Int64
    let updatedByAdmin: Bool
    let projectID: Int
    let startsAt: Date
    let endsAt: Date
    let duration: Int64
    let body: String?
    let task: String?
    let taskPreview: String?
    let userID: Int
    let project: SimpleProjectRecordDecoder
    let date: Date
    let tag: ProjectTag
    let versions: [TaskVersion]
    
    enum CodingKeys: String, CodingKey {
        case id
        case updatedByAdmin = "updated_by_admin"
        case projectID = "project_id"
        case startsAt = "starts_at"
        case endsAt = "ends_at"
        case duration
        case body
        case task
        case taskPreview = "task_preview"
        case userID = "user_id"
        case project
        case date
        case tag
        case versions
    }
    
    // MARK: - Initialization
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.updatedByAdmin = try container.decode(Bool.self, forKey: .updatedByAdmin)
        self.projectID = try container.decode(Int.self, forKey: .projectID)
        self.startsAt = try container.decode(Date.self, forKey: .startsAt)
        self.endsAt = try container.decode(Date.self, forKey: .endsAt)
        self.duration = try container.decode(Int64.self, forKey: .duration)
        self.body = try? container.decode(String.self, forKey: .body)
        self.task = try? container.decode(String.self, forKey: .task)
        self.taskPreview = try? container.decode(String.self, forKey: .taskPreview)
        self.userID = try container.decode(Int.self, forKey: .userID)
        self.project = try container.decode(SimpleProjectRecordDecoder.self, forKey: .project)
        self.tag = try container.decode(ProjectTag.self, forKey: .tag)
        self.versions = (try? container.decode([TaskVersion].self, forKey: .versions)) ?? []
        
        let dateString = try container.decode(String.self, forKey: .date)
        if let date = DateFormatter.simple.date(from: dateString) {
            self.date = date
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .date,
                in: container,
                debugDescription: "decoding_error.wrong_date_format.yyyy-MM-dd")
        }
    }
}

// MARK: - Equatable
extension WorkTimeDecoder: Equatable {
    static func == (lhs: WorkTimeDecoder, rhs: WorkTimeDecoder) -> Bool {
        return lhs.id == rhs.id
    }
}
