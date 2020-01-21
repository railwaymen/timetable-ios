//
//  WorkTimeDecoderFactory.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 21/01/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
import JSONFactorable
@testable import TimeTable

class WorkTimeDecoderFactory: JSONFactorable {
    func build(wrapper: WorkTimeDecoderWrapper? = nil) throws -> WorkTimeDecoder {
        let finalWrapper = try wrapper ?? WorkTimeDecoderWrapper(project: try ProjectDecoderFactory().build())
        return try self.buildObject(of: finalWrapper.jsonConvertible())
    }
}

// MARK: - Helper extensions
extension WorkTimeDecoder: JSONObjectType {
    public func jsonConvertible() throws -> JSONConvertible {
        let wrapper = WorkTimeDecoderWrapper(
            identifier: self.identifier,
            updatedByAdmin: self.updatedByAdmin,
            projectId: self.projectId,
            startsAt: self.startsAt,
            endsAt: self.endsAt,
            duration: self.duration,
            body: self.body,
            task: self.task,
            taskPreview: self.taskPreview,
            userId: self.userId,
            project: self.project,
            date: self.date,
            tag: self.tag)
        return wrapper.jsonConvertible()
    }
}

// MARK: - Structures
struct WorkTimeDecoderWrapper {
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
    
    init(
        identifier: Int64 = 0,
        updatedByAdmin: Bool = false,
        projectId: Int = 0,
        startsAt: Date = Date(),
        endsAt: Date = Date(),
        duration: Int64 = 1,
        body: String? = nil,
        task: String? = nil,
        taskPreview: String? = nil,
        userId: Int = 0,
        project: ProjectDecoder,
        date: Date = Date(),
        tag: ProjectTag = .default
    ) {
        self.identifier = identifier
        self.updatedByAdmin = updatedByAdmin
        self.projectId = projectId
        self.startsAt = startsAt
        self.endsAt = endsAt
        self.duration = duration
        self.body = body
        self.task = task
        self.taskPreview = taskPreview
        self.userId = userId
        self.project = project
        self.date = date
        self.tag = tag
    }
    
    func jsonConvertible() -> AnyJSONConvertible {
        return [
            "identifier": AnyJSONConvertible(self.identifier),
            "updatedByAdmin": AnyJSONConvertible(self.updatedByAdmin),
            "projectId": AnyJSONConvertible(self.projectId),
            "startsAt": AnyJSONConvertible(self.startsAt),
            "endsAt": AnyJSONConvertible(self.endsAt),
            "duration": AnyJSONConvertible(self.duration),
            "body": AnyJSONConvertible(self.body),
            "task": AnyJSONConvertible(self.task),
            "taskPreview": AnyJSONConvertible(self.taskPreview),
            "userId": AnyJSONConvertible(self.userId),
            "project": AnyJSONConvertible(self.project),
            "date": AnyJSONConvertible(self.date),
            "tag": AnyJSONConvertible(self.tag)
        ]
    }
}
