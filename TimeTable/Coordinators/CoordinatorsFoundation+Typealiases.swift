//
//  CoordinatorsFoundation+Typealiases.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 21/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
import CoordinatorsFoundation

enum CoordinatorType: String, CoordinatorTypable, Equatable {
    case serverConfiguration
    case login
    case projects
    case workTimes
    case workTimeForm
    case simpleProjects
    case profile
}

enum DeepLinkOption: DeepLinkOptionable {
    #if TEST
    case testPage(CoordinatorType)
    #endif
}

typealias Coordinator = CoordinatorsFoundation.Coordinator<DeepLinkOption, CoordinatorType>
typealias ControllerCoordinator = CoordinatorsFoundation.ControllerCoordinator<DeepLinkOption, CoordinatorType>
typealias NavigationCoordinator = CoordinatorsFoundation.NavigationCoordinator<DeepLinkOption, CoordinatorType>
typealias TabBarCoordinator = CoordinatorsFoundation.TabBarCoordinator<DeepLinkOption, CoordinatorType>
typealias TabBarChildCoordinatorType = CoordinatorsFoundation.TabBarChildCoordinatorType
