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
}