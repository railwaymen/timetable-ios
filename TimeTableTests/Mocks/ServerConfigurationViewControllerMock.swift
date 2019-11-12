//
//  ServerConfigurationViewControllerMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class ServerConfigurationViewControllerMock: ServerConfigurationViewControllerable {

    private(set) var setupViewCalled = false
    private(set) var setupViewStateValues: (checkBoxIsActive: Bool, serverAddress: String) = (false, "")
    private(set) var dismissKeyboardCalled = false
    private(set) var continueButtonEnabledStateValues: (called: Bool, isEnabled: Bool) = (false, false)
    private(set) var checkBoxIsActiveStateValues: (called: Bool, isActive: Bool) = (false, false)
    private(set) var setActivityIndicatorIsHidden: Bool?
    
    // MARK: - ServerConfigurationViewModelOutput
    func setupView(checkBoxIsActive: Bool, serverAddress: String) {
        self.setupViewCalled = true
        self.setupViewStateValues = (checkBoxIsActive, serverAddress)
    }
    
    func dismissKeyboard() {
        self.dismissKeyboardCalled = true
    }
    
    func continueButtonEnabledState(_ isEnabled: Bool) {
        self.continueButtonEnabledStateValues = (true, isEnabled)
    }
    
    func checkBoxIsActiveState(_ isActive: Bool) {
        self.checkBoxIsActiveStateValues = (true, isActive)
    }
    
    func setActivityIndicator(isHidden: Bool) {
        self.setActivityIndicatorIsHidden = isHidden
    }
    
    // MARK: - ServerConfigurationViewControllerType
    func configure(viewModel: ServerConfigurationViewModelType, notificationCenter: NotificationCenterType) {}
}
