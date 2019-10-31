//
//  CheckBoxButton.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 29/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

@IBDesignable class CheckBoxButton: UIButton {
    
    @IBInspectable var isActive: Bool = false {
        didSet {
            setImage(isActive ? UIImage(named: "check") : nil, for: .normal)
            backgroundColor = isActive ? .white : .clear
            tintColor = .crimson
        }
    }

    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {            
            layer.borderColor = borderColor?.cgColor
            layer.borderWidth = borderWidth
        }
    }
}
