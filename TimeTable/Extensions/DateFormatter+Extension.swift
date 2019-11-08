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
        self.dateFormat = type.rawValue
        self.locale = Locale.autoupdatingCurrent
    }
}
