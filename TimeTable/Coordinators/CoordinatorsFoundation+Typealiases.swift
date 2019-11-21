//
//  CoordinatorsFoundation+Typealiases.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 21/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
import CoordinatorsFoundation

enum CoordinatorType: String, CoordinatorTypable {
    case home
}

typealias Coordinator = CoordinatorsFoundation.Coordinator<Int, CoordinatorType>
typealias ControllerCoordinator = CoordinatorsFoundation.ControllerCoordinator<Int, CoordinatorType>
typealias NavigationCoordinator = CoordinatorsFoundation.NavigationCoordinator<Int, CoordinatorType>
typealias TabBarCoordinator = CoordinatorsFoundation.TabBarCoordinator<Int, CoordinatorType>
typealias TabBarChildCoordinatorType = CoordinatorsFoundation.TabBarChildCoordinatorType
