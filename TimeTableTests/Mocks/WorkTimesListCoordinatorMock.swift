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
    private(set) var workTimesRequestedForWorkTimeViewCalled = false
    private(set) var workTimesRequestedForWorkTimeViewSourceView: UIView?
    private(set) var workTimesRequestedForWorkTimeViewFlowType: WorkTimeViewModel.FlowType?
    private(set) var workTimesRequestedForWorkTimeViewFinishHandler: ((Bool) -> Void)?
    
    func workTimesRequestedForWorkTimeView(sourceView: UIView, flowType: WorkTimeViewModel.FlowType, finishHandler: @escaping (Bool) -> Void) {
        workTimesRequestedForWorkTimeViewCalled = true
        workTimesRequestedForWorkTimeViewSourceView = sourceView
        workTimesRequestedForWorkTimeViewFlowType = flowType
        workTimesRequestedForWorkTimeViewFinishHandler = finishHandler
    }

    private(set) var workTimesRequestedForSafariURL: URL?
    func workTimesRequestedForSafari(url: URL) {
        workTimesRequestedForSafariURL = url
    }
}
