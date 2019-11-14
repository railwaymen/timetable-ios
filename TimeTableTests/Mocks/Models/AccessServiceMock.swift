//
//  AccessServiceMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class AccessServiceMock: AccessServiceLoginType {

    private(set) var saveUserCalled = false
    private(set) var getUserCredentialsCalled = false
    private(set) var removeLastLoggedInUserIdentifierCalled = false
    
    var saveUserIsThrowingError = false
    var userCredentials: LoginCredentials?
    var getUserCredentialsReturnsError = false
    
    // MARK: - AccessServiceLoginCredentialsType
    func saveUser(credentails: LoginCredentials) throws {
        self.saveUserCalled = true
        if self.saveUserIsThrowingError {
            throw TestError(message: "save user")
        }
    }
    
    func getUserCredentials() throws -> LoginCredentials {
        self.getUserCredentialsCalled = true
        guard !self.getUserCredentialsReturnsError else {
            throw TestError(message: "getUserCredentials error")
        }
        if let credentails = self.userCredentials {
            return credentails
        } else {
            return LoginCredentials(email: "", password: "")
        }
    }
    
    func removeLastLoggedInUserIdentifier() {
        self.removeLastLoggedInUserIdentifierCalled = true
    }
    
    // MARK: - AccessServiceLoginCredentialsType
    private(set) var saveLastLoggedInUserIdentifierValues: (called: Bool, identifier: Int64?) = (false, nil)
    private(set) var getLastLoggedInUserIdentifierCalled = false
    var getLastLoggedInUserIdentifierValue: Int64?
    
    func saveLastLoggedInUserIdentifier(_ identifer: Int64) {
        self.saveLastLoggedInUserIdentifierValues = (true, identifer)
    }
    
    func getLastLoggedInUserIdentifier() -> Int64? {
        self.getLastLoggedInUserIdentifierCalled = true
        return self.getLastLoggedInUserIdentifierValue
    }
    
    // MARK: - AccessServiceSessionType
    private(set) var getSessionCalled = false
    var getSessionCompletion: ((Result<SessionDecoder>) -> Void)?
    func getSession(completion: @escaping ((Result<SessionDecoder>) -> Void)) {
        self.getSessionCalled = true
        self.getSessionCompletion = completion
    }
}
