//
//  UIViewController+Extension.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 20/02/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Returns `UIViewController` on top of this view controller
    ///
    /// Calling this function on the window's root view controller gives currently displaying view controller
    func topController() -> UIViewController {
        if let presentedViewController = self.presentedViewController {
            return presentedViewController.topController()
        } else if let selectedViewController = (self as? UITabBarController)?.selectedViewController {
            return selectedViewController.topController()
        } else if let visibleViewController = (self as? UINavigationController)?.visibleViewController {
            return visibleViewController.topController()
        }
        return self
    }
    
    func buildImageView(image: UIImage?, tapAction: Selector) -> UIImageView {
        let imageView = UIImageView(image: image)
        let tap = UITapGestureRecognizer(target: self, action: tapAction)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .tint
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        return imageView
    }
}
