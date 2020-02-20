//
//  DateFactory.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 19/02/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol DateFactoryType: class {
    var currentDate: Date { get }
}

class DateFactory: DateFactoryType {
    var currentDate: Date {
        Date()
    }
}
