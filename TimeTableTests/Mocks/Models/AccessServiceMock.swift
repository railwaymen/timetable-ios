//
//  AccessServiceMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class AccessServiceMock {
    
    var saveUserThrowError: Error?
    private(set) var saveUserParams: [SaveUserParams] = []
    struct SaveUserParams {
        var credentails: LoginCredentials
    }
    
    var getUserCredentialsThrowError: Error?
    var getUserCredentialsReturnValue: LoginCredentials = LoginCredentials(email: "", password: "")
    private(set) var getUserCredentialsParams: [GetUserCredentialsParams] = []
    struct GetUserCredentialsParams {}
    
    private(set) var removeLastLoggedInUserIdentifierParams: [RemoveLastLoggedInUserIdentifierParams] = []
    struct RemoveLastLoggedInUserIdentifierParams {}
    
    private(set) var saveLastLoggedInUserIdentifierParams: [SaveLastLoggedInUserIdentifierParams] = []
    struct SaveLastLoggedInUserIdentifierParams {
        var identifier: Int64
    }
    
    var getLastLoggedInUserIdentifierReturnValue: Int64?
    private(set) var getLastLoggedInUserIdentifierParams: [GetLastLoggedInUserIdentifierParams] = []
    struct GetLastLoggedInUserIdentifierParams {}
    
    private(set) var getSessionParams: [GetSessionParams] = []
    struct GetSessionParams {
        var completion: ((Result<SessionDecoder, Error>) -> Void)
    }
}

// MARK: - AccessServiceLoginCredentialsType
extension AccessServiceMock: AccessServiceLoginCredentialsType {
    func saveUser(credentails: LoginCredentials) throws {
        self.saveUserParams.append(SaveUserParams(credentails: credentails))
        if let error = self.saveUserThrowError {
            throw error
        }
    }
    
    func getUserCredentials() throws -> LoginCredentials {
        self.getUserCredentialsParams.append(GetUserCredentialsParams())
        if let error = self.getUserCredentialsThrowError {
            throw error
        }
        return self.getUserCredentialsReturnValue
    }
    
    func removeLastLoggedInUserIdentifier() {
        self.removeLastLoggedInUserIdentifierParams.append(RemoveLastLoggedInUserIdentifierParams())
    }
}

// MARK: - AccessServiceUserIDType
extension AccessServiceMock: AccessServiceUserIDType {
    func saveLastLoggedInUserIdentifier(_ identifer: Int64) {
        self.saveLastLoggedInUserIdentifierParams.append(SaveLastLoggedInUserIdentifierParams(identifier: identifer))
    }
    
    func getLastLoggedInUserIdentifier() -> Int64? {
        self.getLastLoggedInUserIdentifierParams.append(GetLastLoggedInUserIdentifierParams())
        return self.getLastLoggedInUserIdentifierReturnValue
    }
}

// MARK: - AccessServiceSessionType
extension AccessServiceMock: AccessServiceSessionType {
    func getSession(completion: @escaping ((Result<SessionDecoder, Error>) -> Void)) {
        self.getSessionParams.append(GetSessionParams(completion: completion))
    }
}
