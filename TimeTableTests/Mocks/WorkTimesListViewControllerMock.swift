//
//  WorkTimesListViewControllerMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 27/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

// swiftlint:disable large_tuple
class WorkTimesListViewControllerMock: WorkTimesListViewControllerable {
    
    private(set) var setUpViewCalled = false
    private(set) var updateViewCalled = false
    private(set) var deleteWorkTimeIndexPath: IndexPath?
    private(set) var reloadWorkTimeIndexPath: IndexPath?
    private(set) var updateDateSelectorData: (currentDateString: String?, previousDateString: String?, nextDateString: String?) = (nil, nil, nil)
    private(set) var configureViewModelData: (called: Bool, viewModel: WorkTimesListViewModelType?) = (false, nil)
    private(set) var updateMatchingFullTimeLabelsData: (workedHours: String?, shouldWorkHours: String?, duration: String?) = (nil, nil, nil)
    private(set) var setActivityIndicatorIsHidden: Bool?
    private(set) var showTableViewCalled = false
    private(set) var showErrorViewCalled = false
    
    func setUpView() {
        setUpViewCalled = true
    }
    
    func updateView() {
        updateViewCalled = true
    }
    
    func updateDateSelector(currentDateString: String, previousDateString: String, nextDateString: String) {
        updateDateSelectorData = (currentDateString, previousDateString, nextDateString)
    }
    
    func deleteWorkTime(at indexPath: IndexPath) {
        self.deleteWorkTimeIndexPath = indexPath
    }
    
    func reloadWorkTime(at indexPath: IndexPath) {
        self.reloadWorkTimeIndexPath = indexPath
    }
 
    func configure(viewModel: WorkTimesListViewModelType) {
        configureViewModelData = (true, viewModel)
    }
    
    func updateMatchingFullTimeLabels(workedHours: String, shouldWorkHours: String, duration: String) {
        updateMatchingFullTimeLabelsData = (workedHours, shouldWorkHours, duration)
    }
    
    func setActivityIndicator(isHidden: Bool) {
        setActivityIndicatorIsHidden = isHidden
    }
    
    func showTableView() {
        showTableViewCalled = true
    }
    
    func showErrorView() {
        showErrorViewCalled = true
    }
}
// swiftlint:enable large_tuple
