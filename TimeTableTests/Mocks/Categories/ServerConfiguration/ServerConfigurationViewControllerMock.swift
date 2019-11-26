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
        var checkBoxIsActive: Bool
        var serverAddress: String
    }
    
    private(set) var continueButtonEnabledStateParams: [ContinueButtonEnabledStateParams] = []
    struct ContinueButtonEnabledStateParams {
        var isEnabled: Bool
    }
    
    private(set) var checkBoxIsActiveStateParams: [CheckBoxIsActiveStateParams] = []
    struct CheckBoxIsActiveStateParams {
        var isActive: Bool
    }
    
    private(set) var dismissKeyboardParams: [DismissKeyboardParams] = []
    struct DismissKeyboardParams {}
    
    private(set) var setActivityIndicatorParams: [SetActivityIndicatorParams] = []
    struct SetActivityIndicatorParams {
        var isHidden: Bool
    }
    
    private(set) var setBottomContentInsetParams: [SetBottomContentInsetParams] = []
    struct SetBottomContentInsetParams {
        var height: CGFloat
    }
    
    // MARK: - ServerConfigurationViewControllerType
    private(set) var configureParams: [ConfigureParams] = []
    struct ConfigureParams {
        var viewModel: ServerConfigurationViewModelType
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
    
    func setBottomContentInset(_ height: CGFloat) {
        self.setBottomContentInsetParams.append(SetBottomContentInsetParams(height: height))
    }
}

// MARK: - ServerConfigurationViewControllerType
extension ServerConfigurationViewControllerMock: ServerConfigurationViewControllerType {
    func configure(viewModel: ServerConfigurationViewModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
