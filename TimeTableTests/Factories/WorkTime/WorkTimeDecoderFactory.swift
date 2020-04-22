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
        
        init(
            id: Int64 = 0,
            updatedByAdmin: Bool = false,
            projectID: Int = 0,
            startsAt: Date = Date(),
            endsAt: Date = Date(),
            duration: Int64 = 1,
            body: String? = nil,
            task: String? = nil,
            taskPreview: String? = nil,
            userID: Int = 0,
            project: SimpleProjectRecordDecoder,
            date: Date = Date(),
            tag: ProjectTag = .default,
            versions: [TaskVersion] = []
        ) {
            self.id = id
            self.updatedByAdmin = updatedByAdmin
            self.projectID = projectID
            self.startsAt = startsAt
            self.endsAt = endsAt
            self.duration = duration
            self.body = body
            self.task = task
            self.taskPreview = taskPreview
            self.userID = userID
            self.project = project
            self.date = date
            self.tag = tag
            self.versions = versions
        }
        
        func jsonConvertible() -> AnyJSONConvertible {
            return [
                "id": AnyJSONConvertible(self.id),
                "updated_by_admin": AnyJSONConvertible(self.updatedByAdmin),
                "project_id": AnyJSONConvertible(self.projectID),
                "starts_at": AnyJSONConvertible(self.startsAt),
                "ends_at": AnyJSONConvertible(self.endsAt),
                "duration": AnyJSONConvertible(self.duration),
                "body": AnyJSONConvertible(self.body),
                "task": AnyJSONConvertible(self.task),
                "task_preview": AnyJSONConvertible(self.taskPreview),
                "user_id": AnyJSONConvertible(self.userID),
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
            id: self.id,
            updatedByAdmin: self.updatedByAdmin,
            projectID: self.projectID,
            startsAt: self.startsAt,
            endsAt: self.endsAt,
            duration: self.duration,
            body: self.body,
            task: self.task,
            taskPreview: self.taskPreview,
            userID: self.userID,
            project: self.project,
            date: self.date,
            tag: self.tag,
            versions: self.versions)
        return wrapper.jsonConvertible()
    }
}
