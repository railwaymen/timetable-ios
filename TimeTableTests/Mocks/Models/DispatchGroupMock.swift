//
//  DispatchGroupMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 30/10/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class DispatchGroupMock {
    
    private(set) var enterParams: [EnterParams] = []
    struct EnterParams {}
    
    private(set) var leaveParams: [LeaveParams] = []
    struct LeaveParams {}
    
    private(set) var notifyParams: [NotifyParams] = []
    struct NotifyParams {
        var qos: DispatchQoS
        var flags: DispatchWorkItemFlags
        var queue: DispatchQueue
        var work: () -> Void
    }
}

// MARK: - DispatchGroupType
extension DispatchGroupMock: DispatchGroupType {
    func enter() {
        self.enterParams.append(EnterParams())
    }
    
    func leave() {
        self.leaveParams.append(LeaveParams())
        if self.enterParams.count == self.leaveParams.count {
            self.notifyParams.last?.work()
        }
    }
    
    func notify(qos: DispatchQoS, flags: DispatchWorkItemFlags, queue: DispatchQueue, execute work: @escaping @convention(block) () -> Void) {
        self.notifyParams.append(NotifyParams(qos: qos, flags: flags, queue: queue, work: work))
    }
}
