//
//  SessionDecoder.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 02/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

struct SessionDecoder: Codable {
    let identifier: Int
    let firstName: String
    let lastName: String
    let isLeader: Bool
    let admin: Bool
    let manager: Bool
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case firstName
        case lastName
        case isLeader
        case admin
        case manager
        case token
    }
}

// MARK: - Equatable
extension SessionDecoder: Equatable {
    static func == (lhs: SessionDecoder, rhs: SessionDecoder) -> Bool {
        return lhs.identifier == rhs.identifier
            && lhs.firstName == rhs.firstName
            && lhs.lastName == rhs.lastName
            && lhs.isLeader == rhs.isLeader
            && lhs.admin == rhs.admin
            && lhs.manager == rhs.manager
            && lhs.token == rhs.token
    }
}
