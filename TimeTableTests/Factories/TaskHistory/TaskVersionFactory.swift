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
    func build(
        workTime: WorkTimeDecoder,
        event: TaskVersion.Event?,
        updatedBy: String,
        createdAt: Date,
        changeset: Set<TaskVersion.Change>
    ) throws -> TaskVersion {
        let wrapper = Wrapper(
            workTime: workTime,
            event: event,
            updatedBy: updatedBy,
            createdAt: createdAt,
            changeset: changeset)
        return try self.buildObject(of: wrapper.jsonConvertible())
    }
}

extension TaskVersionFactory {
    struct Wrapper: TaskVersionFieldsProtocol {
        let workTime: WorkTimeDecoder
        let event: TaskVersion.Event?
        let updatedBy: String
        let createdAt: Date
        let changeset: Set<TaskVersion.Change>
        
        init(
            workTime: WorkTimeDecoder,
            event: TaskVersion.Event?,
            updatedBy: String,
            createdAt: Date,
            changeset: Set<TaskVersion.Change>
        ) {
            self.workTime = workTime
            self.event = event
            self.updatedBy = updatedBy
            self.createdAt = createdAt
            self.changeset = changeset
        }
        
        func jsonConvertible() throws -> AnyJSONConvertible {
            let jsonConvertible: AnyJSONConvertible = [
                "event": AnyJSONConvertible(self.event),
                "updated_by": AnyJSONConvertible(self.updatedBy),
                "created_at": AnyJSONConvertible(self.createdAt),
                "changeset": AnyJSONConvertible(self.changeset)
            ]
            return try AnyJSONConvertible(self.workTime).merge(with: jsonConvertible)
        }
    }
}

extension TaskVersion: JSONObjectType {
    public func jsonConvertible() throws -> JSONConvertible {
        let wrapper = TaskVersionFactory.Wrapper(
            workTime: self.workTime,
            event: self.event,
            updatedBy: self.updatedBy,
            createdAt: self.createdAt,
            changeset: self.changeset)
        return try wrapper.jsonConvertible()
    }
}

extension TaskVersion.Event: JSONObjectType {
    public func jsonConvertible() throws -> JSONConvertible {
        self.rawValue
    }
}

extension TaskVersion.Change: JSONObjectType {
    public func jsonConvertible() throws -> JSONConvertible {
        self.rawValue
    }
}
