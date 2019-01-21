//
//  UserCoordinatorMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 18/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class UserCoordinatorMock: UserCoordinatorDelegate {
    private(set) var userProfileDidLogoutUserCalled = false
    func userProfileDidLogoutUser() {
        userProfileDidLogoutUserCalled = true
    }
}
