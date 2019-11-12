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
        case .login: return self.loginController as? T
        case .projects: return self.projectsController as? T
        case .serverConfiguration: return self.serverConfigurationController as? T
        case .profile: return self.userController as? T
        case .workTime: return self.workTimeController as? T
        case .workTimesList: return self.workTimesListController as? T
        }
    }
}
