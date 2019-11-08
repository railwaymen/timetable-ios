//
//  UITextField+Extension.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 26/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

extension UITextField: UIElementLocalizedType {
    
    @IBInspectable var localizedStringKey: String? {
        set {
            self.placeholder = newValue?.localized
        }
        get {
            return self.placeholder
        }
    }
}
