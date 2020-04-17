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
    func build(wrapper: Wrapper? = nil) throws -> WorkTimeDecoder {
        let finalWrapper = try wrapper ?? Wrapper(project: try SimpleProjectRecordDecoderFactory().build())
        return try self.buildObject(of: finalWrapper.jsonConvertible())
    }
}

// MARK: - Structures
extension WorkTimeDecoderFactory {
    struct Wrapper: WorkTimeDecoderFieldsProtocol {
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
        let project: SimpleProjectRecordDecoder
        let date: Date
        let tag: ProjectTag
        let versions: [TaskVersion]
        
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
            project: SimpleProjectRecordDecoder,
            date: Date = Date(),
            tag: ProjectTag = .default,
            versions: [TaskVersion] = []
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
            self.versions = versions
        }
        
        func jsonConvertible() -> AnyJSONConvertible {
            return [
                "id": AnyJSONConvertible(self.identifier),
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
                "date": AnyJSONConvertible(DateFormatter.simple.string(from: self.date)),
                "tag": AnyJSONConvertible(self.tag),
                "versions": AnyJSONConvertible(self.versions)
            ]
        }
    }
}

// MARK: - Helper extensions
extension ProjectTag: JSONObjectType {
    public func jsonConvertible() throws -> JSONConvertible {
        return self.rawValue
    }
}

extension WorkTimeDecoder: JSONObjectType {
    public func jsonConvertible() throws -> JSONConvertible {
        let wrapper = WorkTimeDecoderFactory.Wrapper(
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
            tag: self.tag,
            versions: self.versions)
        return wrapper.jsonConvertible()
    }
}
