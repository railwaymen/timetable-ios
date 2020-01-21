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
    func build(wrapper: ProjectRecordDecoderWrapper = ProjectRecordDecoderWrapper()) throws -> ProjectRecordDecoder {
        return try self.buildObject(of: wrapper.jsonConvertible())
    }
    
    func buildUser(wrapper: UserWrapper = UserWrapper()) throws -> ProjectRecordDecoder.User {
        return try self.buildObject(of: wrapper.jsonConvertible())
    }
}

// MARK: - Structures
extension ProjectRecordDecoderFactory {
    struct ProjectRecordDecoderWrapper {
        let identifier: Int
        let projectId: Int
        let name: String
        let color: UIColor?
        let user: ProjectRecordDecoder.User?
        let leader: ProjectRecordDecoder.User?
        
        init(
            identifier: Int = 0,
            projectId: Int = 0,
            name: String = "name",
            color: UIColor? = nil,
            user: ProjectRecordDecoder.User? = nil,
            leader: ProjectRecordDecoder.User? = nil
        ) {
            self.identifier = identifier
            self.projectId = projectId
            self.name = name
            self.color = color
            self.user = user
            self.leader = leader
        }
        
        func jsonConvertible() -> AnyJSONConvertible {
            return [
                "id": AnyJSONConvertible(self.identifier),
                "project_id": AnyJSONConvertible(self.projectId),
                "name": AnyJSONConvertible(self.name),
                "color": AnyJSONConvertible(self.color),
                "user": AnyJSONConvertible(self.user),
                "leader": AnyJSONConvertible(self.leader)
            ]
        }
    }
    
    struct UserWrapper {
        let name: String
        
        init(
            name: String = "name"
        ) {
            self.name = name
        }
        
        func jsonConvertible() -> AnyJSONConvertible {
            return [
                "name": AnyJSONConvertible(self.name)
            ]
        }
    }
}

// MARK: - Helper extensions
extension ProjectRecordDecoder.User: JSONObjectType {
    public func jsonConvertible() throws -> JSONConvertible {
        let wrapper = ProjectRecordDecoderFactory.UserWrapper(
            name: self.name)
        return wrapper.jsonConvertible()
    }
}
