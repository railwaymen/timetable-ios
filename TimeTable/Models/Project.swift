//
//  Project.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 02/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
import UIKit

class Project {
    let identifier: Int
    let name: String
    let color: UIColor
    var users: [User]
    let leader: User?
    
    // MARK: - Initialization
    init(decoder: ProjectRecordDecoder) {
        self.identifier = decoder.projectId
        self.name = decoder.name
        self.color = decoder.color ?? .black
        if let userDecoder = decoder.user {
            self.users = [User(decoder: userDecoder)]
        } else {
            self.users = []
        }
        if let leaderDecoder = decoder.leader {
            self.leader = User(decoder: leaderDecoder)
        } else {
            self.leader = nil
        }
    }
}

// MARK: - Structures
extension Project {
    struct User {
        let name: String
        
        // MARK: Initialization
        init(decoder: ProjectRecordDecoder.User) {
            self.name = decoder.name
        }
        
        init(name: String) {
            self.name = name
        }
    }
}

// MARK: - Equatable
extension Project: Equatable {
    static func == (lhs: Project, rhs: Project) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.name == rhs.name
    }
}

// MARK: - Hashable
extension Project: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.identifier.hashValue)
    }
}

extension Project.User: Hashable {}
