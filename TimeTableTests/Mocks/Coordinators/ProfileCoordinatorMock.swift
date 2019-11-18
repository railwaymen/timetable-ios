//
//  ProfileCoordinatorMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 18/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ProfileCoordinatorMock {
    private(set) var userProfileDidLogoutUserParams: [UserProfileDidLogoutUserParams] = []
    struct UserProfileDidLogoutUserParams {}
}

// MARK: - ProfileCoordinatorDelegate
extension ProfileCoordinatorMock: ProfileCoordinatorDelegate {
    func userProfileDidLogoutUser() {
        self.userProfileDidLogoutUserParams.append(UserProfileDidLogoutUserParams())
    }
}
