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
    private(set) var fetchCompletion: ((Result<Void>) -> Void)?
    private(set) var saveCompletion: ((Result<Void>) -> Void)?
    
    func login(with credentials: LoginCredentials, fetchCompletion: @escaping ((Result<Void>) -> Void), saveCompletion: @escaping ((Result<Void>) -> Void)) {
        self.loginCredentials = credentials
        self.fetchCompletion = fetchCompletion
        self.saveCompletion = saveCompletion
    }
}
