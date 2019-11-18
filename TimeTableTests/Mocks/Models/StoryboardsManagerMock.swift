//
//  StoryboardsManagerMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit
@testable import TimeTable

class StoryboardsManagerMock {
    var controllerReturnValue: [StoryboardsManager.StoryboardName: [StoryboardsManager.ControllerIdentifier: UIViewController]] = [:]
}

// MARK: - StoryboardsManagerType
extension StoryboardsManagerMock: StoryboardsManagerType {
    func controller<T>(storyboard: StoryboardsManager.StoryboardName, controllerIdentifier: StoryboardsManager.ControllerIdentifier) -> T? {
        return self.controllerReturnValue[storyboard]?[controllerIdentifier] as? T
    }
}
