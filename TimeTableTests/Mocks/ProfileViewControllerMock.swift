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
        setUpCalled = true
    }
    
    // swiftlint:disable large_tuple
    private(set) var updateValues: (String?, String?, String?) = (nil, nil, nil)
    func update(firstName: String, lastName: String, email: String) {
        updateValues = (firstName, lastName, email)
    }
    // swiftlint:enable large_tuple
    
    private(set) var setActivityIndicatorIsHidden: Bool?
    func setActivityIndicator(isHidden: Bool) {
        setActivityIndicatorIsHidden = isHidden
    }

    private(set) var showScrollViewCalled = false
    func showScrollView() {
        showScrollViewCalled = true
    }
    
    private(set) var showErrorViewCalled = false
    func showErrorView() {
        showErrorViewCalled = true
    }
    
    // MARK: - ProfileViewControllerType
    private(set) var configureCalled = false
    func configure(viewModel: ProfileViewModelType) {
        configureCalled = true
    }
}
