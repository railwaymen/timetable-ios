//
//  ProjectRecordDecoder.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 02/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
import UIKit

struct ProjectRecordDecoder: Decodable {
    let identifier: Int
    let projectId: Int
    let name: String
    let color: UIColor?
    let user: User?
    let leader: User?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case projectId
        case name
        case color
        case user
        case leader
    }
    
    // MARK: - Initialization
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.identifier = try container.decode(Int.self, forKey: .identifier)
        self.projectId = try container.decode(Int.self, forKey: .projectId)
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

// MARK: - Structures
extension ProjectRecordDecoder {
    struct User: Decodable {
        let name: String
        
        enum CodingKeys: String, CodingKey {
            case name
        }
    }
}

// MARK: - Equatable
extension ProjectRecordDecoder.User: Equatable {}
