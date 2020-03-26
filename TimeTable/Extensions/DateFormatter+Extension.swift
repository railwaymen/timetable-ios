//
//  DateFormatter+Extension.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 21/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol DateFormatterType: class {
    func string(from: Date) -> String
    func date(from: String) -> Date?
}

extension DateFormatter {
    // MARK: - Static
    static var shortDate: DateFormatterType {
        return DateFormatterBuilder()
            .dateStyle(.short)
            .build()
    }
    
    static var mediumDate: DateFormatterType {
        return DateFormatterBuilder()
            .dateStyle(.medium)
            .build()
    }
    
    static var shortTime: DateFormatterType {
        return DateFormatterBuilder()
            .timeStyle(.short)
            .build()
    }
    
    static var dateAndTimeExtended: DateFormatter {
        let formatter = DateFormatter(type: .dateAndTimeExtended)
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }
    
    static var simple: DateFormatter {
        let formatter = DateFormatter(type: .simple)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }
    
    // MARK: - Initialization
    private convenience init(type: DateType) {
        self.init() 
        self.dateFormat = type.rawValue
        self.locale = Locale.autoupdatingCurrent
    }
}

// MARK: - Structures
extension DateFormatter {
    private enum DateType: String {
        case simple = "yyyy-MM-dd"
        case dateAndTimeExtended = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    }
}

// MARK: - DateFormatterType
extension DateFormatter: DateFormatterType {}
