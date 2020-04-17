//
//  UserDecoder.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 18/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//w

import Foundation

struct UserDecoder: Decodable {
    let identifier: Int
    let firstName: String
    let lastName: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case firstName
        case lastName
        case email
    }
    
    // MARK: - Initialization
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.identifier = try container.decode(Int.self, forKey: .identifier)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.email = try container.decode(String.self, forKey: .email)
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
