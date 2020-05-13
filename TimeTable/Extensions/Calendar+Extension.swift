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
    func isDate(_ date1: Date, inSameDayAs date2: Date) -> Bool
    func date(_ date: Date, matchesComponents components: DateComponents) -> Bool
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
    
    func date(bySettingYear year: Int, month: Int, of date: Date) -> Date? {
        var component = self.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        component.year = year
        component.month = month
        return self.date(from: component)
    }
    
    func isDate(_ date1: Date, inSameTimeAs date2: Date) -> Bool {
        let timeComponents = self.dateComponents([.hour, .minute, .second], from: date1)
        return self.date(date2, matchesComponents: timeComponents)
    }
}

extension Calendar: CalendarType {}
// swiftlint:enable function_parameter_count
