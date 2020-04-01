//
//  DispatchGroup+Extension.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 30/10/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

protocol DispatchGroupType: class {
    func enter()
    func leave()
    func notify(
        qos: DispatchQoS,
        flags: DispatchWorkItemFlags,
        queue: DispatchQueue,
        execute work: @escaping @convention(block) () -> Void)
}

extension DispatchGroupType {
    func notify(qos: DispatchQoS, queue: DispatchQueue, execute work: @escaping @convention(block) () -> Void) {
        self.notify(qos: qos, flags: [], queue: queue, execute: work)
    }
}

extension DispatchGroup: DispatchGroupType {}
