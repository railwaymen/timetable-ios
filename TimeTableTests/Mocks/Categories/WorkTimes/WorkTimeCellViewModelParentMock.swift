//
//  WorkTimeCellViewModelParentMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 12/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class WorkTimeCellViewModelParentMock {
    private(set) var openTaskParams: [OpenTaskParams] = []
    struct OpenTaskParams {
        var workTime: WorkTimeDecoder
    }
}

// MARK: - WorkTimeTableViewCellViewModelParentType
extension WorkTimeCellViewModelParentMock: WorkTimeTableViewCellModelParentType {
    func openTask(for workTime: WorkTimeDecoder) {
        self.openTaskParams.append(OpenTaskParams(workTime: workTime))
    }
}
