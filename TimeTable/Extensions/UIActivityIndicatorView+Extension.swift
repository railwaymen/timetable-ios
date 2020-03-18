//
//  UIActivityIndicatorView+Extension.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 18/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {
    func set(isAnimating: Bool) {
        isAnimating
            ? self.startAnimating()
            : self.stopAnimating()
    }
}
