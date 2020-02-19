//
//  DateFactoryMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 19/02/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class DateFactoryMock {
    var currentDateReturnValue: Date?
}

// MARK: - DateFactoryType
extension DateFactoryMock: DateFactoryType {
    var currentDate: Date {
        return self.currentDateReturnValue ?? Date()
    }
}
