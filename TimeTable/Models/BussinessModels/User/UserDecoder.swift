//
//  UserDecoder.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 18/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

struct UserDecoder {
    let identifier: Int
    let firstName: String
    let lastName: String
    let email: String
}

// MARK: - Decodable
extension UserDecoder: Decodable {
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email
    }
}

// MARK: - Equatable
extension UserDecoder: Equatable {
    static func == (lhs: UserDecoder, rhs: UserDecoder) -> Bool {
        return lhs.email == rhs.email
            && lhs.firstName == rhs.firstName
            && lhs.lastName == rhs.lastName
    }
}
