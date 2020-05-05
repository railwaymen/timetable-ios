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
    
    private(set) var setSaveButtonsParams: [SetSaveButtonsParams] = []
    struct SetSaveButtonsParams {
        let isEnabled: Bool
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
        let color: UIColor
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
    
    private(set) var setProjectIsHighlightedParams: [SetProjectIsHighlightedParams] = []
    struct SetProjectIsHighlightedParams {
        let isHighlighted: Bool
    }
    
    private(set) var setDayIsHighlightedParams: [SetDayIsHighlightedParams] = []
    struct SetDayIsHighlightedParams {
        let isHighlighted: Bool
    }
    
    private(set) var setStartsAtIsHighlightedParams: [SetStartsAtIsHighlightedParams] = []
    struct SetStartsAtIsHighlightedParams {
        let isHighlighted: Bool
    }
    
    private(set) var setEndsAtIsHighlightedParams: [SetEndsAtIsHighlightedParams] = []
    struct SetEndsAtIsHighlightedParams {
        let isHighlighted: Bool
    }
    
    private(set) var setBodyIsHighlightedParams: [SetBodyIsHighlightedParams] = []
    struct SetBodyIsHighlightedParams {
        let isHighlighted: Bool
    }
    
    private(set) var setTaskURLIsHighlightedParams: [SetTaskURLIsHighlightedParams] = []
    struct SetTaskURLIsHighlightedParams {
        let isHighlighted: Bool
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
    
    func setSaveButtons(isEnabled: Bool) {
        self.setSaveButtonsParams.append(SetSaveButtonsParams(isEnabled: isEnabled))
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
    
    func updateProject(name: String, color: UIColor) {
        self.updateProjectParams.append(UpdateProjectParams(name: name, color: color))
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
    
    func setProject(isHighlighted: Bool) {
        self.setProjectIsHighlightedParams.append(SetProjectIsHighlightedParams(isHighlighted: isHighlighted))
    }
    
    func setDay(isHighlighted: Bool) {
        self.setDayIsHighlightedParams.append(SetDayIsHighlightedParams(isHighlighted: isHighlighted))
    }
    
    func setStartsAt(isHighlighted: Bool) {
        self.setStartsAtIsHighlightedParams.append(SetStartsAtIsHighlightedParams(isHighlighted: isHighlighted))
    }
    
    func setEndsAt(isHighlighted: Bool) {
        self.setEndsAtIsHighlightedParams.append(SetEndsAtIsHighlightedParams(isHighlighted: isHighlighted))
    }
    
    func setBody(isHighlighted: Bool) {
        self.setBodyIsHighlightedParams.append(SetBodyIsHighlightedParams(isHighlighted: isHighlighted))
    }
    
    func setTaskURL(isHighlighted: Bool) {
        self.setTaskURLIsHighlightedParams.append(SetTaskURLIsHighlightedParams(isHighlighted: isHighlighted))
    }
}

// MARK: - WorkTimeViewControllerType
extension WorkTimeViewControllerMock: WorkTimeViewControllerType {
    func configure(viewModel: WorkTimeViewModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
