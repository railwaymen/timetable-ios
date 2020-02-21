//
//  WorkTimesListViewControllerMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 27/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class WorkTimesListViewControllerMock: UIViewController {
    
    // MARK: - WorkTimesListViewModelOutput
    private(set) var setUpViewParams: [SetUpViewParams] = []
    struct SetUpViewParams {}
    
    private(set) var updateViewParams: [UpdateViewParams] = []
    struct UpdateViewParams {}
    
    private(set) var updateDateSelectorParams: [UpdateDateSelectorParams] = []
    struct UpdateDateSelectorParams {
        var currentDateString: String
        var previousDateString: String
        var nextDateString: String
    }
    
    private(set) var updateMatchingFullTimeLabelsParams: [UpdateMatchingFullTimeLabelsParams] = []
    struct UpdateMatchingFullTimeLabelsParams {
        var workedHours: String
        var shouldWorkHours: String
        var duration: String
    }
    
    private(set) var setActivityIndicatorParams: [SetActivityIndicatorParams] = []
    struct SetActivityIndicatorParams {
        var isHidden: Bool
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
    
    private(set) var insertRowsParams: [InsertRowsParams] = []
    struct InsertRowsParams {
        let indexPaths: [IndexPath]
    }
    
    private(set) var removeRowsParams: [RemoveRowsParams] = []
    struct RemoveRowsParams {
        let indexPaths: [IndexPath]
    }
    
    private(set) var performBatchUpdatesParams: [PerformBatchUpdatesParams] = []
    struct PerformBatchUpdatesParams {
        var updates: (() -> Void)?
    }
    
    // MARK: - WorkTimesListViewControllerType
    private(set) var configureParams: [ConfigureParams] = []
    struct ConfigureParams {
        var viewModel: WorkTimesListViewModelType
    }
}

// MARK: - WorkTimesListViewModelOutput
extension WorkTimesListViewControllerMock: WorkTimesListViewModelOutput {
    func setUpView() {
        self.setUpViewParams.append(SetUpViewParams())
    }
    
    func reloadData() {
        self.updateViewParams.append(UpdateViewParams())
    }
    
    func updateDateSelector(currentDateString: String, previousDateString: String, nextDateString: String) {
        self.updateDateSelectorParams.append(
            UpdateDateSelectorParams(
            currentDateString: currentDateString,
            previousDateString: previousDateString,
            nextDateString: nextDateString))
    }
    
    func updateMatchingFullTimeLabels(workedHours: String, shouldWorkHours: String, duration: String) {
        self.updateMatchingFullTimeLabelsParams.append(
            UpdateMatchingFullTimeLabelsParams(
                workedHours: workedHours,
                shouldWorkHours: shouldWorkHours,
                duration: duration))
    }
    
    func setActivityIndicator(isHidden: Bool) {
        self.setActivityIndicatorParams.append(SetActivityIndicatorParams(isHidden: isHidden))
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
    
    func insertRows(at indexPaths: [IndexPath]) {
        self.insertRowsParams.append(InsertRowsParams(indexPaths: indexPaths))
    }
    
    func removeRows(at indexPaths: [IndexPath]) {
        self.removeRowsParams.append(RemoveRowsParams(indexPaths: indexPaths))
    }
    
    func performBatchUpdates(_ updates: (() -> Void)?) {
        self.performBatchUpdatesParams.append(PerformBatchUpdatesParams(updates: updates))
    }
}

// MARK: - WorkTimesListViewControllerType
extension WorkTimesListViewControllerMock: WorkTimesListViewControllerType {
    func configure(viewModel: WorkTimesListViewModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
