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
        UIFont(
            descriptor: self.fontDescriptor.withSymbolicTraits(.traitBold)!,
            size: self.pointSize)
    }
}
