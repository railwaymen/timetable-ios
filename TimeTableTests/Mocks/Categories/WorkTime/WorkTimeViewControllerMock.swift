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
    struct SetUpParams {}
    
    private(set) var setBodyViewParams: [SetBodyViewParams] = []
    struct SetBodyViewParams {
        let isHidden: Bool
    }
    
    private(set) var setTaskURLViewParams: [SetTaskURLViewParams] = []
    struct SetTaskURLViewParams {
        let isHidden: Bool
    }
    
    private(set) var setBodyParams: [SetBodyParams] = []
    struct SetBodyParams {
        let text: String
    }
    
    private(set) var setTaskParams: [SetTaskParams] = []
    struct SetTaskParams {
        let urlString: String
    }
    
    private(set) var setSaveWithFillingButtonParams: [SetSaveWithFillingButtonParams] = []
    struct SetSaveWithFillingButtonParams {
        let isHidden: Bool
    }
    
    private(set) var reloadTagsViewParams: [ReloadTagsViewParams] = []
    struct ReloadTagsViewParams {}
    
    private(set) var dismissKeyboardParams: [DismissKeyboardParams] = []
    struct DismissKeyboardParams {}
    
    private(set) var setMinimumDateForTypeEndAtDateParams: [SetMinimumDateForTypeEndAtDateParams] = []
    struct SetMinimumDateForTypeEndAtDateParams {
        let minDate: Date
    }
    
    private(set) var updateDayParams: [UpdateDayParams] = []
    struct UpdateDayParams {
        let date: Date
        let dateString: String
    }
    
    private(set) var updateStartAtDateParams: [UpdateStartAtDateParams] = []
    struct UpdateStartAtDateParams {
        let date: Date
        let dateString: String
    }

    private(set) var updateEndAtDateParams: [UpdateEndAtDateParams] = []
    struct UpdateEndAtDateParams {
        let date: Date
        let dateString: String
    }
    
    private(set) var updateProjectParams: [UpdateProjectParams] = []
    struct UpdateProjectParams {
        let name: String
    }
    
    private(set) var setActivityIndicatorParams: [SetActivityIndicatorParams] = []
    struct SetActivityIndicatorParams {
        let isHidden: Bool
    }
    
    private(set) var setBottomContentInsetParams: [SetBottomContentInsetParams] = []
    struct SetBottomContentInsetParams {
        let height: CGFloat
    }
    
    private(set) var setTagsCollectionViewParams: [SetTagsCollectionViewParams] = []
    struct SetTagsCollectionViewParams {
        let isHidden: Bool
    }
    
    // MARK: - WorkTimeViewControllerType
    private(set) var configureParams: [ConfigureParams] = []
    struct ConfigureParams {
        let viewModel: WorkTimeViewModelType
    }
}

// MARK: - WorkTimeViewModelOutput
extension WorkTimeViewControllerMock: WorkTimeViewModelOutput {
    func setUp() {
        self.setUpParams.append(SetUpParams())
    }
    
    func setBodyView(isHidden: Bool) {
        self.setBodyViewParams.append(SetBodyViewParams(isHidden: isHidden))
    }
    
    func setTaskURLView(isHidden: Bool) {
        self.setTaskURLViewParams.append(SetTaskURLViewParams(isHidden: isHidden))
    }
    
    func setBody(text: String) {
        self.setBodyParams.append(SetBodyParams(text: text))
    }
    
    func setTask(urlString: String) {
        self.setTaskParams.append(SetTaskParams(urlString: urlString))
    }
    
    func setSaveWithFillingButton(isHidden: Bool) {
        self.setSaveWithFillingButtonParams.append(SetSaveWithFillingButtonParams(isHidden: isHidden))
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
