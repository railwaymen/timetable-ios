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
    
    // MARK: - LoginViewModelOutput
    private(set) var setUpViewParams: [SetUpViewParams] = []
    struct SetUpViewParams {
        var checkBoxIsActive: Bool
    }
    
    private(set) var updateLoginFieldsParams: [UpdateLoginFieldsParams] = []
    struct UpdateLoginFieldsParams {
        var email: String
        var password: String
    }
    
    private(set) var loginButtonEnabledStateParams: [LoginButtonEnabledStateParams] = []
    struct LoginButtonEnabledStateParams {
        var isEnabled: Bool
    }
    
    private(set) var focusOnPasswordTextFieldParams: [FocusOnPasswordTextFieldParams] = []
    struct FocusOnPasswordTextFieldParams {}
    
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
    
    // MARK: - LoginViewControllerType
    private(set) var configureParams: [ConfigureParams] = []
    struct ConfigureParams {
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
    
    func setBottomContentInset(_ height: CGFloat) {
        self.setBottomContentInsetParams.append(SetBottomContentInsetParams(height: height))
    }
}

// MARK: - LoginViewControllerType
extension LoginViewControllerMock: LoginViewControllerType {
    func configure(viewModel: LoginViewModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
