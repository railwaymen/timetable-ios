//
//  DateFormatterBuilder.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 18/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol DateFormatterBuilderType: class {
    func dateFormat(_ format: String) -> Self
    func dateStyle(_ style: DateFormatter.Style) -> Self
    func timeStyle(_ style: DateFormatter.Style) -> Self
    func setRelativeDateFormatting(_ isRelative: Bool) -> Self
    func build() -> DateFormatterType
}

class DateFormatterBuilder {
    private var dateFormat: String?
    private var dateStyle: DateFormatter.Style = .none
    private var timeStyle: DateFormatter.Style = .none
    private var doesRelativeDateFormatting: Bool = false
}

// MARK: - DateFormatterBuilderType
extension DateFormatterBuilder: DateFormatterBuilderType {
    func dateFormat(_ format: String) -> Self {
        self.dateFormat = format
        return self
    }
    
    func dateStyle(_ style: DateFormatter.Style) -> Self {
        self.dateStyle = style
        return self
    }
    
    func timeStyle(_ style: DateFormatter.Style) -> Self {
        self.timeStyle = style
        return self
    }
    
    func setRelativeDateFormatting(_ isRelative: Bool) -> Self {
        self.doesRelativeDateFormatting = isRelative
        return self
    }
    
    func build() -> DateFormatterType {
        let formatter = DateFormatter()
        if let dateFormat = self.dateFormat {
            formatter.dateFormat = dateFormat
        } else {
            formatter.dateStyle = self.dateStyle
            formatter.timeStyle = self.timeStyle
            formatter.doesRelativeDateFormatting = self.doesRelativeDateFormatting
        }
        return formatter
    }
}
