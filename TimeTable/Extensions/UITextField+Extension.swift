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
        get {
            return self.placeholder
        }
        set {
            self.placeholder = newValue?.localized
        }
    }
}
