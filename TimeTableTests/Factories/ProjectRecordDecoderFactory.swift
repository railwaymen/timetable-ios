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
        leader: ProjectRecordDecoder.Leader? = nil,
        users: [ProjectRecordDecoder.User] = []
    ) throws -> ProjectRecordDecoder {
        let wrapper = Wrapper(
            identifier: identifier,
            projectId: projectId,
            name: name,
            color: color,
            leader: try leader ?? (try self.buildLeader()),
            users: users)
        return try self.buildObject(of: wrapper.jsonConvertible())
    }
    
    func buildLeader(
        firstName: String? = nil,
        lastName: String? = nil
    ) throws -> ProjectRecordDecoder.Leader {
        let wrapper  = LeaderWrapper(
            firstName: firstName,
            lastName: lastName)
        return try self.buildObject(of: wrapper.jsonConvertible())
    }
    
    func buildUser(
        identifier: Int = 0,
        firstName: String = "John",
        lastName: String = "Smith"
    ) throws -> ProjectRecordDecoder.User {
        let wrapper = UserWrapper(
            identifier: identifier,
            firstName: firstName,
            lastName: lastName)
        return try self.buildObject(of: wrapper.jsonConvertible())
    }
}

// MARK: - Structures
extension ProjectRecordDecoderFactory {
    struct Wrapper: ProjectRecordDecoderFields {
        let identifier: Int
        let projectId: Int
        let name: String
        let color: UIColor?
        let leader: ProjectRecordDecoder.Leader
        let users: [ProjectRecordDecoder.User]
        
        init(
            identifier: Int = 0,
            projectId: Int = 0,
            name: String = "name",
            color: UIColor? = nil,
            leader: ProjectRecordDecoder.Leader,
            users: [ProjectRecordDecoder.User] = []
        ) {
            self.identifier = identifier
            self.projectId = projectId
            self.name = name
            self.color = color
            self.leader = leader
            self.users = users
        }
        
        func jsonConvertible() throws -> AnyJSONConvertible {
            var jsonObject: AnyJSONConvertible = [
                "id": AnyJSONConvertible(self.identifier),
                "project_id": AnyJSONConvertible(self.projectId),
                "name": AnyJSONConvertible(self.name),
                "color": AnyJSONConvertible(self.color),
                "users": AnyJSONConvertible(self.users)
            ]
            jsonObject = try jsonObject.merge(with: AnyJSONConvertible(self.leader))
            return jsonObject
        }
    }
    
    struct LeaderWrapper: ProjectRecordDecoderLeaderFields {
        let firstName: String?
        let lastName: String?
        
        init(
            firstName: String? = nil,
            lastName: String? = nil
        ) {
            self.firstName = firstName
            self.lastName = lastName
        }
        
        func jsonConvertible() -> AnyJSONConvertible {
            return [
                "leader_first_name": AnyJSONConvertible(self.firstName),
                "leader_last_name": AnyJSONConvertible(self.lastName)
            ]
        }
        
    }
    
    struct UserWrapper: ProjectRecordDecoderUserFields {
        let identifier: Int
        let firstName: String
        let lastName: String
        
        init(
            identifier: Int = 0,
            firstName: String = "John",
            lastName: String = "Smith"
        ) {
            self.identifier = identifier
            self.firstName = firstName
            self.lastName = lastName
            
        }
        
        func jsonConvertible() -> AnyJSONConvertible {
            return [
                "id": AnyJSONConvertible(self.identifier),
                "first_name": AnyJSONConvertible(self.firstName),
                "last_name": AnyJSONConvertible(self.lastName)
            ]
        }
    }
}

// MARK: - Helper extensions
extension ProjectRecordDecoder.Leader: JSONObjectType {
    public func jsonConvertible() throws -> JSONConvertible {
        let wrapper = ProjectRecordDecoderFactory.LeaderWrapper(
            firstName: self.firstName,
            lastName: self.lastName)
        return wrapper.jsonConvertible()
    }
}

extension ProjectRecordDecoder.User: JSONObjectType {
    public func jsonConvertible() throws -> JSONConvertible {
        let wrapper = ProjectRecordDecoderFactory.UserWrapper(
            identifier: self.identifier,
            firstName: self.firstName,
            lastName: self.lastName)
        return wrapper.jsonConvertible()
    }
}
