//
//  LoginCoordinatorMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class LoginCoordinatorMock {
    private(set) var loginDidFinishParams: [LoginDidFinishParams] = []
    struct LoginDidFinishParams {
        var state: AuthenticationCoordinator.State
    }
}

// MARK: - LoginCoordinatorDelegate
extension LoginCoordinatorMock: LoginCoordinatorDelegate {
    func loginDidFinish(with state: AuthenticationCoordinator.State) {
        self.loginDidFinishParams.append(LoginDidFinishParams(state: state))
    }
}
