//
//  LoginContentProviderMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class LoginContentProviderMock {
    private(set) var loginParams: [LoginParams] = []
    struct LoginParams {
        var credentials: LoginCredentials
        var completion: ((Result<SessionDecoder, Error>) -> Void)
    }
}

// MARK: - LoginContentProviderType
extension LoginContentProviderMock: LoginContentProviderType {
    func login(
        with credentials: LoginCredentials,
        completion: @escaping ((Result<SessionDecoder, Error>) -> Void)
    ) {
        self.loginParams.append(
            LoginParams(
                credentials: credentials,
                completion: completion))
    }
}
