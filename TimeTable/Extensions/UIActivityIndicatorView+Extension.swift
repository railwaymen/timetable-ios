//
//  UIActivityIndicatorView+Extension.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 18/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {
    func set(isAnimating: Bool, animated: Bool = false) {
        let closure = isAnimating
            ? self.startAnimating
            : self.stopAnimating
        
        if animated {
            UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve, animations: {
                closure()
            })
        } else {
            closure()
        }
    }
}
