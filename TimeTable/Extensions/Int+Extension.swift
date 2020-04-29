//
//  Int+Extension.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 28/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

extension Int {
    func description(minimumDigitsCount: Int) -> String {
        let missingDigitsCount = minimumDigitsCount - self.description.count
        let missingDigits = missingDigitsCount > 0 ? String(repeating: "0", count: missingDigitsCount) : ""
        return missingDigits + self.description
    }
}
