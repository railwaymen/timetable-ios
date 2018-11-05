//
//  SessionDecoder.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 02/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

struct SessionDecoder: Decodable {
    let identifier: Int
    let firstName: String
    let lastName: String
    let isLeader: Bool
    let admin: Bool
    let manager: Bool
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case isLeader = "is_leader"
        case admin
        case manager
        case token
    }
}
