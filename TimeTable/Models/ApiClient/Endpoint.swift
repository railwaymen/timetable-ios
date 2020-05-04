//
//  Endpoint.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 06/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
import Restler

enum Endpoint: RestlerEndpointable, Equatable {
    case accountingPeriods
    case matchingFullTime
    case projects
    case projectsSimpleList
    case signIn
    case tags
    case workTime(Int64)
    case workTimes
    case workTimesCreateWithFilling
    case user(Int64)
    case vacation
    case vacationDecline(Int)
    
    var restlerEndpointValue: String {
        switch self {
        case .accountingPeriods: return "/accounting_periods"
        case .matchingFullTime: return "/accounting_periods/matching_fulltime"
        case .projects: return "/projects"
        case .projectsSimpleList: return "/projects/simple"
        case .signIn: return "/users/sign_in"
        case .tags: return "/projects/tags"
        case let .workTime(id): return "/work_times/\(id)"
        case .workTimes: return "/work_times"
        case .workTimesCreateWithFilling: return "/work_times/create_filling_gaps"
        case let .user(id): return "/users/\(id)"
        case .vacation: return "/vacations"
        case let .vacationDecline(id): return "/vacations/\(id)/self_decline"
        }
    }
}
