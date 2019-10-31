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
    private(set) var enterCalledCount: Int = 0
    func enter() {
        self.enterCalledCount += 1
    }
    
    private(set) var leaveCalledCount: Int = 0
    func leave() {
        self.leaveCalledCount += 1
        if self.leaveCalledCount == self.enterCalledCount {
            self.notifyWork?()
        }
    }
    
    private(set) var notifyCalledCount: Int = 0
    private(set) var notifyValues: (qos: DispatchQoS, flags: DispatchWorkItemFlags, queue: DispatchQueue)?
    private(set) var notifyWork: (() -> Void)?
    func notify(
        qos: DispatchQoS,
        flags: DispatchWorkItemFlags,
        queue: DispatchQueue,
        execute work: @escaping @convention(block) () -> Void
    ) {
        self.notifyCalledCount += 1
        self.notifyValues = (qos, flags, queue)
        self.notifyWork = work
    }
}
// swiftlint:enable large_tuple
