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
    & AccessServiceApiClientType)

protocol AccessServiceUserIDType: class {
    func getLastLoggedInUserIdentifier() -> Int64?
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
    private let sessionManager: SessionManagerType
    private let temporarySessionManager: TemporarySessionManagerType
    
    // MARK: - Initialization
    init(
        sessionManager: SessionManagerType,
        temporarySessionManager: TemporarySessionManagerType
    ) {
        self.sessionManager = sessionManager
        self.temporarySessionManager = temporarySessionManager
    }
}

// MARK: - AccessServiceUserIDType
extension AccessService: AccessServiceUserIDType {
    func getLastLoggedInUserIdentifier() -> Int64? {
        guard let session = self.getSession() else { return nil }
        return Int64(session.identifier)
    }
}

// MARK: - AccessServiceSessionType
extension AccessService: AccessServiceSessionType {
    var isSessionOpened: Bool {
        (self.sessionManager.getSession() ?? self.temporarySessionManager.getSession()) != nil
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
