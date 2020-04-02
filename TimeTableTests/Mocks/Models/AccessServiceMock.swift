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
    
    // MARK: - AccessServiceUserIDType
    var getLastLoggedInUserIdentifierReturnValue: Int64?
    private(set) var getLastLoggedInUserIdentifierParams: [GetLastLoggedInUserIdentifierParams] = []
    struct GetLastLoggedInUserIdentifierParams {}
    
    // MARK: - AccessServiceSessionType
    var getSessionThrownError: Error?
    var getSessionReturnValue: SessionDecoder!
    private(set) var getSessionParams: [GetSessionParams] = []
    struct GetSessionParams {}
    
    var saveSessionThrownError: Error?
    private(set) var saveSessionParams: [SaveSessionParams] = []
    struct SaveSessionParams {
        let session: SessionDecoder
    }
    
    private(set) var setTemporarySessionParams: [SetTemporarySession] = []
    struct SetTemporarySession {
        let session: SessionDecoder
    }
    
    var removeSessionThrownError: Error?
    private(set) var removeSessionParams: [RemoveSessionParams] = []
    struct RemoveSessionParams {}
    
    // MARK: - AccessServiceApiClientType
    var getUserTokenReturnValue: String?
    private(set) var getUserTokenParams: [GetUserTokenParams] = []
    struct GetUserTokenParams {}
}

// MARK: - AccessServiceUserIDType
extension AccessServiceMock: AccessServiceUserIDType {
    func getLastLoggedInUserIdentifier() -> Int64? {
        self.getLastLoggedInUserIdentifierParams.append(GetLastLoggedInUserIdentifierParams())
        return self.getLastLoggedInUserIdentifierReturnValue
    }
}

// MARK: - AccessServiceSessionType
extension AccessServiceMock: AccessServiceSessionType {
    func getSession() throws -> SessionDecoder {
        if let error = self.getSessionThrownError {
            throw error
        }
        return self.getSessionReturnValue
    }
    
    func saveSession(_ session: SessionDecoder) throws {
        self.saveSessionParams.append(SaveSessionParams(session: session))
        guard let error = self.saveSessionThrownError else { return }
        throw error
    }
    
    func setTemporarySession(_ session: SessionDecoder) {
        self.setTemporarySessionParams.append(SetTemporarySession(session: session))
    }
    
    func removeSession() throws {
        self.removeSessionParams.append(RemoveSessionParams())
        guard let error = self.removeSessionThrownError else { return }
        throw error
    }
}

// MARK: - AccessServiceApiClientType
extension AccessServiceMock: AccessServiceApiClientType {
    func getUserToken() -> String? {
        self.getUserTokenParams.append(GetUserTokenParams())
        return self.getUserTokenReturnValue
    }
}
