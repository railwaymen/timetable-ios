//
//  WorkTimesViewControllerMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 27/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

// swiftlint:disable large_tuple
class WorkTimesViewControllerMock: WorkTimesViewControlleralbe {
    
    private(set) var setUpViewCalled = false
    private(set) var updateViewCalled = false
    private(set) var updateDateSelectorData: (currentDateString: String?, previousDateString: String?, nextDateString: String?) = (nil, nil, nil)
    private(set) var configureViewModelData: (called: Bool, viewModel: WorkTimesViewModelType?) = (false, nil)
    private(set) var updateMatchingFullTimeLabelsData: (workedHours: String?, shouldWorkHours: String?, duration: String?) = (nil, nil, nil)
    
    func setUpView() {
        setUpViewCalled = true
    }
    
    func updateView() {
        updateViewCalled = true
    }
    
    func updateDateSelector(currentDateString: String, previousDateString: String, nextDateString: String) {
        updateDateSelectorData = (currentDateString, previousDateString, nextDateString)
    }
 
    func configure(viewModel: WorkTimesViewModelType) {
        configureViewModelData = (true, viewModel)
    }
    
    func updateMatchingFullTimeLabels(workedHours: String, shouldWorkHours: String, duration: String) {
        updateMatchingFullTimeLabelsData = (workedHours, shouldWorkHours, duration)
    }
}
// swiftlint:enable large_tuple
