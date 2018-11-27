//
//  CalendarMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 27/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

// swiftlint:disable large_tuple
class CalendarMock: CalendarType {
    
    private(set) var dateComponentsData: (components: Set<Calendar.Component>?, date: Date?) = (nil, nil)
    var dateComponentsReturnValue: DateComponents!
    func dateComponents(_ components: Set<Calendar.Component>, from date: Date) -> DateComponents {
        dateComponentsData = (components, date)
        return dateComponentsReturnValue
    }
    
    private(set) var dateFromComponents: DateComponents?
    var dateFromComponentsValue: Date?
    func date(from components: DateComponents) -> Date? {
        dateFromComponents = components
        return dateFromComponentsValue
    }
    
    private(set) var fullDateByAddingData: (components: DateComponents?, date: Date?, wrappingComponents: Bool?) = (nil, nil, nil)
    var fullDateByAddingReturnValue: Date?
    func date(byAdding components: DateComponents, to date: Date, wrappingComponents: Bool) -> Date? {
        fullDateByAddingData = (components, date, wrappingComponents)
        return fullDateByAddingReturnValue
    }
    
    private(set) var shortDateByAddingData: (components: DateComponents?, date: Date?) = (nil, nil)
    var shortDateByAddingReturnValue: Date?
    func date(byAdding components: DateComponents, to date: Date) -> Date? {
        shortDateByAddingData = (components, date)
        return shortDateByAddingReturnValue
    }
    
    private(set) var fullDateByAddingDataWithValueData: (components: Calendar.Component?, value: Int?, date: Date?,
        wrappingComponents: Bool?) = (nil, nil, nil, nil)
    var fullDateByAddingWithValueReturnValue: Date?
    func date(byAdding component: Calendar.Component, value: Int, to date: Date, wrappingComponents: Bool) -> Date? {
        fullDateByAddingDataWithValueData = (component, value, date, wrappingComponents)
        return fullDateByAddingWithValueReturnValue
    }
    
    private(set) var shortDateByAddingDataWithValueData: (components: Calendar.Component?, value: Int?, date: Date?) = (nil, nil, nil)
    var shortDateByAddingWithValueReturnValue: Date?
    func date(byAdding component: Calendar.Component, value: Int, to date: Date) -> Date? {
        shortDateByAddingDataWithValueData = (component, value, date)
        return shortDateByAddingWithValueReturnValue
    }
}
// swiftlint:enable large_tuple
