//
//  ProjectRecordDecoderFactory.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 21/01/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
import JSONFactorable
@testable import TimeTable

class ProjectRecordDecoderFactory: JSONFactorable {
    
    func build(
        identifier: Int = 0,
        projectId: Int = 0,
        name: String = "name",
        color: UIColor? = nil,
        user: ProjectRecordDecoder.User? = nil,
        leader: ProjectRecordDecoder.User? = nil
    ) throws -> ProjectRecordDecoder {
        let jsonConvertible: AnyJSONConvertible = [
            "id": AnyJSONConvertible(identifier),
            "project_id": AnyJSONConvertible(projectId),
            "name": AnyJSONConvertible(name),
            "color": AnyJSONConvertible(color),
            "user": AnyJSONConvertible(user),
            "leader": AnyJSONConvertible(leader)
        ]
        return try self.buildObject(of: jsonConvertible)
    }
    
    func buildUser(
        name: String = "name"
    ) throws -> ProjectRecordDecoder.User {
        let jsonConvertible: AnyJSONConvertible = [
            "name": AnyJSONConvertible(name)
        ]
        return try self.buildObject(of: jsonConvertible)
    }
}

extension ProjectRecordDecoder.User: JSONObjectType {
    public func jsonConvertible() throws -> JSONConvertible {
        return [
            "name": AnyJSONConvertible(self.name)
        ]
    }
}
