//
//  DispatchQueueManager.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 28/10/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

protocol DispatchQueueManagerType {
    func performOnMainThread(taskType: DispatchQueueTaskType, _ task: @escaping () -> Void)
    func performOnMainThreadAsyncAfter(deadline: DispatchTime, _ task: @escaping () -> Void)
}

class DispatchQueueManager: DispatchQueueManagerType {
    func performOnMainThread(taskType: DispatchQueueTaskType, _ task: @escaping () -> Void) {
        DispatchQueue.performOnMainThread(taskType: taskType, task)
    }
    
    func performOnMainThreadAsyncAfter(deadline: DispatchTime, _ task: @escaping () -> Void) {
        DispatchQueue.performOnMainThreadAsyncAfter(deadline: deadline, task)
    }
}
