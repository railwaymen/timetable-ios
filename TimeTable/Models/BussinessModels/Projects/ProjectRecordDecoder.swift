//
//  ProjectRecordDecoder.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 02/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
import UIKit

protocol ProjectRecordDecoderFields {
    var id: Int { get }
    var name: String { get }
    var color: UIColor? { get }
    var leader: ProjectRecordDecoder.Leader { get }
    var users: [ProjectRecordDecoder.User] { get }
}

protocol ProjectRecordDecoderLeaderFields {
    var firstName: String? { get }
    var lastName: String? { get }
}

protocol ProjectRecordDecoderUserFields {
    var id: Int { get }
    var firstName: String { get }
    var lastName: String { get }
}

struct ProjectRecordDecoder: Decodable, ProjectRecordDecoderFields {
    let id: Int
    let name: String
    let color: UIColor?
    let leader: Leader
    let users: [User]
    
    enum CodingKeys: String, CodingKey {
        case id = "projectId"
        case name
        case color
        case users
    }
    
    // MARK: - Initialization
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        if let colorHexString = try? container.decode(String.self, forKey: .color) {
            self.color = UIColor(hexString: colorHexString)
        } else {
            self.color = nil
        }
        self.leader = try Leader(from: decoder)
        self.users = (try? container.decode([User].self, forKey: .users)) ?? []
    }
}

// MARK: - Structures
extension ProjectRecordDecoder {
    struct Leader: Decodable, ProjectRecordDecoderLeaderFields {
        let firstName: String?
        let lastName: String?
        
        enum CodingKeys: String, CodingKey {
            case firstName = "leaderFirstName"
            case lastName = "leaderLastName"
        }
        
        // MARK: Getters
        var name: String {
            if let firstName = self.firstName,
                let lastName = self.lastName {
                return firstName + " " + lastName
            } else if let firstName = self.firstName {
                return firstName
            } else if let lastName = self.lastName {
                return lastName
            }
            return ""
        }
        
        // MARK: Initialization
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.firstName = try? container.decode(String.self, forKey: .firstName)
            self.lastName = try? container.decode(String.self, forKey: .lastName)
        }
    }
    
    struct User: Decodable, ProjectRecordDecoderUserFields {
        let id: Int
        let firstName: String
        let lastName: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case firstName
            case lastName
        }
        
        // MARK: - Getters
        var name: String {
            self.firstName + " " + self.lastName
        }
    }
}

// MARK: - Equatable
extension ProjectRecordDecoder: Equatable {
    static func == (lhs: ProjectRecordDecoder, rhs: ProjectRecordDecoder) -> Bool {
        return lhs.id == rhs.id
    }
}

extension ProjectRecordDecoder.Leader: Equatable {}

extension ProjectRecordDecoder.User: Equatable {
    static func == (lhs: ProjectRecordDecoder.User, rhs: ProjectRecordDecoder.User) -> Bool {
        return lhs.id == rhs.id
    }
}
