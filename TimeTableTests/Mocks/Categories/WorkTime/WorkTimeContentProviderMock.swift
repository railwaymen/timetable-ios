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
        let completion: WorkTimeFetchDataCompletion
    }
    
    private(set) var saveTaskParams: [SaveTaskParams] = []
    struct SaveTaskParams {
        let taskForm: TaskFormType
        let completion: WorkTimeSaveTaskCompletion
    }
    
    private(set) var saveTaskWithFillingParams: [SaveTaskWithFillingParams] = []
    struct SaveTaskWithFillingParams {
        let taskForm: TaskFormType
        let completion: WorkTimeSaveTaskCompletion
    }
    
    var getPredefinedDayReturnValue: Date = Date()
    private(set) var getPredefinedDayParams: [GetPredefinedDayParams] = []
    struct GetPredefinedDayParams {
        let task: TaskFormType
    }
    
    var getPredefinedTimeBoundsReturnValue: (startDate: Date, endDate: Date) = (Date(), Date())
    private(set) var getPredefinedTimeBoundsParams: [GetPredefinedTimeBoundsParams] = []
    struct GetPredefinedTimeBoundsParams {
        let task: TaskFormType
        let lastTask: TaskFormType?
    }
    
    var getValidationErrorsReturnValue: [UIError] = []
    private(set) var getValidationErrorsParams: [GetValidationErrorsParams] = []
    struct GetValidationErrorsParams {}
}

// MARK: - WorkTimeContentProviderMock
extension WorkTimeContentProviderMock: WorkTimeContentProviderType {
    func fetchData(completion: @escaping WorkTimeFetchDataCompletion) {
        self.fetchSimpleProjectsListParams.append(FetchSimpleProjectsListParams(completion: completion))
    }
    
    func save(taskForm: TaskFormType, completion: @escaping WorkTimeSaveTaskCompletion) {
        self.saveTaskParams.append(SaveTaskParams(taskForm: taskForm, completion: completion))
    }
    
    func saveWithFilling(taskForm: TaskFormType, completion: @escaping WorkTimeSaveTaskCompletion) {
        self.saveTaskWithFillingParams.append(SaveTaskWithFillingParams(taskForm: taskForm, completion: completion))
    }
    
    func getPredefinedDay(forTaskForm task: TaskFormType) -> Date {
        self.getPredefinedDayParams.append(GetPredefinedDayParams(task: task))
        return self.getPredefinedDayReturnValue
    }
    
    func getPredefinedTimeBounds(forTaskForm task: TaskFormType, lastTask: TaskFormType?) -> (startDate: Date, endDate: Date) {
        self.getPredefinedTimeBoundsParams.append(GetPredefinedTimeBoundsParams(task: task, lastTask: lastTask))
        return self.getPredefinedTimeBoundsReturnValue
    }
    
    func getValidationErrors(forTaskForm form: TaskFormType) -> [UIError] {
        self.getValidationErrorsParams.append(GetValidationErrorsParams())
        return self.getValidationErrorsReturnValue
    }
}
