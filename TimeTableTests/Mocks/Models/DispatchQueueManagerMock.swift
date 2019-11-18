//
//  DispatchQueueManagerMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 28/10/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class DispatchQueueManagerMock {
    
    private(set) var performOnMainThreadParams: [PerformOnMainThreadParams] = []
    struct PerformOnMainThreadParams {
        var taskType: DispatchQueueTaskType
        var task: () -> Void
    }
    
    // MARK: - Initialization
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
}

// MARK: - DispatchQueueManagerType
extension DispatchQueueManagerMock: DispatchQueueManagerType {
    func performOnMainThread(taskType: DispatchQueueTaskType, _ task: @escaping () -> Void) {
        self.performOnMainThreadParams.append(PerformOnMainThreadParams(taskType: taskType, task: task))
        
        switch self.taskType {
        case .performOnOriginalThread: DispatchQueue.performOnMainThread(taskType: .sync, task)
        case .performOnCurrentThread: task()
        }
    }
}
