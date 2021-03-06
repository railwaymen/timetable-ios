//
//  SessionDecoderFactory.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 21/01/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
import JSONFactorable
@testable import TimeTable

class SessionDecoderFactory: JSONFactorable {
    func build(wrapper: SessionDecoderWrapper = SessionDecoderWrapper()) throws -> SessionDecoder {
        return try self.buildObject(of: wrapper.jsonConvertible())
    }
}

// MARK: - Structures
extension SessionDecoderFactory {
    struct SessionDecoderWrapper {
        let id: Int
        let firstName: String
        let lastName: String
        let isLeader: Bool
        let admin: Bool
        let manager: Bool
        let token: String
        
        init(
            id: Int = 0,
            firstName: String = "john",
            lastName: String = "little",
            isLeader: Bool = false,
            admin: Bool = false,
            manager: Bool = false,
            token: String = "token_123"
        ) {
            self.id = id
            self.firstName = firstName
            self.lastName = lastName
            self.isLeader = isLeader
            self.admin = admin
            self.manager = manager
            self.token = token
        }
        
        func jsonConvertible() -> AnyJSONConvertible {
            return [
                "id": AnyJSONConvertible(self.id),
                "first_name": AnyJSONConvertible(self.firstName),
                "last_name": AnyJSONConvertible(self.lastName),
                "is_leader": AnyJSONConvertible(self.isLeader),
                "admin": AnyJSONConvertible(self.admin),
                "manager": AnyJSONConvertible(self.manager),
                "token": AnyJSONConvertible(self.token)
            ]
        }
    }
}

// MARK: - Helper extesions
extension SessionDecoder: JSONObjectType {
    public func jsonConvertible() throws -> JSONConvertible {
        let wrapper = SessionDecoderFactory.SessionDecoderWrapper(
            id: self.id,
            firstName: self.firstName,
            lastName: self.lastName,
            isLeader: self.isLeader,
            admin: self.admin,
            manager: self.manager,
            token: self.token)
        return wrapper.jsonConvertible()
    }
}
