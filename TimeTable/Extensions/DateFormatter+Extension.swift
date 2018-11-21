//
//  DateFormatter+Extension.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 21/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

extension DateFormatter {

    enum DateType: String {
        case simple = "yyyy-MM-dd"
        case dateAndTimeExtended = "yyyy-MM-dd'T'HH:mm:ss.SSSXX"
    }
    
    // MARK: - Initialization
    convenience init(type: DateType) {
        self.init() 
        dateFormat = type.rawValue
        if #available(iOS 11.0, *) {
            self.locale = Locale.autoupdatingCurrent
        } else {
            switch type {
            case .dateAndTimeExtended:
                self.locale = Locale(identifier: "en_US_POSIX")
            default:
                self.locale = Locale.autoupdatingCurrent
            }
        }
    }
}
