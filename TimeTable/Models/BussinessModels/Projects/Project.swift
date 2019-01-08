//
//  Project.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 02/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
import UIKit

class Project: Hashable {
    let identifier: Int
    let name: String
    let color: UIColor
    var users: [User]
    let leader: User?
    
    struct User: Hashable {
        let name: String
        
        init(decoder: ProjectRecordDecoder.User) {
            name = decoder.name
        }
        
        init(name: String) {
            self.name = name
        }
    }
    
    // MARK: - Initialization
    init(decoder: ProjectRecordDecoder) {
        identifier = decoder.projectIdentifier
        name = decoder.name
        color = decoder.color ?? .black
        if let userDecoder = decoder.user {
            users = [User(decoder: userDecoder)]
        } else {
            users = []
        }
        if let leaderDecoder = decoder.leader {
            leader = User(decoder: leaderDecoder)
        } else {
            leader = nil
        }
    }
    
    // MARK: - Hashable
    var hashValue: Int {
        return identifier.hashValue
    }
    
    // MARK: - Equatable
    static func == (lhs: Project, rhs: Project) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.name == rhs.name
    }
}
