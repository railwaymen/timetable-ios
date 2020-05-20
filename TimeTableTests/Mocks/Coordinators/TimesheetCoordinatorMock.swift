//
//  TimesheetCoordinatorMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 15/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class TimesheetCoordinatorMock {
    private(set) var timesheetRequestedForWorkTimeViewParams: [TimesheetRequestedForWorkTimeViewParams] = []
    struct TimesheetRequestedForWorkTimeViewParams {
        let sourceView: UIView
        let flowType: WorkTimeViewModel.FlowType
        let finishHandler: (Bool) -> Void
    }
    
    private(set) var timesheetRequestedForSafariParams: [TimesheetRequestedForSafariParams] = []
    struct TimesheetRequestedForSafariParams {
        let url: URL
    }
    
    private(set) var timesheetRequestedForTaskHistoryParams: [TimesheetRequestedForTaskHistoryParams] = []
    struct TimesheetRequestedForTaskHistoryParams {
        let taskForm: TaskForm
    }
    
    private(set) var timesheetRequestedForProfileViewParams: [TimesheetRequestedForProfileViewParams] = []
    struct TimesheetRequestedForProfileViewParams {}
    
    private(set) var timesheetRequestedForProjectPickerParams: [TimesheetRequestedForProjectPickerParams] = []
    struct TimesheetRequestedForProjectPickerParams {
        let projects: [SimpleProjectRecordDecoder]
        let completion: (SimpleProjectRecordDecoder?) -> Void
    }
}

// MARK: - TimesheetCoordinatorDelegate
extension TimesheetCoordinatorMock: TimesheetCoordinatorDelegate {
    func timesheetRequestedForWorkTimeView(
        sourceView: UIView,
        flowType: WorkTimeViewModel.FlowType,
        finishHandler: @escaping (Bool) -> Void
    ) {
        self.timesheetRequestedForWorkTimeViewParams.append(
            TimesheetRequestedForWorkTimeViewParams(
                sourceView: sourceView,
                flowType: flowType,
                finishHandler: finishHandler))
    }
    
    func timesheetRequestedForSafari(url: URL) {
        self.timesheetRequestedForSafariParams.append(TimesheetRequestedForSafariParams(url: url))
    }
    
    func timesheetRequestedForTaskHistory(taskForm: TaskForm) {
        self.timesheetRequestedForTaskHistoryParams.append(TimesheetRequestedForTaskHistoryParams(taskForm: taskForm))
    }
    
    func timesheetRequestedForProfileView() {
        self.timesheetRequestedForProfileViewParams.append(TimesheetRequestedForProfileViewParams())
    }
    
    func timesheetRequestedForProjectPicker(
        projects: [SimpleProjectRecordDecoder],
        completion: @escaping (SimpleProjectRecordDecoder?) -> Void
    ) {
        self.timesheetRequestedForProjectPickerParams.append(TimesheetRequestedForProjectPickerParams(
            projects: projects,
            completion: completion))
    }
}
