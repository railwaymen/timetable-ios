//
//  SessionManagerMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 03/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class SessionManagerMock {
    
    // MARK: - SessionManagerType
    private(set) var openSessionParams: [OpenSessionParams] = []
    struct OpenSessionParams {
        let session: SessionDecoder
    }
    
    private(set) var closeSessionParams: [CloseSessionParams] = []
    struct CloseSessionParams {}
    
    var getSessionReturnValue: SessionDecoder?
    private(set) var getSessionParams: [GetSessionParams] = []
    struct GetSessionParams {}
}

// MARK: - SessionManagerType
extension SessionManagerMock: SessionManagerType {
    func open(session: SessionDecoder) {
        self.openSessionParams.append(OpenSessionParams(session: session))
    }
    
    func closeSession() {
        self.closeSessionParams.append(CloseSessionParams())
    }
    
    func getSession() -> SessionDecoder? {
        self.getSessionParams.append(GetSessionParams())
        return self.getSessionReturnValue
    }
}
