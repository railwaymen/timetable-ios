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
    
    // MARK: - WorkTimeViewModelOutput
    private(set) var setUpParams: [SetUpParams] = []
    struct SetUpParams {
        var isLunch: Bool
        var allowsTask: Bool
        var body: String?
        var urlString: String?
    }
    
    private(set) var dismissViewParams: [DismissViewParams] = []
    struct DismissViewParams {}
    
    private(set) var reloadTagsViewParams: [ReloadTagsViewParams] = []
    struct ReloadTagsViewParams {}
    
    private(set) var dismissKeyboardParams: [DismissKeyboardParams] = []
    struct DismissKeyboardParams {}
    
    private(set) var setMinimumDateForTypeEndAtDateParams: [SetMinimumDateForTypeEndAtDateParams] = []
    struct SetMinimumDateForTypeEndAtDateParams {
        var minDate: Date
    }
    
    private(set) var updateDayParams: [UpdateDayParams] = []
    struct UpdateDayParams {
        var date: Date
        var dateString: String
    }
    
    private(set) var updateStartAtDateParams: [UpdateStartAtDateParams] = []
    struct UpdateStartAtDateParams {
        var date: Date
        var dateString: String
    }

    private(set) var updateEndAtDateParams: [UpdateEndAtDateParams] = []
    struct UpdateEndAtDateParams {
        var date: Date
        var dateString: String
    }
    
    private(set) var updateProjectParams: [UpdateProjectParams] = []
    struct UpdateProjectParams {
        var name: String
    }
    
    private(set) var setActivityIndicatorParams: [SetActivityIndicatorParams] = []
    struct SetActivityIndicatorParams {
        var isHidden: Bool
    }
    
    private(set) var setBottomContentInsetParams: [SetBottomContentInsetParams] = []
    struct SetBottomContentInsetParams {
        var height: CGFloat
    }
    
    private(set) var setTagsCollectionViewParams: [SetTagsCollectionViewParams] = []
    struct SetTagsCollectionViewParams {
        var isHidden: Bool
    }
    
    // MARK: - WorkTimeViewControllerType
    private(set) var configureParams: [ConfigureParams] = []
    struct ConfigureParams {
        var viewModel: WorkTimeViewModelType
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
    
    func setBottomContentInset(_ height: CGFloat) {
        self.setBottomContentInsetParams.append(SetBottomContentInsetParams(height: height))
    }
    
    func setTagsCollectionView(isHidden: Bool) {
        self.setTagsCollectionViewParams.append(SetTagsCollectionViewParams(isHidden: isHidden))
    }
}

// MARK: - WorkTimeViewControllerType
extension WorkTimeViewControllerMock: WorkTimeViewControllerType {
    func configure(viewModel: WorkTimeViewModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
