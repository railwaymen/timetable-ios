//
//  TemporarySessionManager.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 02/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

typealias TemporarySessionManagerable = TemporarySessionManagerType & UserDataManagerType

protocol TemporarySessionManagerType: class {
    func open(session: SessionDecoder)
    func suspendSession()
    func continueSuspendedSession()
    func closeSession()
    func getSession() -> SessionDecoder?
}

class TemporarySessionManager {
    private static let maxSuspensionTimeForSession: TimeInterval = 3 * .minute
    
    private let dateFactory: DateFactoryType
    private var session: SessionDecoder?
    private var lastSuspendDate: Date?
    private var userData: UserDecoder?
    
    // MARK: - Initialization
    init(dateFactory: DateFactoryType) {
        self.dateFactory = dateFactory
    }
}

// MARK: - TemporarySessionManagerType
extension TemporarySessionManager: TemporarySessionManagerType {
    func open(session: SessionDecoder) {
        self.session = session
    }
    
    func suspendSession() {
        self.lastSuspendDate = self.dateFactory.currentDate
    }
    
    func continueSuspendedSession() {
        self.closeSessionIfTimedOut()
        self.lastSuspendDate = nil
    }
    
    func closeSession() {
        self.userData = nil
        self.session = nil
    }
    
    func getSession() -> SessionDecoder? {
        self.closeSessionIfTimedOut()
        return self.session
    }
}

// MARK: - UserDataManagerType
extension TemporarySessionManager: UserDataManagerType {
    func setUserData(_ user: UserDecoder) {
        self.userData = user
    }
    
    func getUserData() -> UserDecoder? {
        self.userData
    }
}

// MARK: - Private
extension TemporarySessionManager {
    private func closeSessionIfTimedOut() {
        guard self.isSessionTimedOut() else { return }
        self.closeSession()
    }
    
    private func isSessionTimedOut() -> Bool {
        let currentDate = self.dateFactory.currentDate
        let sessionSuspensionTime = currentDate.timeIntervalSince(self.lastSuspendDate ?? currentDate)
        return sessionSuspensionTime > Self.maxSuspensionTimeForSession
    }
}
