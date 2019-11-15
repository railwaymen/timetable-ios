//
//  LoginViewControllerMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class LoginViewControllerMock: UIViewController {
    private(set) var setUpViewParams: [SetUpViewParams] = []
    private(set) var updateLoginFieldsParams: [UpdateLoginFieldsParams] = []
    private(set) var passwordInputEnabledStateParams: [PasswordInputEnabledStateParams] = []
    private(set) var loginButtonEnabledStateParams: [LoginButtonEnabledStateParams] = []
    private(set) var focusOnPasswordTextFieldParams: [FocusOnPasswordTextFieldParams] = []
    private(set) var checkBoxIsActiveStateParams: [CheckBoxIsActiveStateParams] = []
    private(set) var dismissKeyboardParams: [DismissKeyboardParams] = []
    private(set) var setActivityIndicatorParams: [SetActivityIndicatorParams] = []
    private(set) var configureParams: [ConfigureParams] = []
    
    // MARK: - Structures
    struct SetUpViewParams {
        var checkBoxIsActive: Bool
    }
    
    struct UpdateLoginFieldsParams {
        var email: String
        var password: String
    }
    
    struct PasswordInputEnabledStateParams {
        var isEnabled: Bool
    }
    
    struct LoginButtonEnabledStateParams {
        var isEnabled: Bool
    }
    
    struct FocusOnPasswordTextFieldParams {}
    
    struct CheckBoxIsActiveStateParams {
        var isActive: Bool
    }
    
    struct DismissKeyboardParams {}
    
    struct SetActivityIndicatorParams {
        var isHidden: Bool
    }
    
    struct ConfigureParams {
        var notificationCenter: NotificationCenterType
        var viewModel: LoginViewModelType
    }
}

// MARK: - LoginViewModelOutput
extension LoginViewControllerMock: LoginViewModelOutput {
    func setUpView(checkBoxIsActive: Bool) {
        self.setUpViewParams.append(SetUpViewParams(checkBoxIsActive: checkBoxIsActive))
    }
    
    func updateLoginFields(email: String, password: String) {
        self.updateLoginFieldsParams.append(UpdateLoginFieldsParams(email: email, password: password))
    }
    
    func passwordInputEnabledState(_ isEnabled: Bool) {
        self.passwordInputEnabledStateParams.append(PasswordInputEnabledStateParams(isEnabled: isEnabled))
    }
    
    func loginButtonEnabledState(_ isEnabled: Bool) {
        self.loginButtonEnabledStateParams.append(LoginButtonEnabledStateParams(isEnabled: isEnabled))
    }
    
    func focusOnPasswordTextField() {
        self.focusOnPasswordTextFieldParams.append(FocusOnPasswordTextFieldParams())
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

// MARK: - LoginViewControllerType
extension LoginViewControllerMock: LoginViewControllerType {
    func configure(notificationCenter: NotificationCenterType, viewModel: LoginViewModelType) {
        self.configureParams.append(ConfigureParams(notificationCenter: notificationCenter, viewModel: viewModel))
    }
}
