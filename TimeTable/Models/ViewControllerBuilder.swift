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
    func accountingPeriods() throws -> AccountingPeriodsViewControllerable
    func vacation() throws -> VacationViewControllerable
    func usedVacation() throws -> UsedVacationViewControllerable
}

class ViewControllerBuilder {}

// MARK: - Structures
extension ViewControllerBuilder {
    enum Error: String, Swift.Error, Equatable, CustomStringConvertible {
        case viewControllerNotFound
        case unableToCastViewController
        
        var description: String {
            "[\(ViewControllerBuilder.self)] " + self.rawValue
        }
    }
}

// MARK: - ViewControllerBuilderType
extension ViewControllerBuilder: ViewControllerBuilderType {
    func serverConfiguration() throws -> ServerConfigurationViewControllerable {
        try self.cast(R.storyboard.serverConfiguration().instantiateInitialViewController())
    }
    
    func login() throws -> LoginViewControllerable {
        try self.cast(R.storyboard.login().instantiateInitialViewController())
    }
    
    func projects() throws -> ProjectsViewControllerable {
        try self.cast(R.storyboard.projects().instantiateInitialViewController())
    }
    
    func workTimesList() throws -> WorkTimesListViewControllerable {
        try self.cast(R.storyboard.workTimesList().instantiateInitialViewController())
    }
    
    func workTimeContainer() throws -> WorkTimeContainerViewControllerable {
        try self.cast(R.storyboard.workTime().instantiateInitialViewController())
    }
    
    func projectPicker() -> ProjectPickerViewControllerable {
        ProjectPickerViewController()
    }
    
    func taskHistory() throws -> TaskHistoryViewControllerable {
        try self.cast(R.storyboard.taskHistory().instantiateInitialViewController())
    }
    
    func profile() throws -> ProfileViewControllerable {
        try self.cast(R.storyboard.profile().instantiateInitialViewController())
    }
    
    func accountingPeriods() throws -> AccountingPeriodsViewControllerable {
        try self.cast(R.storyboard.accountingPeriods().instantiateInitialViewController())
    }
    
    func vacation() throws -> VacationViewControllerable {
        try self.cast(R.storyboard.vacation().instantiateInitialViewController())
    }
    
    func usedVacation() throws -> UsedVacationViewControllerable {
        try self.cast(R.storyboard.vacation().instantiateViewController(identifier: "UsedVacationViewControllerID"))
    }
}

// MARK: - Private
extension ViewControllerBuilder {
    private func cast<T>(_ viewController: UIViewController?, to type: T.Type = T.self) throws -> T {
        guard let viewController = viewController else { throw Error.viewControllerNotFound }
        guard let castedViewController = viewController as? T else { throw Error.unableToCastViewController }
        return castedViewController
    }
}
