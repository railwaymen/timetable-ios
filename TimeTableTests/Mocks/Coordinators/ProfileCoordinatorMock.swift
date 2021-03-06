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
    
    private(set) var viewDidRequestToShowAccountingPeriodsParams: [ViewDidRequestToShowAccountingPeriodsParams] = []
    // swiftlint:disable:next type_name
    struct ViewDidRequestToShowAccountingPeriodsParams {}
    
    private(set) var viewDidRequestToFinishParams: [ViewDidRequestToFinishParams] = []
    struct ViewDidRequestToFinishParams {}
}

// MARK: - ProfileCoordinatorDelegate
extension ProfileCoordinatorMock: ProfileCoordinatorDelegate {
    func userProfileDidLogoutUser() {
        self.userProfileDidLogoutUserParams.append(UserProfileDidLogoutUserParams())
    }
    
    func viewDidRequestToShowAccountingPeriods() {
        self.viewDidRequestToShowAccountingPeriodsParams.append(ViewDidRequestToShowAccountingPeriodsParams())
    }
    
    func viewDidRequestToFinish() {
        self.viewDidRequestToFinishParams.append(ViewDidRequestToFinishParams())
    }
}
