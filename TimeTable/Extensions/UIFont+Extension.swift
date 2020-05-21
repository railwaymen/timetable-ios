//
//  UIFont+Extension.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 21/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

extension UIFont {
    func bold() -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(.traitBold) else {
            assertionFailure()
            return self
        }
        return UIFont(
            descriptor: descriptor,
            size: self.pointSize)
    }
}
