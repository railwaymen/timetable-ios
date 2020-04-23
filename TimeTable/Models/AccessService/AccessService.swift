//
//  AccessService.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 16/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

typealias AccessServiceLoginType = (
    AccessServiceUserIDType
    & AccessServiceSessionType
    & AccessServiceApiClientType
    & UserDataManagerType)

protocol AccessServiceUserIDType: class {
    func getLastLoggedInUserID() -> Int64?
}

protocol UserDataManagerType: class {
    func setUserData(_ user: UserDecoder)
    func getUserData() -> UserDecoder?
}

protocol AccessServiceSessionType: class {
    var isSessionOpened: Bool { get }
    func getSession() -> SessionDecoder?
    func openSession(_ session: SessionDecoder)
    func openTemporarySession(_ session: SessionDecoder)
    func suspendSession()
    func continueSuspendedSession()
    func closeSession()
}

protocol AccessServiceApiClientType: class {
    func getUserToken() -> String?
}

class AccessService {
    private let sessionManager: SessionManagerable
    private let temporarySessionManager: TemporarySessionManagerable
    
    private var currentUserDataManager: UserDataManagerType? {
        guard self.sessionManager.getSession() == nil else { return self.sessionManager }
        guard self.temporarySessionManager.getSession() == nil else { return self.temporarySessionManager }
        return nil
    }
    
    // MARK: - Initialization
    init(
        sessionManager: SessionManagerable,
        temporarySessionManager: TemporarySessionManagerable
    ) {
        self.sessionManager = sessionManager
        self.temporarySessionManager = temporarySessionManager
    }
}

// MARK: - AccessServiceUserIDType
extension AccessService: AccessServiceUserIDType {
    func getLastLoggedInUserID() -> Int64? {
        guard let session = self.getSession() else { return nil }
        return Int64(session.id)
    }
}

// MARK: - UserDataManagerType
extension AccessService: UserDataManagerType {
    func setUserData(_ user: UserDecoder) {
        self.currentUserDataManager?.setUserData(user)
    }
    
    func getUserData() -> UserDecoder? {
        self.currentUserDataManager?.getUserData()
    }
}

// MARK: - AccessServiceSessionType
extension AccessService: AccessServiceSessionType {
    var isSessionOpened: Bool {
        self.getSession() != nil
    }
    
    func getSession() -> SessionDecoder? {
        self.sessionManager.getSession()
            ?? self.temporarySessionManager.getSession()
    }
    
    func openSession(_ session: SessionDecoder) {
        self.closeSession()
        self.sessionManager.open(session: session)
    }
    
    func openTemporarySession(_ session: SessionDecoder) {
        self.closeSession()
        self.temporarySessionManager.open(session: session)
    }
    
    func suspendSession() {
        self.temporarySessionManager.suspendSession()
    }
    
    func continueSuspendedSession() {
        self.temporarySessionManager.continueSuspendedSession()
    }
    
    func closeSession() {
        self.sessionManager.closeSession()
        self.temporarySessionManager.closeSession()
    }
}

// MARK: - AccessServiceApiClientType
extension AccessService: AccessServiceApiClientType {
    func getUserToken() -> String? {
        self.getSession()?.token
    }
}
