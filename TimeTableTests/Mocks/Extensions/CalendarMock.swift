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
    
    // MARK: - CalendarType
    var dateComponentsReturnValue: DateComponents?
    private(set) var dateComponentsParams: [DateComponentsParams] = []
    struct DateComponentsParams {
        var components: Set<Calendar.Component>
        var date: Date
    }
    
    var dateFromDateComponentsReturnValue: Date?
    private(set) var dateFromDateComponentsParams: [DateFromDateComponentsParams] = []
    struct DateFromDateComponentsParams {
        var components: DateComponents
    }
    
    var dateBySettingHourReturnValue: Date?
    private(set) var dateBySettingHourParams: [DateBySettingHourParams] = []
    struct DateBySettingHourParams {
        var hour: Int
        var minute: Int
        var second: Int
        var date: Date
        var matchingPolicy: Calendar.MatchingPolicy
        var repeatedTimePolicy: Calendar.RepeatedTimePolicy
        var direction: Calendar.SearchDirection
    }
    
    var dateBySettingCalendarComponentReturnValue: Date?
    private(set) var dateBySettingCalendarComponentParams: [DateBySettingCalendarComponentParams] = []
    struct DateBySettingCalendarComponentParams {
        var component: Calendar.Component
        var value: Int
        var date: Date
    }
    
    var dateByAddingDateComponentsReturnValue: Date?
    private(set) var dateByAddingDateComponentsParams: [DateByAddingDateComponentsParams] = []
    struct DateByAddingDateComponentsParams {
        var components: DateComponents
        var date: Date
        var wrappingComponents: Bool
    }
    
    var dateByAddingCalendarComponentReturnValue: Date?
    private(set) var dateByAddingCalendarComponentParams: [DateByAddingCalendarComponentParams] = []
    struct DateByAddingCalendarComponentParams {
        var component: Calendar.Component
        var value: Int
        var date: Date
        var wrappingComponents: Bool
    }
    
    var isDateInTodayReturnValue: Bool = false
    private(set) var isDateInTodayParams: [IsDateInTodayParams] = []
    struct IsDateInTodayParams {
        var date: Date
    }
    
    var isDateInYesterdayReturnValue: Bool = false
    private(set) var isDateInYesterdayParams: [IsDateInYesterdayParams] = []
    struct IsDateInYesterdayParams {
        var date: Date
    }
    
    var isDateInSameDayReturnValue: Bool = false
    private(set) var isDateInSameDayParams: [IsDateInSameDayParams] = []
    struct IsDateInSameDayParams {
        let date1: Date
        let date2: Date
    }
    
    var isDateInSameTimeAsReturnValue: Bool = false
    private(set) var isDateInSameTimeAsParams: [IsDateInSameTimeAsParams] = []
    struct IsDateInSameTimeAsParams {
        let date1: Date
        let date2: Date
    }
    
    var dateMatchesComponentsReturnValue: Bool = false
    private(set) var dateMatchesComponentsParams: [DateMatchesComponentsParams] = []
    struct DateMatchesComponentsParams {
        let date: Date
        let components: DateComponents
    }
}

// MARK: - CalendarType
extension CalendarMock: CalendarType {
    func dateComponents(_ components: Set<Calendar.Component>, from date: Date) -> DateComponents {
        self.dateComponentsParams.append(DateComponentsParams(components: components, date: date))
        return self.dateComponentsReturnValue ?? Calendar(identifier: .iso8601).dateComponents(components, from: date)
    }
    
    func date(from components: DateComponents) -> Date? {
        self.dateFromDateComponentsParams.append(DateFromDateComponentsParams(components: components))
        return self.dateFromDateComponentsReturnValue
    }
    
    func date(
        bySettingHour hour: Int,
        minute: Int,
        second: Int,
        of date: Date,
        matchingPolicy: Calendar.MatchingPolicy,
        repeatedTimePolicy: Calendar.RepeatedTimePolicy,
        direction: Calendar.SearchDirection
    ) -> Date? {
        self.dateBySettingHourParams.append(
            DateBySettingHourParams(
                hour: hour,
                minute: minute,
                second: second,
                date: date,
                matchingPolicy: matchingPolicy,
                repeatedTimePolicy: repeatedTimePolicy,
                direction: direction))
        return self.dateBySettingHourReturnValue
    }
    
    func date(bySetting component: Calendar.Component, value: Int, of date: Date) -> Date? {
        self.dateBySettingCalendarComponentParams.append(DateBySettingCalendarComponentParams(
            component: component,
            value: value,
            date: date))
        return self.dateBySettingCalendarComponentReturnValue
    }
    
    func date(byAdding components: DateComponents, to date: Date, wrappingComponents: Bool) -> Date? {
        self.dateByAddingDateComponentsParams.append(
            DateByAddingDateComponentsParams(
                components: components,
                date: date,
                wrappingComponents: wrappingComponents))
        return self.dateByAddingDateComponentsReturnValue
    }
    
    func date(byAdding component: Calendar.Component, value: Int, to date: Date, wrappingComponents: Bool) -> Date? {
        self.dateByAddingCalendarComponentParams.append(
            DateByAddingCalendarComponentParams(
                component: component,
                value: value,
                date: date,
                wrappingComponents: wrappingComponents))
        return self.dateByAddingCalendarComponentReturnValue
    }
    
    func isDateInToday(_ date: Date) -> Bool {
        self.isDateInTodayParams.append(IsDateInTodayParams(date: date))
        return self.isDateInTodayReturnValue
    }
    
    func isDate(_ date1: Date, inSameDayAs date2: Date) -> Bool {
        self.isDateInSameDayParams.append(IsDateInSameDayParams(date1: date1, date2: date2))
        return self.isDateInSameDayReturnValue
    }
    
    func isDate(_ date1: Date, inSameTimeAs date2: Date) -> Bool {
        self.isDateInSameTimeAsParams.append(IsDateInSameTimeAsParams(date1: date1, date2: date2))
        return self.isDateInSameTimeAsReturnValue
    }
    
    func date(_ date: Date, matchesComponents components: DateComponents) -> Bool {
        self.dateMatchesComponentsParams.append(DateMatchesComponentsParams(date: date, components: components))
        return self.dateMatchesComponentsReturnValue
    }
}
