//
//  AttributedTextField.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 21/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

class AttributedTextField: UITextField {

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

}
