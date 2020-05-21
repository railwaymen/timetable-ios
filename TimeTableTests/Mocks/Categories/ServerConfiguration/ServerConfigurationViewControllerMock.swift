//
//  ServerConfigurationViewControllerMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ServerConfigurationViewControllerMock: UIViewController {
    
    // MARK: - ServerConfigurationViewModelOutput
    private(set) var setUpViewParams: [SetUpViewParams] = []
    struct SetUpViewParams {
        let serverAddress: String
    }
    
    private(set) var continueButtonEnabledStateParams: [ContinueButtonEnabledStateParams] = []
    struct ContinueButtonEnabledStateParams {
        let isEnabled: Bool
    }
    
    private(set) var checkBoxIsActiveStateParams: [CheckBoxIsActiveStateParams] = []
    struct CheckBoxIsActiveStateParams {
        let isActive: Bool
    }
    
    private(set) var dismissKeyboardParams: [DismissKeyboardParams] = []
    struct DismissKeyboardParams {}
    
    private(set) var setActivityIndicatorParams: [SetActivityIndicatorParams] = []
    struct SetActivityIndicatorParams {
        let isAnimating: Bool
    }
    
    private(set) var keyboardStateDidChangeParams: [KeyboardStateDidChangeParams] = []
    struct KeyboardStateDidChangeParams {
        let keyboardState: KeyboardManager.KeyboardState
    }
    
    private(set) var updateColorsParams: [UpdateColorsParams] = []
    struct UpdateColorsParams {}
    
    // MARK: - ServerConfigurationViewControllerType
    private(set) var configureParams: [ConfigureParams] = []
    struct ConfigureParams {
        let viewModel: ServerConfigurationViewModelType
    }
}

// MARK: - ServerConfigurationViewModelOutput
extension ServerConfigurationViewControllerMock: ServerConfigurationViewModelOutput {
    func setUpView(serverAddress: String) {
        self.setUpViewParams.append(SetUpViewParams(serverAddress: serverAddress))
    }
    
    func continueButtonEnabledState(_ isEnabled: Bool) {
        self.continueButtonEnabledStateParams.append(ContinueButtonEnabledStateParams(isEnabled: isEnabled))
    }
    
    func checkBoxIsActiveState(_ isActive: Bool) {
        self.checkBoxIsActiveStateParams.append(CheckBoxIsActiveStateParams(isActive: isActive))
    }
    
    func dismissKeyboard() {
        self.dismissKeyboardParams.append(DismissKeyboardParams())
    }
    
    func setActivityIndicator(isAnimating: Bool) {
        self.setActivityIndicatorParams.append(SetActivityIndicatorParams(isAnimating: isAnimating))
    }
    
    func keyboardStateDidChange(to keyboardState: KeyboardManager.KeyboardState) {
        self.keyboardStateDidChangeParams.append(KeyboardStateDidChangeParams(keyboardState: keyboardState))
    }
    
    func updateColors() {
        self.updateColorsParams.append(UpdateColorsParams())
    }
}

// MARK: - ServerConfigurationViewControllerType
extension ServerConfigurationViewControllerMock: ServerConfigurationViewControllerType {
    func configure(viewModel: ServerConfigurationViewModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
