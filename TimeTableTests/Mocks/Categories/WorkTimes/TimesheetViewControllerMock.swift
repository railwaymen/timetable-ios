//
//  TimesheetViewControllerMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 27/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class TimesheetViewControllerMock: UIViewController {
    
    // MARK: - TimesheetViewModelOutput
    private(set) var setUpViewParams: [SetUpViewParams] = []
    struct SetUpViewParams {}
    
    private(set) var updateColorsParams: [UpdateColorsParams] = []
    struct UpdateColorsParams {}
    
    private(set) var reloadDataParams: [ReloadDataParams] = []
    struct ReloadDataParams {}
    
    private(set) var updateSelectedProjectParams: [UpdateSelectedProjectParams] = []
    struct UpdateSelectedProjectParams {
        let title: String
        let color: UIColor?
        let isEnabled: Bool
    }
    
    private(set) var updateSelectedDateParams: [UpdateSelectedDateParams] = []
    struct UpdateSelectedDateParams {
        let dateString: String
        let date: (month: Int, year: Int)
    }
    
    private(set) var updateHoursLabelParams: [UpdateHoursLabelParams] = []
    struct UpdateHoursLabelParams {
        let workedHours: String?
    }
    
    private(set) var updateAccountingPeriodLabelParams: [UpdateAccountingPeriodLabelParams] = []
    struct UpdateAccountingPeriodLabelParams {
        let text: String?
    }
    
    private(set) var setActivityIndicatorParams: [SetActivityIndicatorParams] = []
    struct SetActivityIndicatorParams {
        let isAnimating: Bool
    }
    
    private(set) var showTableViewParams: [ShowTableViewParams] = []
    struct ShowTableViewParams {}
    
    private(set) var showErrorViewParams: [ShowErrorViewParams] = []
    struct ShowErrorViewParams {}
    
    private(set) var insertSectionsParams: [InsertSectionsParams] = []
    struct InsertSectionsParams {
        let sections: IndexSet
    }
    
    private(set) var removeSectionsParams: [RemoveSectionsParams] = []
    struct RemoveSectionsParams {
        let sections: IndexSet
    }
    
    private(set) var reloadSectionsParams: [ReloadSectionsParams] = []
    struct ReloadSectionsParams {
        let sections: IndexSet
    }
    
    private(set) var performBatchUpdatesParams: [PerformBatchUpdatesParams] = []
    struct PerformBatchUpdatesParams {
        let updates: (() -> Void)?
    }
    
    private(set) var keyboardStateDidChangeParams: [KeyboardStateDidChangeParams] = []
    struct KeyboardStateDidChangeParams {
        let keyboardState: KeyboardManager.KeyboardState
    }
    
    // MARK: - TimesheetViewControllerType
    private(set) var configureParams: [ConfigureParams] = []
    struct ConfigureParams {
        let viewModel: TimesheetViewModelType
    }
}

// MARK: - TimesheetViewModelOutput
extension TimesheetViewControllerMock: TimesheetViewModelOutput {
    func setUpView() {
        self.setUpViewParams.append(SetUpViewParams())
    }
    
    func updateColors() {
        self.updateColorsParams.append(UpdateColorsParams())
    }
    
    func reloadData() {
        self.reloadDataParams.append(ReloadDataParams())
    }
    
    func updateSelectedProject(title: String, color: UIColor?, isEnabled: Bool) {
        self.updateSelectedProjectParams.append(UpdateSelectedProjectParams(title: title, color: color, isEnabled: isEnabled))
    }
    
    func updateSelectedDate(_ dateString: String, date: (month: Int, year: Int)) {
        self.updateSelectedDateParams.append(UpdateSelectedDateParams(dateString: dateString, date: date))
    }
   
    func updateHoursLabel(workedHours: String?) {
        self.updateHoursLabelParams.append(UpdateHoursLabelParams(workedHours: workedHours))
    }
    
    func updateAccountingPeriodLabel(text: String?) {
        self.updateAccountingPeriodLabelParams.append(UpdateAccountingPeriodLabelParams(text: text))
    }
    
    func setActivityIndicator(isAnimating: Bool) {
        self.setActivityIndicatorParams.append(SetActivityIndicatorParams(isAnimating: isAnimating))
    }
    
    func showTableView() {
        self.showTableViewParams.append(ShowTableViewParams())
    }
    
    func showErrorView() {
        self.showErrorViewParams.append(ShowErrorViewParams())
    }
    
    func insertSections(_ sections: IndexSet) {
        self.insertSectionsParams.append(InsertSectionsParams(sections: sections))
    }
    
    func removeSections(_ sections: IndexSet) {
        self.removeSectionsParams.append(RemoveSectionsParams(sections: sections))
    }
    
    func reloadSections(_ sections: IndexSet) {
        self.reloadSectionsParams.append(ReloadSectionsParams(sections: sections))
    }
    
    func performBatchUpdates(_ updates: (() -> Void)?) {
        self.performBatchUpdatesParams.append(PerformBatchUpdatesParams(updates: updates))
    }
    
    func keyboardStateDidChange(to keyboardState: KeyboardManager.KeyboardState) {
        self.keyboardStateDidChangeParams.append(KeyboardStateDidChangeParams(keyboardState: keyboardState))
    }
}

// MARK: - TimesheetViewControllerType
extension TimesheetViewControllerMock: TimesheetViewControllerType {
    func configure(viewModel: TimesheetViewModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
