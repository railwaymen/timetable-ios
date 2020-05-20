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
    
    private(set) var updateColorsParams: [UpdateColorsParams] = []
    struct UpdateColorsParams {}
    
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
    
    private(set) var keyboardStateDidChangeParams: [KeyboardStateDidChangeParams] = []
    struct KeyboardStateDidChangeParams {
        let keyboardState: KeyboardManager.KeyboardState
    }
    
    private(set) var dismissKeyboardParams: [DismissKeyboardParams] = []
    struct DismissKeyboardParams {}
    
    private(set) var setSaveButtonParams: [SetSaveButtonParams] = []
    struct SetSaveButtonParams {
        let isEnabled: Bool
    }
    
    private(set) var setStartsAtParams: [SetStartsAtParams] = []
    struct SetStartsAtParams {
        let isHighlighted: Bool
    }
    
    private(set) var setEndsAtParams: [SetEndsAtParams] = []
    struct SetEndsAtParams {
        let isHighlighted: Bool
    }
    
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
    
    func updateColors() {
        self.updateColorsParams.append(UpdateColorsParams())
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
    
    func keyboardStateDidChange(to keyboardState: KeyboardManager.KeyboardState) {
        self.keyboardStateDidChangeParams.append(KeyboardStateDidChangeParams(keyboardState: keyboardState))
    }
    
    func dismissKeyboard() {
        self.dismissKeyboardParams.append(DismissKeyboardParams())
    }
    
    func setSaveButton(isEnabled: Bool) {
        self.setSaveButtonParams.append(SetSaveButtonParams(isEnabled: isEnabled))
    }
    
    func setStartsAt(isHighlighted: Bool) {
        self.setStartsAtParams.append(SetStartsAtParams(isHighlighted: isHighlighted))
    }
    
    func setEndsAt(isHighlighted: Bool) {
        self.setEndsAtParams.append(SetEndsAtParams(isHighlighted: isHighlighted))
    }
}

// MARK: - RegisterRemoteWorkViewControllerType
extension RegisterRemoteWorkViewControllerMock: RegisterRemoteWorkViewControllerType {
    func configure(viewModel: RegisterRemoteWorkViewModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
