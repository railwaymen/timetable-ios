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
    
    var getDefaultDayReturnValue: Date = Date()
    private(set) var getDefaultDayParams: [GetDefaultDayParams] = []
    struct GetDefaultDayParams {
        let task: Task
    }
    
    var getDefaultTimeReturnValue: (startDate: Date, endDate: Date) = (Date(), Date())
    private(set) var getDefaultTimeParams: [GetDefaultTimeParams] = []
    struct GetDefaultTimeParams {
        let task: Task
        let lastTask: Task?
    }
    
    var pickEndTimeReturnValue: Date?
    private(set) var pickEndTimeParams: [PickEndTimeParams] = []
    struct PickEndTimeParams {
        let lastTask: Task?
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
    
    func getDefaultDay(forTask task: Task) -> Date {
        self.getDefaultDayParams.append(GetDefaultDayParams(task: task))
        return self.getDefaultDayReturnValue
    }
    
    func getDefaultTime(forTask task: Task, lastTask: Task?) -> (startDate: Date, endDate: Date) {
        self.getDefaultTimeParams.append(GetDefaultTimeParams(task: task, lastTask: lastTask))
        return self.getDefaultTimeReturnValue
    }
    
    func pickEndTime(ofLastTask lastTask: Task?) -> Date? {
        self.pickEndTimeParams.append(PickEndTimeParams(lastTask: lastTask))
        return self.pickEndTimeReturnValue
    }
}
