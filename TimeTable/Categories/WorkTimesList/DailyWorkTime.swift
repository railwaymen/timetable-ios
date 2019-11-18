//
//  DailyWorkTime.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 18/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

class DailyWorkTime {
    let day: Date
    var workTimes: [WorkTimeDecoder]
    
    // MARK: - Initialization
    init(day: Date, workTimes: [WorkTimeDecoder]) {
        self.day = day
        self.workTimes = workTimes
    }
    
    // MARK: - Internal
    func remove(workTime: WorkTimeDecoder) -> Bool {
        guard let index = self.workTimes.firstIndex(of: workTime) else { return false }
        self.workTimes.remove(at: index)
        return true
    }
}
