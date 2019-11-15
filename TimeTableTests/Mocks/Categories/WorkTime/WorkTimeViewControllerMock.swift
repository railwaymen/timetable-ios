//
//  WorkTimeViewControllerMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 16/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class WorkTimeViewControllerMock: UIViewController {
    private(set) var setUpParams: [SetUpParams] = []
    private(set) var dismissViewParams: [DismissViewParams] = []
    private(set) var reloadTagsViewParams: [ReloadTagsViewParams] = []
    private(set) var dismissKeyboardParams: [DismissKeyboardParams] = []
    private(set) var setMinimumDateForTypeEndAtDateParams: [SetMinimumDateForTypeEndAtDateParams] = []
    private(set) var updateDayParams: [UpdateDayParams] = []
    private(set) var updateStartAtDateParams: [UpdateStartAtDateParams] = []
    private(set) var updateEndAtDateParams: [UpdateEndAtDateParams] = []
    private(set) var updateProjectParams: [UpdateProjectParams] = []
    private(set) var setActivityIndicatorParams: [SetActivityIndicatorParams] = []
    private(set) var configureParams: [ConfigureParams] = []
    
    // MARK: - Structures
    struct SetUpParams {
        var isLunch: Bool
        var allowsTask: Bool
        var body: String?
        var urlString: String?
    }
    
    struct DismissViewParams {}
    
    struct ReloadTagsViewParams {}
    
    struct DismissKeyboardParams {}
    
    struct SetMinimumDateForTypeEndAtDateParams {
        var minDate: Date
    }
    
    struct UpdateDayParams {
        var date: Date
        var dateString: String
    }
    
    struct UpdateStartAtDateParams {
        var date: Date
        var dateString: String
    }

    struct UpdateEndAtDateParams {
        var date: Date
        var dateString: String
    }
    
    struct UpdateProjectParams {
        var name: String
    }
    
    struct SetActivityIndicatorParams {
        var isHidden: Bool
    }
    
    struct ConfigureParams {
        var viewModel: WorkTimeViewModelType
        var notificationCenter: NotificationCenterType?
    }
}

// MARK: - WorkTimeViewModelOutput
extension WorkTimeViewControllerMock: WorkTimeViewModelOutput {
    func setUp(isLunch: Bool, allowsTask: Bool, body: String?, urlString: String?) {
        self.setUpParams.append(SetUpParams(isLunch: isLunch, allowsTask: allowsTask, body: body, urlString: urlString))
    }
    
    func dismissView() {
        self.dismissViewParams.append(DismissViewParams())
    }
    
    func reloadTagsView() {
        self.reloadTagsViewParams.append(ReloadTagsViewParams())
    }
    
    func dismissKeyboard() {
        self.dismissKeyboardParams.append(DismissKeyboardParams())
    }
    
    func setMinimumDateForTypeEndAtDate(minDate: Date) {
        self.setMinimumDateForTypeEndAtDateParams.append(SetMinimumDateForTypeEndAtDateParams(minDate: minDate))
    }
    
    func updateDay(with date: Date, dateString: String) {
        self.updateDayParams.append(UpdateDayParams(date: date, dateString: dateString))
    }
    
    func updateStartAtDate(with date: Date, dateString: String) {
        self.updateStartAtDateParams.append(UpdateStartAtDateParams(date: date, dateString: dateString))
    }
    
    func updateEndAtDate(with date: Date, dateString: String) {
        self.updateEndAtDateParams.append(UpdateEndAtDateParams(date: date, dateString: dateString))
    }
    
    func updateProject(name: String) {
        self.updateProjectParams.append(UpdateProjectParams(name: name))
    }
    
    func setActivityIndicator(isHidden: Bool) {
        self.setActivityIndicatorParams.append(SetActivityIndicatorParams(isHidden: isHidden))
    }
}

// MARK: - WorkTimeViewControllerType
extension WorkTimeViewControllerMock: WorkTimeViewControllerType {
    func configure(viewModel: WorkTimeViewModelType, notificationCenter: NotificationCenterType?) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel, notificationCenter: notificationCenter))
    }
}
