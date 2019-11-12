//
//  DispatchQueueManagerMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 28/10/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class DispatchQueueManagerMock: DispatchQueueManagerType {
    let taskType: TaskType
    
    enum TaskType {
        case performOnOriginalThread
        case performOnCurrentThread
    }
    
    /// - Parameter taskType: The enum provides information if task,
    /// will be called using the main/global thread or the current one. You prefer using `performOnCurrentThread`
    /// if the original thread is not really needed for the action.
    init(taskType: TaskType) {
        self.taskType = taskType
    }
    
    private(set) var performOnMainThread_calledCount: Int = 0
    private(set) var performOnMainThread_taskType: DispatchQueueTaskType?
    func performOnMainThread(taskType: DispatchQueueTaskType, _ task: @escaping () -> Void) {
        self.performOnMainThread_calledCount += 1
        self.performOnMainThread_taskType = taskType
        
        switch self.taskType {
        case .performOnOriginalThread: DispatchQueue.performOnMainThread(taskType: .sync, task)
        case .performOnCurrentThread: task()
        }
    }
}
