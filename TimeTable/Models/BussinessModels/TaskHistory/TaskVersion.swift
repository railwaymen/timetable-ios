//
//  TaskVersion.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 17/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol TaskVersionFieldsProtocol {
    var workTime: WorkTimeDecoder { get }
    var event: TaskVersion.Event? { get }
    var updatedBy: String { get }
    var createdAt: Date { get }
    var changeset: Set<TaskVersion.Change> { get }
}

struct TaskVersion: Decodable, TaskVersionFieldsProtocol {
    let workTime: WorkTimeDecoder
    let event: Event?
    let updatedBy: String
    let createdAt: Date
    let changeset: Set<Change>
    
    private enum CodingKeys: String, CodingKey {
        case event
        case updatedBy = "updated_by"
        case createdAt = "created_at"
        case changeset
    }
    
    // MARK: - Initialization
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.workTime = try WorkTimeDecoder(from: decoder)
        self.event = try? container.decode(Event.self, forKey: .event)
        self.updatedBy = try container.decode(String.self, forKey: .updatedBy)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        let changeset = try container.decode([String].self, forKey: .changeset)
        self.changeset = Set(changeset.compactMap { Change(rawValue: $0) })
    }
}

// MARK: - Structures
extension TaskVersion {
    enum Event: String, Decodable {
        case create
        case update
    }
    
    enum Change: String, Decodable {
        case projectID = "project_id"
        case startsAt = "starts_at"
        case endsAt = "ends_at"
        case duration
        case body
        case task
        case taskPreview = "task_preview"
        case date
        case tag
    }
}
