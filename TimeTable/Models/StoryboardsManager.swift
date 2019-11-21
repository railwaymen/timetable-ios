//
//  StoryboardManager.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 25/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

protocol StoryboardsManagerType: class {
    func controller<T>(storyboard: StoryboardsManager.StoryboardName, controllerIdentifier: StoryboardsManager.ControllerIdentifier) -> T?
}

extension StoryboardsManagerType {
    func controller<T>(storyboard: StoryboardsManager.StoryboardName) -> T? {
        self.controller(storyboard: storyboard, controllerIdentifier: .initial)
    }
}

class StoryboardsManager {}

// MARK: - Structures
extension StoryboardsManager {
    enum StoryboardName: String, Hashable {
        case serverConfiguration = "ServerConfiguration"
        case login = "Login"
        case workTime = "WorkTime"
        case workTimesList = "WorkTimesList"
        case projects = "Projects"
        case profile = "Profile"
    }
    
    enum ControllerIdentifier: String, Hashable {
        case initial
    }
}
 
// MARK: - StoryboardsManagerType
extension StoryboardsManager: StoryboardsManagerType {
    func controller<T>(storyboard: StoryboardsManager.StoryboardName, controllerIdentifier: ControllerIdentifier) -> T? {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        switch controllerIdentifier {
        case .initial:
            return storyboard.instantiateInitialViewController() as? T
        }
    }
}
