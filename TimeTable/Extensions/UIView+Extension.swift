//
//  UIView+Extension.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 06/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

extension UIView {
    func loadNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        guard let nibName = type(of: self).description().components(separatedBy: ".").last else { return nil }
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func set(isHidden: Bool) {
        guard self.isHidden != isHidden else { return }
        self.isHidden = isHidden
    }
    
    func setTextFieldAppearance() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.textFieldBorder.cgColor
        self.layer.backgroundColor = UIColor.textFieldBackground.cgColor
        self.layer.cornerRadius = 5
        guard let textField = self as? AttributedTextField else { return }
        textField.padding = CGPoint(x: 5, y: 5)
    }
}
