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
        get {
            return self.titleLabel?.text
        }
        set {
            self.setTitle(newValue?.localized.localizedUppercase, for: UIControl.State())
        }
    }
    
    func setWithAnimation(isEnabled: Bool, duration: TimeInterval = 0.3) {
        guard self.isEnabled != isEnabled else { return }
        UIView.transition(
            with: self,
            duration: duration,
            options: [.transitionCrossDissolve, .beginFromCurrentState],
            animations: { [weak self] in
                self?.isEnabled = isEnabled
        })
    }
    
    func set(titleParameters: ButtonTitleParameters) {
        self.set(isHidden: titleParameters.title == nil)
        self.setTitle(titleParameters.title, for: .normal)
        self.setTitleColor(titleParameters.titleColor, for: .normal)
    }
}
