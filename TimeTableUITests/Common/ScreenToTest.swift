//
//  ScreenToTest.swift
//  TimeTableUITests
//
//  Created by Bartłomiej Świerad on 25/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

enum ScreenToTest: String {
    case serverConfiguration
    case login
    
    var elementsType: UIElements.Type {
        switch self {
        case .serverConfiguration:
            return ServerConfigurationUIElements.self
        case .login:
            return LoginUIElements.self
        }
    }
}
