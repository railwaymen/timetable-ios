//
//  UIColor+Extension.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 21/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var crimson: UIColor {
        return UIColor(red: 203/255.0, green: 20/255.0, blue: 42/255.0, alpha: 1)
    }
    
    // MARK: - Initialization
    convenience init(string: String) {
        
        var uppercasedString = string.uppercased()
        uppercasedString.remove(at: string.startIndex)
        
        var rgbValue: UInt32 = 0
        Scanner(string: uppercasedString).scanHexInt32(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}
