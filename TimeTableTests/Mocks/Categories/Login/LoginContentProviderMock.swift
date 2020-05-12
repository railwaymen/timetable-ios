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
    
    // MARK: - LoginContentProviderType
    private(set) var closeSessionParams: [CloseSessionParams] = []
    struct CloseSessionParams {}
    
    private(set) var loginParams: [LoginParams] = []
    struct LoginParams {
        let credentials: LoginCredentials
        let shouldSaveUser: Bool
        let completion: ((Result<SessionDecoder, Error>) -> Void)
    }
}

// MARK: - LoginContentProviderType
extension LoginContentProviderMock: LoginContentProviderType {
    func closeSession() {
        self.closeSessionParams.append(CloseSessionParams())
    }
    
    func login(
        with credentials: LoginCredentials,
        shouldSaveUser: Bool,
        completion: @escaping ((Result<SessionDecoder, Error>) -> Void)
    ) {
        self.loginParams.append(
            LoginParams(
                credentials: credentials,
                shouldSaveUser: shouldSaveUser,
                completion: completion))
    }
}
