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
    func removing(workTime: WorkTimeDecoder) -> DailyWorkTime {
        let workTimes = self.workTimes.filter { $0 != workTime }
        return DailyWorkTime(
            day: self.day,
            workTimes: workTimes)
    }
}

// MARK: - Equatable
extension DailyWorkTime: Equatable {
    static func == (lhs: DailyWorkTime, rhs: DailyWorkTime) -> Bool {
        return lhs.day == rhs.day
    }
}
