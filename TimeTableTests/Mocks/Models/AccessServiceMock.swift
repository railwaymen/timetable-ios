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
    
    // MARK: - AccessServiceLoginCredentialsType
    private(set) var removeLastLoggedInUserIdentifierParams: [RemoveLastLoggedInUserIdentifierParams] = []
    struct RemoveLastLoggedInUserIdentifierParams {}
    
    // MARK: - AccessServiceUserIDType
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
