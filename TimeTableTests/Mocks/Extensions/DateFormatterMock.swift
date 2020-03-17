//
//  DateFormatterMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 18/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class DateFormatterMock {
    
    // MARK: - DateFormatterType
    var stringReturnValue: String = ""
    private(set) var stringParams: [StringParams] = []
    struct StringParams {
        let date: Date
    }
    
    var dateReturnValue: Date?
    private(set) var dateParams: [DateParams] = []
    struct DateParams {
        let string: String
    }
}

// MARK: - DateFormatterType
extension DateFormatterMock: DateFormatterType {
    func string(from date: Date) -> String {
        self.stringParams.append(StringParams(date: date))
        return self.stringReturnValue
    }
    
    func date(from string: String) -> Date? {
        self.dateParams.append(DateParams(string: string))
        return self.dateReturnValue
    }
}
