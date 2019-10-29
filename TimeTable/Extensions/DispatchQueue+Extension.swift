//
//  DispatchQueue+Extension.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 28/10/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

enum DispatchQueueTaskType {
    case sync, async
}

extension DispatchQueue {
    static func performOnMainThread(taskType: DispatchQueueTaskType, _ task: @escaping () -> Void) {
        if Thread.isMainThread {
            task()
        } else {
            switch taskType {
            case .sync: DispatchQueue.main.sync { task() }
            case .async: DispatchQueue.main.async { task() }
            }
        }
    }
}
