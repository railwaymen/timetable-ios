//
//  WorkTimeCellViewModelParentMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 12/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class WorkTimeCellViewModelParentMock: WorkTimeCellViewModelParentType {
    
    private(set) var openTaskCalledCount = 0
    private(set) var openTaskWorkTime: WorkTimeDecoder?
    func openTask(for workTime: WorkTimeDecoder) {
        self.openTaskCalledCount += 1
        self.openTaskWorkTime = workTime
    }
}
