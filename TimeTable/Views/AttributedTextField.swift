//
//  AttributedTextField.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 21/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

class AttributedTextField: UITextField {
    
    @IBInspectable var padding: CGPoint = .zero

    @IBInspectable var placeholderColor: UIColor = UIColor.gray {
        didSet {
            if let placeholder = self.placeholder {
                self.attributedPlaceholder = NSAttributedString(
                    string: placeholder,
                    attributes: [.foregroundColor: self.placeholderColor])
            } else {
                self.attributedPlaceholder = nil
            }
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: self.padding.x, dy: self.padding.y)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }

}
