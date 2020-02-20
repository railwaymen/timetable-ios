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
    
    var getPredefinedDayReturnValue: Date = Date()
    private(set) var getPredefinedDayParams: [GetPredefinedDayParams] = []
    struct GetPredefinedDayParams {
        let task: Task
    }
    
    var getPredefinedTimeBoundsReturnValue: (startDate: Date, endDate: Date) = (Date(), Date())
    private(set) var getPredefinedTimeBoundsParams: [GetPredefinedTimeBoundsParams] = []
    struct GetPredefinedTimeBoundsParams {
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
    
    func getPredefinedDay(forTask task: Task) -> Date {
        self.getPredefinedDayParams.append(GetPredefinedDayParams(task: task))
        return self.getPredefinedDayReturnValue
    }
    
    func getPredefinedTimeBounds(forTask task: Task, lastTask: Task?) -> (startDate: Date, endDate: Date) {
        self.getPredefinedTimeBoundsParams.append(GetPredefinedTimeBoundsParams(task: task, lastTask: lastTask))
        return self.getPredefinedTimeBoundsReturnValue
    }
    
    func pickEndTime(ofLastTask lastTask: Task?) -> Date? {
        self.pickEndTimeParams.append(PickEndTimeParams(lastTask: lastTask))
        return self.pickEndTimeReturnValue
    }
}
