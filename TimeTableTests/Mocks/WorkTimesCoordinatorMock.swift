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
    private(set) var requestedForNewWorkTimeViewSourceView: UIBarButtonItem?
    func workTimesRequestedForNewWorkTimeView(sourceView: UIBarButtonItem) {
        requestedForNewWorkTimeViewCalled = true
        requestedForNewWorkTimeViewSourceView = sourceView
    }
}
