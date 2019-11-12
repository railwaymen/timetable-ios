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
            self.setImage(self.isActive ? UIImage(named: "check") : nil, for: .normal)
            self.backgroundColor = self.isActive ? .white : .clear
            self.tintColor = .crimson
        }
    }

    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
            self.layer.masksToBounds = self.cornerRadius > 0
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {            
            self.layer.borderColor = self.borderColor?.cgColor
            self.layer.borderWidth = self.borderWidth
        }
    }
}
