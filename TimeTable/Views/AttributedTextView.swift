//
//  AttributedTextView.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 03/12/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

class AttributerTextView: UITextView {
    @IBInspectable var cornerRadius: CGFloat = 3 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            self.layer.borderColor = self.borderColor?.cgColor
            self.layer.borderWidth = self.borderWidth
        }
    }
}
