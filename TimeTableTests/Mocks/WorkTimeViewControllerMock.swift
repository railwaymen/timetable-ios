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
    private(set) var configureViewModelData: (called: Bool, viewModel: WorkTimeViewModelType?, notificationCenter: NotificationCenterType?) = (false, nil, nil)
    private(set) var setUpCurrentProjectName: (currentProjectName: String?, allowsTask: Bool?) = (nil, nil)
    private(set) var dismissViewCalled = false
    private(set) var reloadProjectPickerCalled = false
    private(set) var dissmissKeyboardCalled = false
    private(set) var setMinimumDateForTypeToDateValues: (called: Bool, minDate: Date?) = (false, nil)
    private(set) var updateDayValues: (date: Date?, dateString: String?) = (nil, nil)
    private(set) var updateStartAtDateValues: (date: Date?, dateString: String?) = (nil, nil)
    private(set) var updateEndAtDateValues: (date: Date?, dateString: String?) = (nil, nil)

    func configure(viewModel: WorkTimeViewModelType, notificationCenter: NotificationCenterType?) {
        configureViewModelData = (true, viewModel, notificationCenter)
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
    
    func setMinimumDateForTypeEndAtDate(minDate: Date) {
        setMinimumDateForTypeToDateValues = (true, minDate)
    }
    
    func updateDay(with date: Date, dateString: String) {
        updateDayValues = (date, dateString)
    }
    
    func updateStartAtDate(with date: Date, dateString: String) {
        updateStartAtDateValues = (date, dateString)
    }
    
    func updateEndAtDate(with date: Date, dateString: String) {
        updateEndAtDateValues = (date, dateString)
    }
}
