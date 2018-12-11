//
//  Calendar+Extension.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 27/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol CalendarType {
    func dateComponents(_ components: Set<Calendar.Component>, from date: Date) -> DateComponents
    func date(from components: DateComponents) -> Date?
    func date(byAdding components: DateComponents, to date: Date, wrappingComponents: Bool) -> Date?
    func date(byAdding components: DateComponents, to date: Date) -> Date?
    func date(byAdding component: Calendar.Component, value: Int, to date: Date, wrappingComponents: Bool) -> Date?
    func date(byAdding component: Calendar.Component, value: Int, to date: Date) -> Date?
    func isDateInToday(_ date: Date) -> Bool
    func isDateInYesterday(_ date: Date) -> Bool
}

extension Calendar: CalendarType {
    func date(byAdding components: DateComponents, to date: Date) -> Date? {
        return self.date(byAdding: components, to: date, wrappingComponents: true)
    }
    
    func date(byAdding component: Calendar.Component, value: Int, to date: Date) -> Date? {
        return self.date(byAdding: component, value: value, to: date, wrappingComponents: true)
    }
}
