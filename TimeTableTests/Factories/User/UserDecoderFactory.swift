//
//  UserDecoderFactory.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 21/01/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
import JSONFactorable
@testable import TimeTable

class UserDecoderFactory: JSONFactorable {
    func build(wrapper: UserDecoderWrapper = UserDecoderWrapper()) throws -> UserDecoder {
        return try self.buildObject(of: wrapper.jsonConvertible())
    }
}

// MARK: - Structures
extension UserDecoderFactory {
    struct UserDecoderWrapper {
        let id: Int
        let firstName: String
        let lastName: String
        let email: String
        
        init(
            id: Int = 0,
            firstName: String = "firstName",
            lastName: String = "lastName",
            email: String = "email"
        ) {
            self.id = id
            self.firstName = firstName
            self.lastName = lastName
            self.email = email
        }
        
        func jsonConvertible() -> AnyJSONConvertible {
            return [
                "id": AnyJSONConvertible(self.id),
                "first_name": AnyJSONConvertible(self.firstName),
                "last_name": AnyJSONConvertible(self.lastName),
                "email": AnyJSONConvertible(self.email)
            ]
        }
    }
}

// MARK: - Helper extension
extension UserDecoder: JSONObjectType {
    public func jsonConvertible() throws -> JSONConvertible {
        let wrapper = UserDecoderFactory.UserDecoderWrapper(
            id: self.id,
            firstName: self.firstName,
            lastName: self.lastName,
            email: self.email)
        return wrapper.jsonConvertible()
    }
}
