//
//  StoryboardsManagerMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit
@testable import TimeTable

class StoryboardsManagerMock: StoryboardsManagerType {
    var loginController: UIViewController?
    var projectsController: UIViewController?
    var serverConfigurationController: UIViewController?
    var userController: UIViewController?
    var workTimeController: UIViewController?
    var workTimesListController: UIViewController?
    
    func controller<T>(storyboard: StoryboardsManager.StoryboardName, controllerIdentifier: StoryboardsManager.ControllerIdentifier) -> T? {
        switch storyboard {
        case .login: return loginController as? T
        case .projects: return projectsController as? T
        case .serverConfiguration: return serverConfigurationController as? T
        case .user: return userController as? T
        case .workTime: return workTimeController as? T
        case .workTimesList: return workTimesListController as? T
        }
    }
}
