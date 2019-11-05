//
//  WorkTimesListCoordinatorMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 15/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class WorkTimesListCoordinatorMock: WorkTimesListCoordinatorDelegate {
    private(set) var workTimesRequestedForNewWorkTimeViewCalled = false
    private(set) var workTimesRequestedForNewWorkTimeViewSourceView: UIView?
    private(set) var workTimesRequestedForNewWorkTimeViewLastTask: Task?
    private(set) var workTimesRequestedForNewWorkTimeViewFinishHandler: ((Bool) -> Void)?
    func workTimesRequestedForNewWorkTimeView(sourceView: UIView, lastTask: Task?, finishHandler: @escaping (Bool) -> Void) {
        workTimesRequestedForNewWorkTimeViewCalled = true
        workTimesRequestedForNewWorkTimeViewSourceView = sourceView
        workTimesRequestedForNewWorkTimeViewLastTask = lastTask
        workTimesRequestedForNewWorkTimeViewFinishHandler = finishHandler
    }
    
    // swiftlint:disable identifier_name large_tuple
    private(set) var workTimesRequestedForEditWorkTimeViewData: (sourceView: UIView, editedTask: Task, finishHandler: (Bool) -> Void)?
    // swiftlint:enable identifier_name large_tuple
    func workTimesRequestedForEditWorkTimeView(sourceView: UIView, editedTask: Task, finishHandler: @escaping (Bool) -> Void) {
        workTimesRequestedForEditWorkTimeViewData = (sourceView, editedTask, finishHandler)
    }
    // swiftlint:disable identifier_name large_tuple
    private(set) var workTimesRequestedForDuplicateWorkTimeViewData: (sourceView: UIView, duplicatedTask: Task, lastTask: Task?, finishHandler: (Bool) -> Void)?
    // swiftlint:enable identifier_name large_tuple
    func workTimesRequestedForDuplicateWorkTimeView(sourceView: UIView, duplicatedTask: Task, lastTask: Task?, finishHandler: @escaping (Bool) -> Void) {
        self.workTimesRequestedForDuplicateWorkTimeViewData = (sourceView, duplicatedTask, lastTask, finishHandler)
    }
    
    private(set) var workTimesRequestedForSafariURL: URL?
    func workTimesRequestedForSafari(url: URL) {
        workTimesRequestedForSafariURL = url
    }
}
