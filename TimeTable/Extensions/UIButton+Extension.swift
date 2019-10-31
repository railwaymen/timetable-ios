//
//  UIControl+Extension.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 26/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

extension UIButton: UIElementLocalizedType {

    @IBInspectable var localizedStringKey: String? {
        set(newKey) {
            setTitle(newKey?.localized.localizedUppercase, for: UIControl.State())
        } get {
            return titleLabel?.text
        }
    }
}
