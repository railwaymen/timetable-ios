//
//  ProjectPickerCoordinatorMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 07/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ProjectPickerCoordinatorMock {
    private(set) var finishFlowParams: [FinishFlowParams] = []
    struct FinishFlowParams {
        var project: SimpleProjectRecordDecoder?
    }
}

// MARK: - ProjectPickerCoordinatorType
extension ProjectPickerCoordinatorMock: ProjectPickerCoordinatorType {
    func finishFlow(project: SimpleProjectRecordDecoder?) {
        self.finishFlowParams.append(FinishFlowParams(project: project))
    }
}
