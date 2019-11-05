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
    func configure(viewModel: ServerConfigurationViewModelType, notificationCenter: NotificationCenterType) {}
    func setupView(checkBoxIsActive: Bool, serverAddress: String) {}
    func tearDown() {}
    func hideNavigationBar() {}
    func continueButtonEnabledState(_ isEnabled: Bool) {}
    func checkBoxIsActiveState(_ isActive: Bool) {}
    func dismissKeyboard() {}
    func setActivityIndicator(isHidden: Bool) {}
}
