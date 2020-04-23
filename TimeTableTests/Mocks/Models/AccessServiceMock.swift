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
    var getLastLoggedInUserIDReturnValue: Int64?
    private(set) var getLastLoggedInUserIDParams: [GetLastLoggedInUserIDParams] = []
    struct GetLastLoggedInUserIDParams {}
    
    // MARK: - UserDataManagerType
    private(set) var setUserDataParams: [SetUserDataParams] = []
    struct SetUserDataParams {
        let user: UserDecoder
    }
    
    var getUserDataReturnValue: UserDecoder?
    private(set) var getUserDataParams: [GetUserDataParams] = []
    struct GetUserDataParams {}
    
    // MARK: - AccessServiceSessionType
    var isSessionOpenedReturnValue: Bool = false
    
    var getSessionReturnValue: SessionDecoder!
    private(set) var getSessionParams: [GetSessionParams] = []
    struct GetSessionParams {}
    
    private(set) var openSessionParams: [OpenSessionParams] = []
    struct OpenSessionParams {
        let session: SessionDecoder
    }
    
    private(set) var openTemporarySessionParams: [OpenTemporarySessionParams] = []
    struct OpenTemporarySessionParams {
        let session: SessionDecoder
    }
    
    private(set) var suspendSessionParams: [SuspendSessionParams] = []
    struct SuspendSessionParams {}
    
    private(set) var continueSuspendedSessionParams: [ContinueSuspendedSessionParams] = []
    struct ContinueSuspendedSessionParams {}
    
    private(set) var closeSessionParams: [CloseSessionParams] = []
    struct CloseSessionParams {}
    
    // MARK: - AccessServiceApiClientType
    var getUserTokenReturnValue: String?
    private(set) var getUserTokenParams: [GetUserTokenParams] = []
    struct GetUserTokenParams {}
}

// MARK: - AccessServiceUserIDType
extension AccessServiceMock: AccessServiceUserIDType {
    func getLastLoggedInUserID() -> Int64? {
        self.getLastLoggedInUserIDParams.append(GetLastLoggedInUserIDParams())
        return self.getLastLoggedInUserIDReturnValue
    }
}

// MARK: - UserDataManagerType
extension AccessServiceMock: UserDataManagerType {
    func setUserData(_ user: UserDecoder) {
        self.setUserDataParams.append(SetUserDataParams(user: user))
    }
    
    func getUserData() -> UserDecoder? {
        self.getUserDataParams.append(GetUserDataParams())
        return self.getUserDataReturnValue
    }
}

// MARK: - AccessServiceSessionType
extension AccessServiceMock: AccessServiceSessionType {
    var isSessionOpened: Bool {
        self.isSessionOpenedReturnValue
    }
    
    func getSession() -> SessionDecoder? {
        self.getSessionParams.append(GetSessionParams())
        return self.getSessionReturnValue
    }
    
    func openSession(_ session: SessionDecoder) {
        self.openSessionParams.append(OpenSessionParams(session: session))
    }
    
    func openTemporarySession(_ session: SessionDecoder) {
        self.openTemporarySessionParams.append(OpenTemporarySessionParams(session: session))
    }
    
    func suspendSession() {
        self.suspendSessionParams.append(SuspendSessionParams())
    }
    
    func continueSuspendedSession() {
        self.continueSuspendedSessionParams.append(ContinueSuspendedSessionParams())
    }
    
    func closeSession() {
        self.closeSessionParams.append(CloseSessionParams())
    }
}

// MARK: - AccessServiceApiClientType
extension AccessServiceMock: AccessServiceApiClientType {
    func getUserToken() -> String? {
        self.getUserTokenParams.append(GetUserTokenParams())
        return self.getUserTokenReturnValue
    }
}
