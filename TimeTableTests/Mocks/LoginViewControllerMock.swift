//
//  LoginViewControllerMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit
@testable import TimeTable

class LoginViewControllerMock: LoginViewControllerable {
    private(set) var setUpViewCalledData: (called: Bool, isActive: Bool?) = (false, nil)
    private(set) var updateLoginFieldsCalled = false
    private(set) var updateLoginFieldsData: (email: String?, password: String?)
    private(set) var passwordInputEnabledStateValues: (called: Bool, isEnabled: Bool?) = (false, nil)
    private(set) var loginButtonEnabledStateValues: (called: Bool, isEnabled: Bool?) = (false, nil)
    private(set) var checkBoxIsActiveStateValues: (called: Bool, isActive: Bool?) = (false, nil)
    private(set) var focusOnPasswordTextFieldCalled = false
    private(set) var dismissKeyboardCalled = false
    private(set) var setActivityIndicatorIsHidden: Bool?
    
    // MARK: - LoginViewModelOutput
    func setUpView(checkBoxIsActive: Bool) {
        self.setUpViewCalledData = (true, checkBoxIsActive)
    }
    
    func updateLoginFields(email: String, password: String) {
        self.updateLoginFieldsCalled = true
        self.updateLoginFieldsData = (email, password)
    }
    
    func passwordInputEnabledState(_ isEnabled: Bool) {
        self.passwordInputEnabledStateValues = (true, isEnabled)
    }
    
    func loginButtonEnabledState(_ isEnabled: Bool) {
        self.loginButtonEnabledStateValues = (true, isEnabled)
    }
    
    func checkBoxIsActiveState(_ isActive: Bool) {
        self.checkBoxIsActiveStateValues = (true, isActive)
    }
    
    func focusOnPasswordTextField() {
        self.focusOnPasswordTextFieldCalled = true
    }
    
    func dismissKeyboard() {
        self.dismissKeyboardCalled = true
    }
    
    func setActivityIndicator(isHidden: Bool) {
        self.setActivityIndicatorIsHidden = isHidden
    }
    
    // MARK: - LoginViewControllerType
    private(set) var configureNotificationCenter: NotificationCenterType?
    private(set) var configureViewModel: LoginViewModelType?
    func configure(notificationCenter: NotificationCenterType, viewModel: LoginViewModelType) {
        self.configureNotificationCenter = notificationCenter
        self.configureViewModel = viewModel
    }
}
