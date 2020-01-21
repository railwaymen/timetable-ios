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

// MARK: - Helper extension
extension UserDecoder: JSONObjectType {
    public func jsonConvertible() throws -> JSONConvertible {
        let wrapper = UserDecoderWrapper(
            identifier: self.identifier,
            firstName: self.firstName,
            lastName: self.lastName,
            email: self.email)
        return wrapper.jsonConvertible()
    }
}

// MARK: - Structures
struct UserDecoderWrapper {
    let identifier: Int
    let firstName: String
    let lastName: String
    let email: String
    
    init(
        identifier: Int = 0,
        firstName: String = "firstName",
        lastName: String = "lastName",
        email: String = "email"
    ) {
        self.identifier = identifier
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
    
    func jsonConvertible() -> AnyJSONConvertible {
        return [
            "identifier": AnyJSONConvertible(self.identifier),
            "firstName": AnyJSONConvertible(self.firstName),
            "lastName": AnyJSONConvertible(self.lastName),
            "email": AnyJSONConvertible(self.email)
        ]
    }
}
