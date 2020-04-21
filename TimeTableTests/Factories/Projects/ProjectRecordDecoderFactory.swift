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
        id: Int = 0,
        name: String = "name",
        color: UIColor? = nil,
        leader: ProjectRecordDecoder.Leader? = nil,
        users: [ProjectRecordDecoder.User] = []
    ) throws -> ProjectRecordDecoder {
        let wrapper = Wrapper(
            id: id,
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
        id: Int = 0,
        firstName: String = "John",
        lastName: String = "Smith"
    ) throws -> ProjectRecordDecoder.User {
        let wrapper = UserWrapper(
            id: id,
            firstName: firstName,
            lastName: lastName)
        return try self.buildObject(of: wrapper.jsonConvertible())
    }
}

// MARK: - Structures
extension ProjectRecordDecoderFactory {
    struct Wrapper: ProjectRecordDecoderFields {
        let id: Int
        let name: String
        let color: UIColor?
        let leader: ProjectRecordDecoder.Leader
        let users: [ProjectRecordDecoder.User]
        
        init(
            id: Int = 0,
            name: String = "name",
            color: UIColor? = nil,
            leader: ProjectRecordDecoder.Leader,
            users: [ProjectRecordDecoder.User] = []
        ) {
            self.id = id
            self.name = name
            self.color = color
            self.leader = leader
            self.users = users
        }
        
        func jsonConvertible() throws -> AnyJSONConvertible {
            var jsonObject: AnyJSONConvertible = [
                "project_id": AnyJSONConvertible(self.id),
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
        let id: Int
        let firstName: String
        let lastName: String
        
        init(
            id: Int = 0,
            firstName: String = "John",
            lastName: String = "Smith"
        ) {
            self.id = id
            self.firstName = firstName
            self.lastName = lastName
            
        }
        
        func jsonConvertible() -> AnyJSONConvertible {
            return [
                "id": AnyJSONConvertible(self.id),
                "first_name": AnyJSONConvertible(self.firstName),
                "last_name": AnyJSONConvertible(self.lastName)
            ]
        }
    }
}

// MARK: - Helper extensions
extension ProjectRecordDecoder: JSONObjectType {
    public func jsonConvertible() throws -> JSONConvertible {
        let wrapper = ProjectRecordDecoderFactory.Wrapper(
            id: self.id,
            name: self.name,
            color: self.color,
            leader: self.leader,
            users: self.users)
        return try wrapper.jsonConvertible()
    }
}

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
            id: self.id,
            firstName: self.firstName,
            lastName: self.lastName)
        return wrapper.jsonConvertible()
    }
}
