//
//  UIColor+Extension.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 21/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let crimson: UIColor = { // CB142A
        let color = UIColor(named: "Crimson")
        assert(color != nil)
        return color ?? #colorLiteral(red: 0.7960784314, green: 0.07843137255, blue: 0.1647058824, alpha: 1)
    }()
    
    static let flushOrange: UIColor = { // E0B73F
        let color = UIColor(named: "Flush Orange")
        assert(color != nil)
        return color ?? #colorLiteral(red: 1, green: 0.5254901961, blue: 0, alpha: 1)
    }()
    
    static let purpleHeart: UIColor = { // A54294
        let color = UIColor(named: "Purple Heart")
        assert(color != nil)
        return color ?? #colorLiteral(red: 0.4431372549, green: 0.1294117647, blue: 0.8549019608, alpha: 1)
    }()
    
    static let caribbeanGreen: UIColor = { // 86D64A
        let color = UIColor(named: "Caribbean Green")
        assert(color != nil)
        return color ?? #colorLiteral(red: 0.04705882353, green: 0.8156862745, blue: 0.631372549, alpha: 1)
    }()
    
    static let defaultBackground: UIColor = {
        if #available(iOS 13, *) {
            return .systemBackground
        } else {
            return .white
        }
    }()
    
    static let defaultLabel: UIColor = {
        if #available(iOS 13, *) {
            return .label
        } else {
            return .black
        }
    }()
    
    // MARK: - Initialization
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let red   = CGFloat(Int(color >> 16) & mask) / 255.0
        let green = CGFloat(Int(color >> 8) & mask) / 255.0
        let blue  = CGFloat(Int(color) & mask) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
