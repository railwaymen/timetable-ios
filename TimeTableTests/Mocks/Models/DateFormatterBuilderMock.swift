//
//  DateFormatterBuilderMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 18/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class DateFormatterBuilderMock {
    
    // MARK: - DateFormatterBuilderType
    private(set) var dateFormatParams: [DateFormatParams] = []
    struct DateFormatParams {
        let format: String
    }
    
    private(set) var dateStyleParams: [DateStyleParams] = []
    struct DateStyleParams {
        let style: DateFormatter.Style
    }
    
    private(set) var timeStyleParams: [TimeStyleParams] = []
    struct TimeStyleParams {
        let style: DateFormatter.Style
    }
    
    private(set) var setRelativeDateFormattingParams: [SetRelativeDateFormattingParams] = []
    struct SetRelativeDateFormattingParams {
        let isRelative: Bool
    }
    
    var buildReturnValue: DateFormatterMock = DateFormatterMock()
    private(set) var buildParams: [BuildParams] = []
    struct BuildParams {}
}

// MARK: - DateFormatterBuilderType
extension DateFormatterBuilderMock: DateFormatterBuilderType {
    func dateFormat(_ format: String) -> Self {
        self.dateFormatParams.append(DateFormatParams(format: format))
        return self
    }
    
    func dateStyle(_ style: DateFormatter.Style) -> Self {
        self.dateStyleParams.append(DateStyleParams(style: style))
        return self
    }
    
    func timeStyle(_ style: DateFormatter.Style) -> Self {
        self.timeStyleParams.append(TimeStyleParams(style: style))
        return self
    }
    
    func setRelativeDateFormatting(_ isRelative: Bool) -> Self {
        self.setRelativeDateFormattingParams.append(SetRelativeDateFormattingParams(isRelative: isRelative))
        return self
    }
    
    func build() -> DateFormatterType {
        self.buildParams.append(BuildParams())
        return self.buildReturnValue
    }
}
