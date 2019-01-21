//
//  UserProfileViewMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 18/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class UserProfileViewMock: UIViewController, UserProfileViewModelOutput, UserProfileViewControllerType {
    
    // MARK: - UserProfileViewModelOutput
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
    
    // MARK: - UserProfileViewControllerType
    private(set) var configureCalled = false
    func configure(viewModel: UserProfileViewModelType) {
        configureCalled = true
    }
}
