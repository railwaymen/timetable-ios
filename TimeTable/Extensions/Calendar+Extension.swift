//
//  Calendar+Extension.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 27/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

// swiftlint:disable function_parameter_count
protocol CalendarType {
    func dateComponents(_ components: Set<Calendar.Component>, from date: Date) -> DateComponents
    func date(from components: DateComponents) -> Date?
    func date(
        bySettingHour hour: Int,
        minute: Int,
        second: Int,
        of date: Date,
        matchingPolicy: Calendar.MatchingPolicy,
        repeatedTimePolicy: Calendar.RepeatedTimePolicy,
        direction: Calendar.SearchDirection) -> Date?
    func date(bySetting component: Calendar.Component, value: Int, of date: Date) -> Date?
    func date(byAdding components: DateComponents, to date: Date, wrappingComponents: Bool) -> Date?
    func date(byAdding component: Calendar.Component, value: Int, to date: Date, wrappingComponents: Bool) -> Date?
    func isDateInToday(_ date: Date) -> Bool
    func isDateInYesterday(_ date: Date) -> Bool
}

extension CalendarType {
    func date(byAdding components: DateComponents, to date: Date) -> Date? {
        return self.date(byAdding: components, to: date, wrappingComponents: false)
    }
    
    func date(byAdding component: Calendar.Component, value: Int, to date: Date) -> Date? {
        return self.date(byAdding: component, value: value, to: date, wrappingComponents: false)
    }
    
    func date(bySettingHour hour: Int, minute: Int, second: Int, of date: Date) -> Date? {
        return self.date(
            bySettingHour: hour,
            minute: minute,
            second: second,
            of: date,
            matchingPolicy: Calendar.MatchingPolicy.nextTime,
            repeatedTimePolicy: .first,
            direction: .forward)
    }
}

extension Calendar: CalendarType {}
// swiftlint:enable function_parameter_count
