//
//  Endpoints.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 06/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

enum Endpoints {
    case projects
    case projectsSimpleList
    case signIn
    case workTimes
    case user(Int64)
    
    var value: String {
        switch self {
        case .projects: return "/projects"
        case .projectsSimpleList: return "/projects/simple"
        case .signIn: return "/users/sign_in"
        case .workTimes: return "/work_times"
        case .user(let identifier): return "/users/\(identifier)"
        }
    }
}
