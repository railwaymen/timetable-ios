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

class StoryboardsManager: StoryboardsManagerType {
    
    static var shared: StoryboardsManagerType = StoryboardsManager()
    
    enum StoryboardName: String {
        case serverConfiguration = "ServerConfiguration"
        case login = "Login"
    }
    
    enum ControllerIdentifier: String {
        case initial
    }
    
    func controller<T>(storyboard: StoryboardsManager.StoryboardName, controllerIdentifier: ControllerIdentifier) -> T? {
        
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        switch controllerIdentifier {
        case .initial:
            return storyboard.instantiateInitialViewController() as? T
        }
    }
}
