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
        let taskForm: TaskFormType
        let completion: SaveTaskCompletion
    }
    
    private(set) var saveTaskWithFillingParams: [SaveTaskWithFillingParams] = []
    struct SaveTaskWithFillingParams {
        let taskForm: TaskFormType
        let completion: SaveTaskCompletion
    }
    
    var getPredefinedDayReturnValue: Date = Date()
    private(set) var getPredefinedDayParams: [GetPredefinedDayParams] = []
    struct GetPredefinedDayParams {
        let task: TaskForm
    }
    
    var getPredefinedTimeBoundsReturnValue: (startDate: Date, endDate: Date) = (Date(), Date())
    private(set) var getPredefinedTimeBoundsParams: [GetPredefinedTimeBoundsParams] = []
    struct GetPredefinedTimeBoundsParams {
        let task: TaskFormType
        let lastTask: TaskFormType?
    }
    
    var pickEndTimeReturnValue: Date?
    private(set) var pickEndTimeParams: [PickEndTimeParams] = []
    struct PickEndTimeParams {
        let lastTask: TaskFormType?
    }
}

// MARK: - WorkTimeContentProviderMock
extension WorkTimeContentProviderMock: WorkTimeContentProviderType {
    func fetchSimpleProjectsList(completion: @escaping FetchSimpleProjectsListCompletion) {
        self.fetchSimpleProjectsListParams.append(FetchSimpleProjectsListParams(completion: completion))
    }
    
    func save(taskForm: TaskFormType, completion: @escaping SaveTaskCompletion) {
        self.saveTaskParams.append(SaveTaskParams(taskForm: taskForm, completion: completion))
    }
    
    func saveWithFilling(taskForm: TaskFormType, completion: @escaping SaveTaskCompletion) {
        self.saveTaskWithFillingParams.append(SaveTaskWithFillingParams(taskForm: taskForm, completion: completion))
    }
    
    func getPredefinedDay(forTaskForm task: TaskForm) -> Date {
        self.getPredefinedDayParams.append(GetPredefinedDayParams(task: task))
        return self.getPredefinedDayReturnValue
    }
    
    func getPredefinedTimeBounds(forTaskForm task: TaskFormType, lastTask: TaskFormType?) -> (startDate: Date, endDate: Date) {
        self.getPredefinedTimeBoundsParams.append(GetPredefinedTimeBoundsParams(task: task, lastTask: lastTask))
        return self.getPredefinedTimeBoundsReturnValue
    }
    
    func pickEndTime(ofLastTask lastTask: TaskFormType?) -> Date? {
        self.pickEndTimeParams.append(PickEndTimeParams(lastTask: lastTask))
        return self.pickEndTimeReturnValue
    }
}
