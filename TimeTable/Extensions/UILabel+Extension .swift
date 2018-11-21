//
//  UILabel+Extension .swift
//  TimeTable
//
//  Created by Piotr Pawluś on 26/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

extension UILabel: UIElementLocalizedType {
    
    @IBInspectable var localizedStringKey: String? {
        set(newKey) {
            text = newKey?.localized
        } get {
            return text
        }
    }
}
