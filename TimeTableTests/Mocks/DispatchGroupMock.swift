//
//  DispatchGroupMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 30/10/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

// swiftlint:disable large_tuple
class DispatchGroupMock: DispatchGroupType {
    private(set) var enter_calledCount: Int = 0
    func enter() {
        self.enter_calledCount += 1
    }
    
    private(set) var leave_calledCount: Int = 0
    func leave() {
        self.leave_calledCount += 1
        if self.leave_calledCount == self.enter_calledCount {
            self.notify_work?()
        }
    }
    
    private(set) var notify_calledCount: Int = 0
    private(set) var notify_values: (qos: DispatchQoS, flags: DispatchWorkItemFlags, queue: DispatchQueue)?
    private(set) var notify_work: (() -> Void)?
    func notify(
        qos: DispatchQoS,
        flags: DispatchWorkItemFlags,
        queue: DispatchQueue,
        execute work: @escaping @convention(block) () -> Void
    ) {
        self.notify_calledCount += 1
        self.notify_values = (qos, flags, queue)
        self.notify_work = work
    }
}
// swiftlint:enable large_tuple

