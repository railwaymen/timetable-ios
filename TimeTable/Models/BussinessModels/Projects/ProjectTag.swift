//
//  ProjectTag.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 29/05/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

enum ProjectTag: String {
    case development = "dev"
    case internalMeeting = "im"
    case clientCommunication = "cc"
    case research = "res"
    
    static var `default`: ProjectTag {
        return .development
    }
    
    var localized: String? {
        guard self != .default else { return nil }
        return ("project_" + self.rawValue).localized
    }
    
    var color: UIColor {
        switch self {
        case .development: return .white
        case .clientCommunication: return .clientCommunicationTag
        case .internalMeeting: return .internalMeetingTag
        case .research: return .researchTag
        }
    }
}

// MARK: - Codable
extension ProjectTag: Codable {}
