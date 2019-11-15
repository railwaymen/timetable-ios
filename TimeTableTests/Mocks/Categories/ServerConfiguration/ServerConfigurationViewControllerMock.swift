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
    private(set) var setUpViewParams: [SetUpViewParams] = []
    private(set) var continueButtonEnabledStateParams: [ContinueButtonEnabledStateParams] = []
    private(set) var checkBoxIsActiveStateParams: [CheckBoxIsActiveStateParams] = []
    private(set) var dismissKeyboardParams: [DismissKeyboardParams] = []
    private(set) var setActivityIndicatorParams: [SetActivityIndicatorParams] = []
    private(set) var configureParams: [ConfigureParams] = []
    
    // MARK: - Structures
    struct SetUpViewParams {
        var checkBoxIsActive: Bool
        var serverAddress: String
    }
    
    struct ContinueButtonEnabledStateParams {
        var isEnabled: Bool
    }
    
    struct CheckBoxIsActiveStateParams {
        var isActive: Bool
    }
    
    struct DismissKeyboardParams {}
    
    struct SetActivityIndicatorParams {
        var isHidden: Bool
    }
    
    struct ConfigureParams {
        var viewModel: ServerConfigurationViewModelType
        var notificationCenter: NotificationCenterType
    }
}

// MARK: - ServerConfigurationViewModelOutput
extension ServerConfigurationViewControllerMock: ServerConfigurationViewModelOutput {
    func setUpView(checkBoxIsActive: Bool, serverAddress: String) {
        self.setUpViewParams.append(SetUpViewParams(checkBoxIsActive: checkBoxIsActive, serverAddress: serverAddress))
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
    
    func setActivityIndicator(isHidden: Bool) {
        self.setActivityIndicatorParams.append(SetActivityIndicatorParams(isHidden: isHidden))
    }
}

// MARK: - ServerConfigurationViewControllerType
extension ServerConfigurationViewControllerMock: ServerConfigurationViewControllerType {
    func configure(viewModel: ServerConfigurationViewModelType, notificationCenter: NotificationCenterType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel, notificationCenter: notificationCenter))
    }
}
