//
//  UIColor+Extension.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 23/01/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest

extension UIColor {
    func hexString() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: nil)
        let hexRed = String(Int(red * 255), radix: 16)
        let hexGreen = String(Int(green * 255), radix: 16)
        let hexBlue = String(Int(blue * 255), radix: 16)
        return hexRed + hexGreen + hexBlue
    }
}
