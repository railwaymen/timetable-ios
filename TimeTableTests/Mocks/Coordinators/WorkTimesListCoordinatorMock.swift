//
//  WorkTimesListCoordinatorMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 15/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class WorkTimesListCoordinatorMock {
    private(set) var workTimesRequestedForWorkTimeViewParams: [WorkTimesRequestedForWorkTimeViewParams] = []
    struct WorkTimesRequestedForWorkTimeViewParams {
        var sourceView: UIView
        var flowType: WorkTimeViewModel.FlowType
        var finishHandler: (Bool) -> Void
    }
    
    private(set) var workTimesRequestedForSafariParams: [WorkTimesRequestedForSafariParams] = []
    struct WorkTimesRequestedForSafariParams {
        var url: URL
    }
    
    private(set) var workTimesRequestedForTaskHistoryParams: [WorkTimesRequestedForTaskHistoryParams] = []
    struct WorkTimesRequestedForTaskHistoryParams {
        let taskForm: TaskForm
    }
    
    private(set) var workTimesRequestedForProfileViewParams: [WorkTimesRequestedForProfileViewParams] = []
    struct WorkTimesRequestedForProfileViewParams {}
    
    private(set) var workTimesRequestedForProjectPickerParams: [WorkTimesRequestedForProjectPickerParams] = []
    struct WorkTimesRequestedForProjectPickerParams {
        let projects: [SimpleProjectRecordDecoder]
        let completion: (SimpleProjectRecordDecoder?) -> Void
    }
}

// MARK: - WorkTimesListCoordinatorDelegate
extension WorkTimesListCoordinatorMock: WorkTimesListCoordinatorDelegate {
    func workTimesRequestedForWorkTimeView(
        sourceView: UIView,
        flowType: WorkTimeViewModel.FlowType,
        finishHandler: @escaping (Bool) -> Void
    ) {
        self.workTimesRequestedForWorkTimeViewParams.append(
            WorkTimesRequestedForWorkTimeViewParams(
                sourceView: sourceView,
                flowType: flowType,
                finishHandler: finishHandler))
    }
    
    func workTimesRequestedForSafari(url: URL) {
        self.workTimesRequestedForSafariParams.append(WorkTimesRequestedForSafariParams(url: url))
    }
    
    func workTimesRequestedForTaskHistory(taskForm: TaskForm) {
        self.workTimesRequestedForTaskHistoryParams.append(WorkTimesRequestedForTaskHistoryParams(taskForm: taskForm))
    }
    
    func workTimesRequestedForProfileView() {
        self.workTimesRequestedForProfileViewParams.append(WorkTimesRequestedForProfileViewParams())
    }
    
    func workTimesRequestedForProjectPicker(
        projects: [SimpleProjectRecordDecoder],
        completion: @escaping (SimpleProjectRecordDecoder?) -> Void
    ) {
        self.workTimesRequestedForProjectPickerParams.append(WorkTimesRequestedForProjectPickerParams(
            projects: projects,
            completion: completion))
    }
}
