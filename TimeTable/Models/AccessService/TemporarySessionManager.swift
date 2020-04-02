//
//  TemporarySessionManager.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 02/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol TemporarySessionManagerType: class {
    var isSessionOpened: Bool { get }
    func open(session: SessionDecoder)
    func suspendSession()
    func continueSuspendedSession()
    func closeSession()
    func getSession() -> SessionDecoder?
}

class TemporarySessionManager {
    private var session: SessionDecoder?
    private var lastSuspendDate: Date?
}

// MARK: - TemporarySessionManagerType
extension TemporarySessionManager: TemporarySessionManagerType {
    var isSessionOpened: Bool {
        self.session != nil && self.validateSession()
    }
    
    func open(session: SessionDecoder) {
        self.session = session
    }
    
    func suspendSession() {
        self.lastSuspendDate = Date()
    }
    
    func continueSuspendedSession() {
        guard !self.validateSession() else { return }
        self.closeSession()
    }
    
    func closeSession() {
        self.session = nil
    }
    
    func getSession() -> SessionDecoder? {
        return self.session
    }
}

// MARK: - Private
extension TemporarySessionManager {
    private func validateSession() -> Bool {
        let currentDate = Date()
        let sessionSuspendTime = currentDate.timeIntervalSince(self.lastSuspendDate ?? currentDate)
        return sessionSuspendTime < 3 * .minute
    }
}
