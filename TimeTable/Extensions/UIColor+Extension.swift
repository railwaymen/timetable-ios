//
//  UIColor+Extension.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 21/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let tint: UIColor = {
        let color = R.color.tint()
        assert(color != nil)
        return color ?? #colorLiteral(red: 0.7960784314, green: 0.07843137255, blue: 0.1647058824, alpha: 1)
    }()
    
    static let internalMeetingTag: UIColor = {
        let color = R.color.internalMeetingTag()
        assert(color != nil)
        return color ?? #colorLiteral(red: 1, green: 0.5254901961, blue: 0, alpha: 1)
    }()
    
    static let clientCommunicationTag: UIColor = {
        let color = R.color.clientCommunicationTag()
        assert(color != nil)
        return color ?? #colorLiteral(red: 0.4431372549, green: 0.1294117647, blue: 0.8549019608, alpha: 1)
    }()
    
    static let researchTag: UIColor = {
        let color = R.color.researchTag()
        assert(color != nil)
        return color ?? #colorLiteral(red: 0.04705882353, green: 0.8156862745, blue: 0.631372549, alpha: 1)
    }()
    
    static let accountingPeriods: UIColor = {
        let color = R.color.accountingPeriods()
        assert(color != nil)
        return color ?? #colorLiteral(red: 0.1764705882, green: 0.6117647059, blue: 0.8588235294, alpha: 1)
    }()
    
    static let enabledButton: UIColor = {
        let color = R.color.enabledButton()
        assert(color != nil)
        return color ?? #colorLiteral(red: 0.7960784314, green: 0.07843137255, blue: 0.1647058824, alpha: 1)
    }()
    
    static let disabledButton: UIColor = {
        return .systemGray
    }()
    
    static let diffChanged: UIColor = {
        let color = R.color.diffChanged()
        assert(color != nil)
        return color ?? #colorLiteral(red: 0.04705882353, green: 0.8156862745, blue: 0.631372549, alpha: 1)
    }()
    
    static let deleteAction: UIColor = {
        let color = R.color.deleteAction()
        assert(color != nil)
        return color ?? #colorLiteral(red: 0.7960784314, green: 0.07843137255, blue: 0.1647058824, alpha: 1)
    }()
    
    static let defaultBackground: UIColor = {
        return .systemBackground
    }()
    
    static let defaultLabel: UIColor = {
        return .label
    }()
    
    static let defaultSecondaryLabel: UIColor = {
        return .secondaryLabel
    }()
    
    static var textFieldBackground: UIColor {
        let color = R.color.textFieldBackground()
        assert(color != nil)
        return color ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    static var textFieldBorder: UIColor {
        let color = R.color.textFieldBorder()
        assert(color != nil)
        return color ?? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
    }
    
    static let textFieldValidationErrorBorder: UIColor = .tint
    
    // MARK: - Initialization
    convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString
            .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            .trimmingCharacters(in: ["#"])
        let scanner = Scanner(string: hexString)
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        guard hexString.count == 6 else { return nil }
        let mask = 0x000000FF
        let red = CGFloat(Int(color >> 16) & mask) / 255.0
        let green = CGFloat(Int(color >> 8) & mask) / 255.0
        let blue = CGFloat(Int(color) & mask) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    // MARK: - Internal
    func getImage() -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        return UIGraphicsImageRenderer(size: rect.size).image { context in
            self.setFill()
            context.fill(rect)
        }
    }
}
