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
    
    var lozalized: String {
        return self.rawValue.localized
    }
    
    var color: UIColor {
        switch self {
        case .clientCommunication: return .rouge
        case .internalMeeting: return .anzac
        case .research: return .conifier
        default: return .white
        }
    }
}
