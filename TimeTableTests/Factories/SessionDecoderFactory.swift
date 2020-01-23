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
        let identifier: Int
        let firstName: String
        let lastName: String
        let isLeader: Bool
        let admin: Bool
        let manager: Bool
        let token: String
        
        init(
            identifier: Int = 0,
            firstName: String = "firstName",
            lastName: String = "lastName",
            isLeader: Bool = false,
            admin: Bool = false,
            manager: Bool = false,
            token: String = "token"
        ) {
            self.identifier = identifier
            self.firstName = firstName
            self.lastName = lastName
            self.isLeader = isLeader
            self.admin = admin
            self.manager = manager
            self.token = token
        }
        
        func jsonConvertible() -> AnyJSONConvertible {
            return [
                "id": AnyJSONConvertible(self.identifier),
                "firstName": AnyJSONConvertible(self.firstName),
                "lastName": AnyJSONConvertible(self.lastName),
                "isLeader": AnyJSONConvertible(self.isLeader),
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
            identifier: self.identifier,
            firstName: self.firstName,
            lastName: self.lastName,
            isLeader: self.isLeader,
            admin: self.admin,
            manager: self.manager,
            token: self.token)
        return wrapper.jsonConvertible()
    }
}
