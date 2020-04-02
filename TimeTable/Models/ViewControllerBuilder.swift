//
//  ViewControllerBuilder.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 01/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

protocol ViewControllerBuilderType: class {
    func serverConfiguration() throws -> ServerConfigurationViewControllerable
    func login() throws -> LoginViewControllerable
    func projects() throws -> ProjectsViewControllerable
    func workTimesList() throws -> WorkTimesListViewControllerable
    func workTimeContainer() throws -> WorkTimeContainerViewControllerable
    func projectPicker() -> ProjectPickerViewControllerable
    func taskHistory() throws -> TaskHistoryViewControllerable
    func profile() throws -> ProfileViewControllerable
}

class ViewControllerBuilder {
    private let storyboardsManager: StoryboardsManagerType
    
    // MARK: - Initialization
    init(storyboardsManager: StoryboardsManagerType = StoryboardsManager()) {
        self.storyboardsManager = storyboardsManager
    }
}

// MARK: - ViewControllerBuilderType
extension ViewControllerBuilder: ViewControllerBuilderType {
    func serverConfiguration() throws -> ServerConfigurationViewControllerable {
        try self.storyboardsManager.controller(storyboard: .serverConfiguration, controllerIdentifier: .initial)
    }
    
    func login() throws -> LoginViewControllerable {
        try self.storyboardsManager.controller(storyboard: .login, controllerIdentifier: .initial)
    }
    
    func projects() throws -> ProjectsViewControllerable {
        try self.storyboardsManager.controller(storyboard: .projects, controllerIdentifier: .initial)
    }
    
    func workTimesList() throws -> WorkTimesListViewControllerable {
        try self.storyboardsManager.controller(storyboard: .workTimesList, controllerIdentifier: .initial)
    }
    
    func workTimeContainer() throws -> WorkTimeContainerViewControllerable {
        try self.storyboardsManager.controller(storyboard: .workTime, controllerIdentifier: .initial)
    }
    
    func projectPicker() -> ProjectPickerViewControllerable {
        ProjectPickerViewController()
    }
    
    func taskHistory() throws -> TaskHistoryViewControllerable {
        try self.storyboardsManager.controller(storyboard: .taskHistory, controllerIdentifier: .initial)
    }
    
    func profile() throws -> ProfileViewControllerable {
        try self.storyboardsManager.controller(storyboard: .profile, controllerIdentifier: .initial)
    }
}
