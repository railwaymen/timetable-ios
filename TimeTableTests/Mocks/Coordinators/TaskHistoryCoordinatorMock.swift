//
//  TaskHistoryCoordinatorMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 18/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class TaskHistoryCoordinatorMock {
    
    // MARK: - TaskHistoryCoordinatorType
    private(set) var configureParams: [ConfigureParams] = []
    struct ConfigureParams {
        let cell: WorkTimeTableViewCellable
        let workTime: WorkTimeDisplayed
    }
    
    private(set) var dismissParams: [DismissParams] = []
    struct DismissParams {}
}

// MARK: - TaskHistoryCoordinatorType
extension TaskHistoryCoordinatorMock: TaskHistoryCoordinatorType {
    func configure(_ cell: WorkTimeTableViewCellable, with workTime: WorkTimeDisplayed) {
        self.configureParams.append(ConfigureParams(cell: cell, workTime: workTime))
    }
    
    func dismiss() {
        self.dismissParams.append(DismissParams())
    }
}
