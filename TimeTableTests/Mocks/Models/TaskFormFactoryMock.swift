//
//  TaskFormFactoryMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 31/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class TaskFormFactoryMock {
    
    // MARK: - TaskFormFactoryType
    var buildTaskFormReturnValue: TaskFormType = TaskFormMock()
    private(set) var buildTaskFormParams: [BuildTaskFormParams] = []
    struct BuildTaskFormParams {
        let duplicatedTask: TaskForm?
        let lastTask: TaskForm?
    }
}

// MARK: - TaskFormFactoryType
extension TaskFormFactoryMock: TaskFormFactoryType {
    func buildTaskForm(duplicatedTask: TaskForm?, lastTask: TaskForm?) -> TaskFormType {
        self.buildTaskFormParams.append(BuildTaskFormParams(duplicatedTask: duplicatedTask, lastTask: lastTask))
        return self.buildTaskFormReturnValue
    }
}
