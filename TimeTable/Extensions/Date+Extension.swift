//
//  Date+Extension.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 27/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

extension Date {
    func roundedToFiveMinutes() -> Date {
        let fiveMinutesInterval = 5 * TimeInterval.minute
        let timestamp = round(self.timeIntervalSince1970 / fiveMinutesInterval) * fiveMinutesInterval
        return Date(timeIntervalSince1970: timestamp)
    }
}
