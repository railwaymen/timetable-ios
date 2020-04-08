//
//  ProjectTag.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 29/05/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

enum ProjectTag: String, Codable {
    case development = "dev"
    case internalMeeting = "im"
    case clientCommunication = "cc"
    case research = "res"
    
    static var `default`: ProjectTag {
        return .development
    }
    
    var localized: String? {
        switch self {
        case .internalMeeting:
            return R.string.localizable.project_im()
        case .clientCommunication:
            return R.string.localizable.project_cc()
        case .research:
            return R.string.localizable.project_res()
        case .development:
            return nil
        }
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
