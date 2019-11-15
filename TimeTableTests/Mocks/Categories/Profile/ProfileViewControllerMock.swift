//
//  ProfileViewControllerMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 18/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ProfileViewControllerMock: UIViewController {
    private(set) var setUpParams: [SetUpParams] = []
    private(set) var updateParams: [UpdateParams] = []
    private(set) var setActivityIndicatorParams: [SetActivityIndicatorParams] = []
    private(set) var showScrollViewParams: [ShowScrollViewParams] = []
    private(set) var showErrorViewParams: [ShowErrorViewParams] = []
    private(set) var configureParams: [ConfigureParams] = []

    // MARK: - Structures
    struct SetUpParams {}
    
    struct UpdateParams {
        var firstName: String
        var lastName: String
        var email: String
    }
    
    struct SetActivityIndicatorParams {
        var isHidden: Bool
    }
    
    struct ShowScrollViewParams {}
    
    struct ShowErrorViewParams {}
    
    struct ConfigureParams {
        var viewModel: ProfileViewModelType
    }
}

// MARK: - ProfileViewModelOutput
extension ProfileViewControllerMock: ProfileViewModelOutput {
    func setUp() {
        self.setUpParams.append(SetUpParams())
    }
    
    func update(firstName: String, lastName: String, email: String) {
        self.updateParams.append(UpdateParams(firstName: firstName, lastName: lastName, email: email))
    }
    
    func setActivityIndicator(isHidden: Bool) {
        self.setActivityIndicatorParams.append(SetActivityIndicatorParams(isHidden: isHidden))
    }
    
    func showScrollView() {
        self.showScrollViewParams.append(ShowScrollViewParams())
    }
    
    func showErrorView() {
        self.showErrorViewParams.append(ShowErrorViewParams())
    }
}

// MARK: - ProfileViewControllerType
extension ProfileViewControllerMock: ProfileViewControllerType {
    func configure(viewModel: ProfileViewModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
