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
        self.roundDate(with: 5 * .minute)
    }
    
    func roundedToQuarter() -> Date {
        self.roundDate(with: .quarter(of: .hour))
    }
}

// MARK: - Private
extension Date {
    private func roundDate(with inteval: TimeInterval) -> Date {
        let timestamp = round(self.timeIntervalSince1970 / inteval) * inteval
        return Date(timeIntervalSince1970: timestamp)
    }
}
