//
//  LoginContentProviderMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class LoginContentProviderMock: LoginContentProviderType {
    private(set) var loginCredentials: LoginCredentials?
    private(set) var fetchCompletion: ((Result<SessionDecoder>) -> Void)?
    private(set) var saveCompletion: ((Result<Void>) -> Void)?
    
    func login(with credentials: LoginCredentials,
               fetchCompletion: @escaping ((Result<SessionDecoder>) -> Void),
               saveCompletion: @escaping ((Result<Void>) -> Void)) {
        self.loginCredentials = credentials
        self.fetchCompletion = fetchCompletion
        self.saveCompletion = saveCompletion
    }
}
