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
        saveUserCalled = true
        if saveUserIsThrowingError {
            throw TestError(messsage: "save user")
        }
    }
    
    func getUserCredentials() throws -> LoginCredentials {
        getUserCredentialsCalled = true
        guard !getUserCredentialsReturnsError else {
            throw TestError(messsage: "getUserCredentials error")
        }
        if let credentails = userCredentials {
            return credentails
        } else {
            return LoginCredentials(email: "", password: "")
        }
    }
    
    func removeLastLoggedInUserIdentifier() {
        removeLastLoggedInUserIdentifierCalled = true
    }
    
    // MARK: - AccessServiceLoginCredentialsType
    private(set) var saveLastLoggedInUserIdentifierValues: (called: Bool, identifier: Int64?) = (false, nil)
    private(set) var getLastLoggedInUserIdentifierCalled = false
    var getLastLoggedInUserIdentifierValue: Int64?
    
    func saveLastLoggedInUserIdentifier(_ identifer: Int64) {
        saveLastLoggedInUserIdentifierValues = (true, identifer)
    }
    
    func getLastLoggedInUserIdentifier() -> Int64? {
        getLastLoggedInUserIdentifierCalled = true
        return getLastLoggedInUserIdentifierValue
    }
}
