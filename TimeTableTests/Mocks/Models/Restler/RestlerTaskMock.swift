//
//  RestlerTaskMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 23/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
import Restler

class RestlerTaskMock {
    var identifierReturnValue: Int = 0
    
    var stateReturnValue: URLSessionTask.State = .running
    
    private(set) var cancelParams: [CancelParams] = []
    struct CancelParams {}
    
    private(set) var suspendParams: [SuspendParams] = []
    struct SuspendParams {}
    
    private(set) var resumeParams: [ResumeParams] = []
    struct ResumeParams {}
}

// MARK: - RestlerTaskType
extension RestlerTaskMock: RestlerTaskType {
    var identifier: Int {
        self.identifierReturnValue
    }
    
    var state: URLSessionTask.State {
        self.stateReturnValue
    }
    
    func cancel() {
        self.cancelParams.append(CancelParams())
    }
    
    func suspend() {
        self.suspendParams.append(SuspendParams())
    }
    
    func resume() {
        self.resumeParams.append(ResumeParams())
    }
}
