//
//  WorkTimeViewControllerMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 16/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class WorkTimeViewControllerMock: WorkTimeViewControlleralbe {
    private(set) var configureViewModelData: (called: Bool, viewModel: WorkTimeViewModelType?) = (false, nil)
    private(set) var setUpCurrentProjectName: (currentProjectName: String?, allowsTask: Bool?) = (nil, nil)
    private(set) var dismissViewCalled = false
    private(set) var reloadProjectPickerCalled = false
    private(set) var dissmissKeyboardCalled = false
    private(set) var setMinimumDateForTypeToDateValues: (called: Bool, minDate: Date?) = (false, nil)
    private(set) var updateFromDateValues: (date: Date?, dateString: String?) = (nil, nil)
    private(set) var updateToDateValues: (date: Date?, dateString: String?) = (nil, nil)
    private(set) var updateTimeLabelValues: (called: Bool, title: String?) = (false, nil)
    
    func configure(viewModel: WorkTimeViewModelType) {
        configureViewModelData = (true, viewModel)
    }
    
    func setUp(currentProjectName: String, allowsTask: Bool) {
        setUpCurrentProjectName = (currentProjectName, allowsTask)
    }
    
    func dismissView() {
        dismissViewCalled = true
    }
    
    func reloadProjectPicker() {
        reloadProjectPickerCalled = true
    }
    
    func dissmissKeyboard() {
        dissmissKeyboardCalled = true
    }
    
    func setMinimumDateForTypeToDate(minDate: Date) {
        setMinimumDateForTypeToDateValues = (true, minDate)
    }
    
    func updateFromDate(withDate date: Date, dateString: String) {
        updateFromDateValues = (date, dateString)
    }
    
    func updateToDate(withDate date: Date, dateString: String) {
        updateToDateValues = (date, dateString)
    }
    
    func updateTimeLabel(withTitle title: String?) {
        updateTimeLabelValues = (true, title)
    }
}
