//
//  ApiClientMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class ApiClientMock: ApiClientSessionType {
    
    private(set) var signInCredentials: LoginCredentials?
    private(set) var signInCompletion: ((Result<SessionDecoder>) -> Void)?
    
    func signIn(with credentials: LoginCredentials, completion: @escaping ((Result<SessionDecoder>) -> Void)) {
        signInCredentials = credentials
        signInCompletion = completion
    }
}
