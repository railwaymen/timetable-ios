//
//  Endpoint.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 06/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
import Restler

enum Endpoint: RestlerEndpointable {
    case matchingFullTime
    case projects
    case projectsSimpleList
    case signIn
    case workTime(Int64)
    case workTimes
    case workTimesCreateWithFilling
    case user(Int64)
    
    var restlerEndpointValue: String {
        switch self {
        case .matchingFullTime: return "/accounting_periods/matching_fulltime"
        case .projects: return "/projects"
        case .projectsSimpleList: return "/projects/simple"
        case .signIn: return "/users/sign_in"
        case .workTime(let identifier): return "/work_times/\(identifier)"
        case .workTimes: return "/work_times"
        case .workTimesCreateWithFilling: return "/work_times/create_filling_gaps"
        case .user(let identifier): return "/users/\(identifier)"
        }
    }
}
