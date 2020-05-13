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
        get {
            return self.text
        }
        set {
            self.text = newValue?.localized
        }
    }
    
    // MARK: - Internal
    func set(textParameters: LabelTextParameters) {
        self.set(isHidden: textParameters.text == nil)
        self.text = textParameters.text ?? ""
        self.textColor = textParameters.textColor ?? .clear
    }
}
