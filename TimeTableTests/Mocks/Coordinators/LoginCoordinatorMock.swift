//
//  LoginCoordinatorMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class LoginCoordinatorMock: LoginCoordinatorDelegate {
    private(set) var loginDidFinishCalled = false
    private(set) var loginDidFinishWithState: AuthenticationCoordinator.State?
    
    func loginDidFinish(with state: AuthenticationCoordinator.State) {
        self.loginDidFinishCalled = true
        self.loginDidFinishWithState = state
    }
}
