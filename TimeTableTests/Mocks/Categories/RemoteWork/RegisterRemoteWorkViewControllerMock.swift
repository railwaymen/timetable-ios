//
//  RegisterRemoteWorkViewControllerMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 06/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class RegisterRemoteWorkViewControllerMock: UIViewController {
    
    // MARK: - RegisterRemoteWorkViewModelOutput
    private(set) var setUpParams: [SetUpParams] = []
    struct SetUpParams {}
    
    private(set) var setActivityIndicatorParams: [SetActivityIndicatorParams] = []
    struct SetActivityIndicatorParams {
        let isHidden: Bool
    }
    
    private(set) var setNoteParams: [SetNoteParams] = []
    struct SetNoteParams {
        let text: String
    }
    
    private(set) var setMinimumDateForStartDateParams: [SetMinimumDateForStartDateParams] = []
    struct SetMinimumDateForStartDateParams {
        let minDate: Date
    }
    
    private(set) var setMinimumDateForEndDateParams: [SetMinimumDateForEndDateParams] = []
    struct SetMinimumDateForEndDateParams {
        let minDate: Date
    }
    
    private(set) var updateStartDateParams: [UpdateStartDateParams] = []
    struct UpdateStartDateParams {
        let date: Date
        let dateString: String
    }
    
    private(set) var updateEndDateParams: [UpdateEndDateParams] = []
    struct UpdateEndDateParams {
        let date: Date
        let dateString: String
    }
    
    private(set) var setBottomContentInsetParams: [SetBottomContentInsetParams] = []
    struct SetBottomContentInsetParams {
        let height: CGFloat
    }
    
    private(set) var dismissKeyboardParams: [DismissKeyboardParams] = []
    struct DismissKeyboardParams {}
    
    // MARK: - RegisterRemoteWorkViewControllerType
    private(set) var configureParams: [ConfigureParams] = []
    struct ConfigureParams {
        let viewModel: RegisterRemoteWorkViewModelType
    }
}

// MARK: - RegisterRemoteWorkViewModelOutput
extension RegisterRemoteWorkViewControllerMock: RegisterRemoteWorkViewModelOutput {
    func setUp() {
        self.setUpParams.append(SetUpParams())
    }
    
    func setActivityIndicator(isHidden: Bool) {
        self.setActivityIndicatorParams.append(SetActivityIndicatorParams(isHidden: isHidden))
    }
    
    func setNote(text: String) {
        self.setNoteParams.append(SetNoteParams(text: text))
    }
    
    func setMinimumDateForStartDate(minDate: Date) {
        self.setMinimumDateForStartDateParams.append(SetMinimumDateForStartDateParams(minDate: minDate))
    }
    
    func setMinimumDateForEndDate(minDate: Date) {
        self.setMinimumDateForEndDateParams.append(SetMinimumDateForEndDateParams(minDate: minDate))
    }

    func updateStartDate(with date: Date, dateString: String) {
        self.updateStartDateParams.append(UpdateStartDateParams(date: date, dateString: dateString))
    }

    func updateEndDate(with date: Date, dateString: String) {
        self.updateEndDateParams.append(UpdateEndDateParams(date: date, dateString: dateString))
    }
    
    func setBottomContentInset(_ height: CGFloat) {
        self.setBottomContentInsetParams.append(SetBottomContentInsetParams(height: height))
    }
    
    func dismissKeyboard() {
        self.dismissKeyboardParams.append(DismissKeyboardParams())
    }
}

// MARK: - RegisterRemoteWorkViewControllerType
extension RegisterRemoteWorkViewControllerMock: RegisterRemoteWorkViewControllerType {
    func configure(viewModel: RegisterRemoteWorkViewModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
