//
//  NewVacationViewControllerMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 30/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class NewVacationViewControllerMock: UIViewController {
    
    // MARK: - NewVacationViewModelOutput
    private(set) var setUpParams: [SetUpParams] = []
    struct SetUpParams {
        let availableVacationDays: String
    }
    
    private(set) var updateColorsParams: [UpdateColorsParams] = []
    struct UpdateColorsParams {}
    
    private(set) var setActivityIndicatorParams: [SetActivityIndicatorParams] = []
    struct SetActivityIndicatorParams {
        let isAnimating: Bool
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
    
    private(set) var updateEndDateParmas: [UpdateEndDateParmas] = []
    struct UpdateEndDateParmas {
        let date: Date
        let dateString: String
    }
    
    private(set) var updateTypeParams: [UpdateTypeParams] = []
    struct UpdateTypeParams {
        let name: String
    }
    
    private(set) var setSaveButtonParams: [SetSaveButtonParams] = []
    struct SetSaveButtonParams {
        let isEnabled: Bool
    }
    
    private(set) var keyboardStateDidChangeParams: [KeyboardStateDidChangeParams] = []
    struct KeyboardStateDidChangeParams {
        let keyboardState: KeyboardManager.KeyboardState
    }
    
    private(set) var setNoteHighlightedParams: [SetNoteHighlightedParams] = []
    struct SetNoteHighlightedParams {
        let isHighlighted: Bool
    }
    
    private(set) var setOptionalLabelParams: [SetOptionalLabelParams] = []
    struct SetOptionalLabelParams {
        let isHidden: Bool
    }
    
    private(set) var dismissKeyboardParams: [DismissKeyboardParams] = []
    struct DismissKeyboardParams {}
   
    // MARK: - NewVacationViewControllerType
    private(set) var configureParams: [ConfigureParams] = []
    struct ConfigureParams {
        var viewModel: NewVacationViewModelType
    }
}

// MARK: - NewVacationViewModelOutput
extension NewVacationViewControllerMock: NewVacationViewModelOutput {
    func setUp(availableVacationDays: String) {
        self.setUpParams.append(SetUpParams(availableVacationDays: availableVacationDays))
    }
    
    func updateColors() {
        self.updateColorsParams.append(UpdateColorsParams())
    }
    
    func setActivityIndicator(isAnimating: Bool) {
        self.setActivityIndicatorParams.append(SetActivityIndicatorParams(isAnimating: isAnimating))
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
        self.updateEndDateParmas.append(UpdateEndDateParmas(date: date, dateString: dateString))
    }
    
    func updateType(name: String) {
        self.updateTypeParams.append(UpdateTypeParams(name: name))
    }

    func setSaveButton(isEnabled: Bool) {
        self.setSaveButtonParams.append(SetSaveButtonParams(isEnabled: isEnabled))
    }
    
    func keyboardStateDidChange(to keyboardState: KeyboardManager.KeyboardState) {
        self.keyboardStateDidChangeParams.append(KeyboardStateDidChangeParams(keyboardState: keyboardState))
    }

    func setNote(isHighlighted: Bool) {
        self.setNoteHighlightedParams.append(SetNoteHighlightedParams(isHighlighted: isHighlighted))
    }

    func setOptionalLabel(isHidden: Bool) {
        self.setOptionalLabelParams.append(SetOptionalLabelParams(isHidden: isHidden))
    }
    
    func dismissKeyboard() {
        self.dismissKeyboardParams.append(DismissKeyboardParams())
    }
}

// MARK: - NewVacationViewControllerType
extension NewVacationViewControllerMock: NewVacationViewControllerType {
    func configure(viewModel: NewVacationViewModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
