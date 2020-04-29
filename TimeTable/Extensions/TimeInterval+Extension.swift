//
//  TimeInterval+Extension.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 27/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

extension TimeInterval {
    static let day: TimeInterval = 86_400
    static let hour: TimeInterval = 3600
    static let minute: TimeInterval = 60
    
    var timerBigComponents: (hours: Int, minutes: Int) {
        let hours: Int = Int(self / .hour)
        let minutes: Int = Int((self - TimeInterval(hours) * .hour) / .minute)
        return (hours, minutes)
    }
}
