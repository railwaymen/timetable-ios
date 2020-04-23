//
//  UserDecoder.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 18/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

struct UserDecoder: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
    }
    
    var fullName: String {
        self.firstName + " " + self.lastName
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
