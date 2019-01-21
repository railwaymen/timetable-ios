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
            attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: [.foregroundColor: placeholderColor])
        }
    }

}
