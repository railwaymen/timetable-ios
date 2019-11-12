//
//  ProfileViewControllerMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 18/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ProfileViewControllerMock: UIViewController, ProfileViewModelOutput, ProfileViewControllerType {
    
    // MARK: - ProfileViewModelOutput
    private(set) var setUpCalled = false
    func setUp() {
        self.setUpCalled = true
    }
    
    // swiftlint:disable large_tuple
    private(set) var updateValues: (String?, String?, String?) = (nil, nil, nil)
    func update(firstName: String, lastName: String, email: String) {
        self.updateValues = (firstName, lastName, email)
    }
    // swiftlint:enable large_tuple
    
    private(set) var setActivityIndicatorIsHidden: Bool?
    func setActivityIndicator(isHidden: Bool) {
        self.setActivityIndicatorIsHidden = isHidden
    }

    private(set) var showScrollViewCalled = false
    func showScrollView() {
        self.showScrollViewCalled = true
    }
    
    private(set) var showErrorViewCalled = false
    func showErrorView() {
        self.showErrorViewCalled = true
    }
    
    // MARK: - ProfileViewControllerType
    private(set) var configureCalled = false
    func configure(viewModel: ProfileViewModelType) {
        self.configureCalled = true
    }
}
