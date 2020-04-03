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
                "updatedBy": AnyJSONConvertible(self.updatedBy),
                "createdAt": AnyJSONConvertible(self.updatedAt),
                "projectNameWas": AnyJSONConvertible(self.projectName.previous),
                "projectName": AnyJSONConvertible(self.projectName.current),
                "bodyWas": AnyJSONConvertible(self.body.previous),
                "body": AnyJSONConvertible(self.body.current),
                "startsAtWas": AnyJSONConvertible(self.startsAt.previous),
                "startsAt": AnyJSONConvertible(self.startsAt.current),
                "endsAtWas": AnyJSONConvertible(self.endsAt.previous),
                "endsAt": AnyJSONConvertible(self.endsAt.current),
                "tagWas": AnyJSONConvertible(self.tag.previous),
                "tag": AnyJSONConvertible(self.tag.current),
                "durationWas": AnyJSONConvertible(self.duration.previous),
                "duration": AnyJSONConvertible(self.duration.current),
                "taskWas": AnyJSONConvertible(self.task.previous),
                "task": AnyJSONConvertible(self.task.current),
                "taskPreviewWas": AnyJSONConvertible(self.taskPreview.previous),
                "taskPreview": AnyJSONConvertible(self.taskPreview.current)
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
