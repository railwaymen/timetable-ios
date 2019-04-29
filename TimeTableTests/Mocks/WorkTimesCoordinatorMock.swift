//
//  WorkTimesCoordinatorMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 15/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class WorkTimesCoordinatorMock: WorkTimesCoordinatorDelegate {
    private(set) var requestedForNewWorkTimeViewCalled = false
    private(set) var requestedForNewWorkTimeViewSourceView: UIButton?
    private(set) var requestedForNewWorkTimeViewLastTask: Task?
    func workTimesRequestedForNewWorkTimeView(sourceView: UIButton, lastTask: Task?) {
        requestedForNewWorkTimeViewCalled = true
        requestedForNewWorkTimeViewSourceView = sourceView
        requestedForNewWorkTimeViewLastTask = lastTask
    }
    
    // swiftlint:disable identifier_name
    private(set) var workTimesRequestedForEditWorkTimeViewData: (sourceView: UIView, editedTask: Task)?
    // swiftlint:enable identifier_name
    func workTimesRequestedForEditWorkTimeView(sourceView: UIView, editedTask: Task) {
        workTimesRequestedForEditWorkTimeViewData = (sourceView, editedTask)
    }
}
