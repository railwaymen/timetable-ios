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
    
    // MARK: - Structures
    struct LoginParams {
        var credentials: LoginCredentials
        var fetchCompletion: ((Result<SessionDecoder>) -> Void)
        var saveCompletion: ((Result<Void>) -> Void)
    }
}

// MARK: - LoginContentProviderType
extension LoginContentProviderMock: LoginContentProviderType {
    func login(with credentials: LoginCredentials,
               fetchCompletion: @escaping ((Result<SessionDecoder>) -> Void),
               saveCompletion: @escaping ((Result<Void>) -> Void)) {
        self.loginParams.append(LoginParams(credentials: credentials,
                                            fetchCompletion: fetchCompletion,
                                            saveCompletion: saveCompletion))
    }
}
