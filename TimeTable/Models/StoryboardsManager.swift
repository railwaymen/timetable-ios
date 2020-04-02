//
//  StoryboardManager.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 25/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

protocol StoryboardsManagerType: class {
    func controller<T>(
        storyboard: StoryboardsManager.StoryboardName,
        controllerIdentifier: StoryboardsManager.ControllerIdentifier) throws -> T
}

class StoryboardsManager {}

// MARK: - Structures
extension StoryboardsManager {
    enum StoryboardName: String, Hashable {
        case serverConfiguration = "ServerConfiguration"
        case login = "Login"
        case taskHistory = "TaskHistory"
        case workTime = "WorkTime"
        case workTimesList = "WorkTimesList"
        case projects = "Projects"
        case profile = "Profile"
    }
    
    enum ControllerIdentifier: String, Hashable {
        case initial
    }
    
    enum Error: String, Swift.Error, Equatable, CustomStringConvertible {
        case controllerIdentifierNotFound
        case castFailed
        
        var description: String {
            "[\(StoryboardsManager.self)] " + self.rawValue
        }
    }
}
 
// MARK: - StoryboardsManagerType
extension StoryboardsManager: StoryboardsManagerType {
    func controller<T>(storyboard: StoryboardName, controllerIdentifier: ControllerIdentifier) throws -> T {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        let optionalController: UIViewController?
        switch controllerIdentifier {
        case .initial:
            optionalController = storyboard.instantiateInitialViewController()
        }
        guard let unwrappedController = optionalController else {
            throw Error.controllerIdentifierNotFound
        }
        guard let castedController = unwrappedController as? T else {
            throw Error.castFailed
        }
        return castedController
    }
}
