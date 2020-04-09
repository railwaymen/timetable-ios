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
        let hexRed = self.getHexValue(of: red)
        let hexGreen = self.getHexValue(of: green)
        let hexBlue = self.getHexValue(of: blue)
        return hexRed + hexGreen + hexBlue
    }
    
    // MARK: - Private
    private func getHexValue(of number: CGFloat) -> String {
        let string = String(Int(number * 255), radix: 16)
        guard string.count < 2 else { return string }
        return "0" + string
    }
}
