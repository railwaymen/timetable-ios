//
//  TaskVersion.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 17/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol TaskVersionFieldsProtocol {
    var event: TaskVersion.Event? { get }
    var updatedBy: String { get }
    var updatedAt: Date { get }
    var projectName: NilableDiffElement<String> { get }
    var body: NilableDiffElement<String> { get }
    var startsAt: NilableDiffElement<Date> { get }
    var endsAt: NilableDiffElement<Date> { get }
    var tag: NilableDiffElement<ProjectTag> { get }
    var duration: NilableDiffElement<Int64> { get }
    var task: NilableDiffElement<String> { get }
    var taskPreview: NilableDiffElement<String> { get }
}

struct TaskVersion: Decodable, TaskVersionFieldsProtocol {
    let event: Event?
    let updatedBy: String
    let updatedAt: Date
    let projectName: NilableDiffElement<String>
    let body: NilableDiffElement<String>
    let startsAt: NilableDiffElement<Date>
    let endsAt: NilableDiffElement<Date>
    let tag: NilableDiffElement<ProjectTag>
    let duration: NilableDiffElement<Int64>
    let task: NilableDiffElement<String>
    let taskPreview: NilableDiffElement<String>
    
    private enum CodingKeys: String, CodingKey {
        case event
        case updatedBy = "updated_by"
        case updatedAt = "created_at"
        case projectName = "project_name"
        case body
        case startsAt = "starts_at"
        case endsAt = "ends_at"
        case tag
        case duration
        case task
        case taskPreview = "task_preview"
    }
    
    // MARK: - Getters
    var changes: [Field] {
        var changes: [Field] = []
        if self.projectName.hasChanged {
            changes.append(.projectName)
        }
        if self.body.hasChanged {
            changes.append(.body)
        }
        if self.startsAt.hasChanged {
            changes.append(.startsAt)
        }
        if self.endsAt.hasChanged {
            changes.append(.endsAt)
        }
        if self.tag.hasChanged {
            changes.append(.tag)
        }
        if self.duration.hasChanged {
            changes.append(.duration)
        }
        if self.task.hasChanged || self.taskPreview.hasChanged {
            changes.append(.task)
        }
        return changes
    }
    
    // MARK: - Initialization
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.event = try? container.decode(Event.self, forKey: .event)
        self.updatedBy = try container.decode(String.self, forKey: .updatedBy)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        
        self.projectName = try NilableDiffElement(from: decoder, baseKey: CodingKeys.projectName.rawValue)
        self.body = try NilableDiffElement(from: decoder, baseKey: CodingKeys.body.rawValue)
        self.startsAt = try NilableDiffElement(from: decoder, baseKey: CodingKeys.startsAt.rawValue)
        self.endsAt = try NilableDiffElement(from: decoder, baseKey: CodingKeys.endsAt.rawValue)
        self.tag = try NilableDiffElement(from: decoder, baseKey: CodingKeys.tag.rawValue)
        self.duration = try NilableDiffElement(from: decoder, baseKey: CodingKeys.duration.rawValue)
        self.task = try NilableDiffElement(from: decoder, baseKey: CodingKeys.task.rawValue)
        self.taskPreview = try NilableDiffElement(from: decoder, baseKey: CodingKeys.taskPreview.rawValue)
    }
}

// MARK: - Structures
extension TaskVersion {
    enum Event: String, Decodable {
        case create
        case update
    }
    
    enum Field {
        case projectName
        case body
        case startsAt
        case endsAt
        case tag
        case duration
        case task
    }
}
