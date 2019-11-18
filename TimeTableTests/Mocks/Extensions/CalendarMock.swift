//
//  CalendarMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 27/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

// swiftlint:disable function_parameter_count
class CalendarMock {
    private(set) var dateComponentsParams: [DateComponentsParams] = []
    private(set) var dateFromDateComponentsParams: [DateFromDateComponentsParams] = []
    private(set) var dateBySettingHourParams: [DateBySettingHourParams] = []
    private(set) var dateBySettingCalendarComponentParams: [DateBySettingCalendarComponentParams] = []
    private(set) var dateByAddingDateComponentsParams: [DateByAddingDateComponentsParams] = []
    private(set) var dateByAddingCalendarComponentParams: [DateByAddingCalendarComponentParams] = []
    private(set) var isDateInTodayParams: [IsDateInTodayParams] = []
    private(set) var isDateInYesterdayParams: [IsDateInYesterdayParams] = []

    var dateComponentsReturnValue: DateComponents!
    var dateFromDateComponentsReturnValue: Date?
    var dateBySettingHourReturnValue: Date?
    var dateBySettingCalendarComponentReturnValue: Date?
    var dateByAddingDateComponentsReturnValue: Date?
    var dateByAddingCalendarComponentReturnValue: Date?
    var isDateInTodayReturnValue: Bool = false
    var isDateInYesterdayReturnValue: Bool = false
    
    // MARK: - Structures
    struct DateComponentsParams {
        var components: Set<Calendar.Component>
        var date: Date
    }
    
    struct DateFromDateComponentsParams {
        var components: DateComponents
    }
    
    struct DateBySettingHourParams {
        var hour: Int
        var minute: Int
        var second: Int
        var date: Date
        var matchingPolicy: Calendar.MatchingPolicy
        var repeatedTimePolicy: Calendar.RepeatedTimePolicy
        var direction: Calendar.SearchDirection
    }
    
    struct DateBySettingCalendarComponentParams {
        var component: Calendar.Component
        var value: Int
        var date: Date
    }
    
    struct DateByAddingDateComponentsParams {
        var components: DateComponents
        var date: Date
        var wrappingComponents: Bool
    }
    
    struct DateByAddingCalendarComponentParams {
        var component: Calendar.Component
        var value: Int
        var date: Date
        var wrappingComponents: Bool
    }
    
    struct IsDateInTodayParams {
        var date: Date
    }
    
    struct IsDateInYesterdayParams {
        var date: Date
    }
}

// MARK: - CalendarType
extension CalendarMock: CalendarType {
    func dateComponents(_ components: Set<Calendar.Component>, from date: Date) -> DateComponents {
        self.dateComponentsParams.append(DateComponentsParams(components: components, date: date))
        return self.dateComponentsReturnValue
    }
    
    func date(from components: DateComponents) -> Date? {
        self.dateFromDateComponentsParams.append(DateFromDateComponentsParams(components: components))
        return self.dateFromDateComponentsReturnValue
    }
    
    func date(bySettingHour hour: Int, minute: Int, second: Int, of date: Date,
              matchingPolicy: Calendar.MatchingPolicy, repeatedTimePolicy: Calendar.RepeatedTimePolicy, direction: Calendar.SearchDirection) -> Date? {
        self.dateBySettingHourParams.append(DateBySettingHourParams(hour: hour,
                                                                    minute: minute,
                                                                    second: second,
                                                                    date: date,
                                                                    matchingPolicy: matchingPolicy,
                                                                    repeatedTimePolicy: repeatedTimePolicy,
                                                                    direction: direction))
        return self.dateBySettingHourReturnValue
    }
    
    func date(bySetting component: Calendar.Component, value: Int, of date: Date) -> Date? {
        self.dateBySettingCalendarComponentParams.append(DateBySettingCalendarComponentParams(component: component, value: value, date: date))
        return self.dateBySettingCalendarComponentReturnValue
    }
    
    func date(byAdding components: DateComponents, to date: Date, wrappingComponents: Bool) -> Date? {
        self.dateByAddingDateComponentsParams.append(DateByAddingDateComponentsParams(components: components,
                                                                                      date: date,
                                                                                      wrappingComponents: wrappingComponents))
        return self.dateByAddingDateComponentsReturnValue
    }
    
    func date(byAdding component: Calendar.Component, value: Int, to date: Date, wrappingComponents: Bool) -> Date? {
        self.dateByAddingCalendarComponentParams.append(DateByAddingCalendarComponentParams(component: component,
                                                                                            value: value,
                                                                                            date: date,
                                                                                            wrappingComponents: wrappingComponents))
        return self.dateByAddingCalendarComponentReturnValue
    }
    
    func isDateInToday(_ date: Date) -> Bool {
        self.isDateInTodayParams.append(IsDateInTodayParams(date: date))
        return self.isDateInTodayReturnValue
    }
    
    func isDateInYesterday(_ date: Date) -> Bool {
        self.isDateInYesterdayParams.append(IsDateInYesterdayParams(date: date))
        return self.isDateInYesterdayReturnValue
    }
}
// swiftlint:enable function_parameter_count
