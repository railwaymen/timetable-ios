//
//  TimerFormatter.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 30/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

class TimerFormatter {
    func formatToTimer(_ firstNumber: Int, _ secondNumber: Int) -> String {
        return "\(firstNumber):\(secondNumber.description(minimumDigitsCount: 2))"
    }
}
