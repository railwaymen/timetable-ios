//
//  ProjectRecordDecoder.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 02/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
import UIKit

struct ProjectRecordDecoder {
    let identifier: Int
    let projectIdentifier: Int
    let name: String
    let color: UIColor?
    let user: User?
    let leader: User?
}

// MARK: - Structures
extension ProjectRecordDecoder {
    struct User {
        let name: String
    }
}

// MARK: - Decodable
extension ProjectRecordDecoder: Decodable {
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case projectIdentifier = "project_id"
        case name
        case color
        case user
        case leader
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.identifier = try container.decode(Int.self, forKey: .identifier)
        self.projectIdentifier = try container.decode(Int.self, forKey: .projectIdentifier)
        self.name = try container.decode(String.self, forKey: .name)
        if let colorHexString = try? container.decode(String.self, forKey: .color) {
            self.color = UIColor(hexString: colorHexString)
        } else {
            self.color = nil
        }
        self.user = try? container.decode(User.self, forKey: .user)
        self.leader = try? container.decode(User.self, forKey: .leader)
    }
}

extension ProjectRecordDecoder.User: Decodable {
    enum CodingKeys: String, CodingKey {
        case name
    }
}

// MARK: - Equatable
extension ProjectRecordDecoder.User: Equatable {}
