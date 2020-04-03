//
//  TemporarySessionManagerMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 03/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class TemporarySessionManagerMock {
    
    // MARK: - TemporarySessionManagerType
    private(set) var openSessionParams: [OpenSessionParams] = []
    struct OpenSessionParams {
        let session: SessionDecoder
    }
    
    private(set) var suspendSessionParams: [SuspendSessionParams] = []
    struct SuspendSessionParams {}
    
    private(set) var continueSuspendedSessionParams: [ContinueSuspendedSessionParams] = []
    struct ContinueSuspendedSessionParams {}
    
    private(set) var closeSessionParams: [CloseSessionParams] = []
    struct CloseSessionParams {}
    
    var getSessionReturnValue: SessionDecoder?
    private(set) var getSessionParams: [GetSessionParams] = []
    struct GetSessionParams {}
}

// MARK: - TemporarySessionManagerType
extension TemporarySessionManagerMock: TemporarySessionManagerType {
    func open(session: SessionDecoder) {
        self.openSessionParams.append(OpenSessionParams(session: session))
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
    
    func getSession() -> SessionDecoder? {
        self.getSessionParams.append(GetSessionParams())
        return self.getSessionReturnValue
    }
}
