//
//  WorkTimeViewControllerMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 16/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

// swiftlint:disable large_tuple
class WorkTimeViewControllerMock: WorkTimeViewControllerable {

    private(set) var configureViewModelData: (called: Bool, viewModel: WorkTimeViewModelType?, notificationCenter: NotificationCenterType?) = (false, nil, nil)
    func configure(viewModel: WorkTimeViewModelType, notificationCenter: NotificationCenterType?) {
        self.configureViewModelData = (true, viewModel, notificationCenter)
    }
    
    private(set) var setUpCurrentProjectName: (isLunch: Bool, allowsTask: Bool, body: String?, urlString: String?)?
    func setUp(isLunch: Bool, allowsTask: Bool, body: String?, urlString: String?) {
        self.setUpCurrentProjectName = (isLunch, allowsTask, body, urlString)
    }

    private(set) var dismissViewCalled = false
    func dismissView() {
        self.dismissViewCalled = true
    }
    
    private(set) var reloadTagsViewCalled = false
    func reloadTagsView() {
        self.reloadTagsViewCalled = true
    }
    
    private(set) var dismissKeyboardCalled = false
    func dismissKeyboard() {
        self.dismissKeyboardCalled = true
    }
    
    private(set) var setMinimumDateForTypeToDateValues: (called: Bool, minDate: Date?) = (false, nil)
    func setMinimumDateForTypeEndAtDate(minDate: Date) {
        self.setMinimumDateForTypeToDateValues = (true, minDate)
    }
    
    private(set) var updateDayValues: (date: Date?, dateString: String?) = (nil, nil)
    func updateDay(with date: Date, dateString: String) {
        self.updateDayValues = (date, dateString)
    }
    
    private(set) var updateStartAtDateValues: (date: Date?, dateString: String?) = (nil, nil)
    func updateStartAtDate(with date: Date, dateString: String) {
        self.updateStartAtDateValues = (date, dateString)
    }
    
    private(set) var updateEndAtDateValues: (date: Date?, dateString: String?) = (nil, nil)
    func updateEndAtDate(with date: Date, dateString: String) {
        self.updateEndAtDateValues = (date, dateString)
    }
    
    private(set) var updateProjectCalledCount = 0
    private(set) var updateProjectName: String?
    func updateProject(name: String) {
        self.updateProjectCalledCount += 1
        self.updateProjectName = name
    }
    
    private(set) var setActivityIndicatorIsHidden: Bool?
    func setActivityIndicator(isHidden: Bool) {
        self.setActivityIndicatorIsHidden = isHidden
    }
}
// swiftlint:enable large_tuple
