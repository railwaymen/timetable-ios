//
//  WorkTimeContentProviderMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 19/02/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class WorkTimeContentProviderMock {
    // MARK: - WorkTimeContentProviderMock
    private(set) var fetchSimpleProjectsListParams: [FetchSimpleProjectsListParams] = []
    struct FetchSimpleProjectsListParams {
        let completion: FetchSimpleProjectsListCompletion
    }
    
    private(set) var saveTaskParams: [SaveTaskParams] = []
    struct SaveTaskParams {
        let task: Task
        let completion: SaveTaskCompletion
    }
}

// MARK: - WorkTimeContentProviderMock
extension WorkTimeContentProviderMock: WorkTimeContentProviderType {
    func fetchSimpleProjectsList(completion: @escaping FetchSimpleProjectsListCompletion) {
        self.fetchSimpleProjectsListParams.append(FetchSimpleProjectsListParams(completion: completion))
    }
    
    func save(task: Task, completion: @escaping SaveTaskCompletion) {
        self.saveTaskParams.append(SaveTaskParams(task: task, completion: completion))
    }
}
