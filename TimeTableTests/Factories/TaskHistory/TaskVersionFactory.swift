//
//  TaskVersionFactory.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 03/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
import JSONFactorable
@testable import TimeTable

class TaskVersionFactory: JSONFactorable {
    // swiftlint:disable:next function_parameter_count
    func build(
        event: TaskVersion.Event?,
        updatedBy: String,
        updatedAt: Date,
        projectName: NilableDiffElement<String>,
        body: NilableDiffElement<String>,
        startsAt: NilableDiffElement<Date>,
        endsAt: NilableDiffElement<Date>,
        tag: NilableDiffElement<ProjectTag>,
        duration: NilableDiffElement<Int64>,
        task: NilableDiffElement<String>,
        taskPreview: NilableDiffElement<String>
    ) throws -> TaskVersion {
        let wrapper = Wrapper(
            event: event,
            updatedBy: updatedBy,
            updatedAt: updatedAt,
            projectName: projectName,
            body: body,
            startsAt: startsAt,
            endsAt: endsAt,
            tag: tag,
            duration: duration,
            task: task,
            taskPreview: taskPreview)
        return try self.buildObject(of: wrapper.jsonConvertible())
    }
}

extension TaskVersionFactory {
    struct Wrapper: TaskVersionFieldsProtocol {
        let event: TaskVersion.Event?
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
        
        init(
            event: TaskVersion.Event?,
            updatedBy: String,
            updatedAt: Date,
            projectName: NilableDiffElement<String>,
            body: NilableDiffElement<String>,
            startsAt: NilableDiffElement<Date>,
            endsAt: NilableDiffElement<Date>,
            tag: NilableDiffElement<ProjectTag>,
            duration: NilableDiffElement<Int64>,
            task: NilableDiffElement<String>,
            taskPreview: NilableDiffElement<String>
        ) {
            self.event = event
            self.updatedBy = updatedBy
            self.updatedAt = updatedAt
            self.projectName = projectName
            self.body = body
            self.startsAt = startsAt
            self.endsAt = endsAt
            self.tag = tag
            self.duration = duration
            self.task = task
            self.taskPreview = taskPreview
        }
        
        func jsonConvertible() -> AnyJSONConvertible {
            return [
                "event": AnyJSONConvertible(self.event),
                "updated_by": AnyJSONConvertible(self.updatedBy),
                "created_at": AnyJSONConvertible(self.updatedAt),
                "project_name_was": AnyJSONConvertible(self.projectName.previous),
                "project_name": AnyJSONConvertible(self.projectName.current),
                "body_was": AnyJSONConvertible(self.body.previous),
                "body": AnyJSONConvertible(self.body.current),
                "starts_at_was": AnyJSONConvertible(self.startsAt.previous),
                "starts_at": AnyJSONConvertible(self.startsAt.current),
                "ends_at_was": AnyJSONConvertible(self.endsAt.previous),
                "ends_at": AnyJSONConvertible(self.endsAt.current),
                "tag_was": AnyJSONConvertible(self.tag.previous),
                "tag": AnyJSONConvertible(self.tag.current),
                "duration_was": AnyJSONConvertible(self.duration.previous),
                "duration": AnyJSONConvertible(self.duration.current),
                "task_was": AnyJSONConvertible(self.task.previous),
                "task": AnyJSONConvertible(self.task.current),
                "task_preview_was": AnyJSONConvertible(self.taskPreview.previous),
                "task_preview": AnyJSONConvertible(self.taskPreview.current)
            ]
        }
    }
}

extension TaskVersion: JSONObjectType {
    public func jsonConvertible() throws -> JSONConvertible {
        let wrapper = TaskVersionFactory.Wrapper(
            event: self.event,
            updatedBy: self.updatedBy,
            updatedAt: self.updatedAt,
            projectName: self.projectName,
            body: self.body,
            startsAt: self.startsAt,
            endsAt: self.endsAt,
            tag: self.tag,
            duration: self.duration,
            task: self.task,
            taskPreview: self.taskPreview)
        return wrapper.jsonConvertible()
    }
}

extension TaskVersion.Event: JSONObjectType {
    public func jsonConvertible() throws -> JSONConvertible {
        self.rawValue
    }
}
