//
//  NilableDiffElement.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 17/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

struct NilableDiffElement<Element: Decodable & Equatable> {
    // MARK: - Static
    private static func previousKey(baseKey: String) -> StringCodingKey {
        return StringCodingKey(stringLiteral: baseKey + "_was")
    }
    
    private static func currentKey(baseKey: String) -> StringCodingKey {
        return StringCodingKey(stringLiteral: baseKey)
    }
    
    // MARK: - Instance
    let previous: Element?
    let current: Element?
    
    var newest: Element? {
        return self.current ?? self.previous
    }
    
    var hasChanged: Bool {
        return self.current != nil
            && self.current != self.previous
    }
    
    // MARK: - Initialization
    init(from decoder: Decoder, baseKey: String) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.previous = try? container.decode(Element.self, forKey: Self.previousKey(baseKey: baseKey))
        self.current = try? container.decode(Element.self, forKey: Self.currentKey(baseKey: baseKey))
    }
    
    init(previous: Element, current: Element) {
        self.previous = previous
        self.current = current
    }
}

// MARK: - Date Extension
extension NilableDiffElement where Element == Date {
    var hasTimeChanged: Bool {
        guard let currentDate = self.current,
            let previousDate = self.previous else { return self.hasChanged }
        return self.hasChanged && !self.calendar.isDate(currentDate, inSameTimeAs: previousDate)
    }
    
    var hasDayChanged: Bool {
        guard let currentDate = self.current,
            let previousDate = self.previous else { return self.hasChanged }
        return self.hasChanged && !self.calendar.isDate(currentDate, inSameDayAs: previousDate)
    }
    
    private var calendar: CalendarType {
        Calendar.autoupdatingCurrent
    }
}

// MARK: - Private Structures
private struct StringCodingKey: CodingKey, ExpressibleByStringLiteral {
    var stringValue: String
    
    var intValue: Int? {
        return nil
    }
    
    // MARK: - Initialization
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    init?(intValue: Int) {
        return nil
    }
    
    init(stringLiteral value: String) {
        self.stringValue = value
    }
}
