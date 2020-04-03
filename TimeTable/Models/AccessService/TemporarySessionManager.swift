//
//  TemporarySessionManager.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 02/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol TemporarySessionManagerType: class {
    func open(session: SessionDecoder)
    func suspendSession()
    func continueSuspendedSession()
    func closeSession()
    func getSession() -> SessionDecoder?
}

class TemporarySessionManager {
    private static let maxSuspensionTimeForSession: TimeInterval = 3 * .minute
    
    private var session: SessionDecoder?
    private var lastSuspendDate: Date?
}

// MARK: - TemporarySessionManagerType
extension TemporarySessionManager: TemporarySessionManagerType {
    func open(session: SessionDecoder) {
        self.session = session
    }
    
    func suspendSession() {
        self.lastSuspendDate = Date()
    }
    
    func continueSuspendedSession() {
        self.closeSessionIfTimedOut()
        self.lastSuspendDate = nil
    }
    
    func closeSession() {
        self.session = nil
    }
    
    func getSession() -> SessionDecoder? {
        self.closeSessionIfTimedOut()
        return self.session
    }
}

// MARK: - Private
extension TemporarySessionManager {
    private func closeSessionIfTimedOut() {
        guard self.isSessionTimedOut() else { return }
        self.closeSession()
    }
    
    private func isSessionTimedOut() -> Bool {
        let currentDate = Date()
        let sessionSuspensionTime = currentDate.timeIntervalSince(self.lastSuspendDate ?? currentDate)
        return sessionSuspensionTime > Self.maxSuspensionTimeForSession
    }
}
