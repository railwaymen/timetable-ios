//
//  UIApplication+Extension.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 05/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

protocol UIApplicationType: class {
    func open(
        _ url: URL,
        options: [UIApplication.OpenExternalURLOptionsKey: Any],
        completionHandler completion: ((Bool) -> Void)?)
}

extension UIApplicationType {
    func open(
        _ url: URL,
        options: [UIApplication.OpenExternalURLOptionsKey: Any] = [:],
        completionHandler completion: ((Bool) -> Void)? = nil
    ) {
        self.open(url, options: options, completionHandler: completion)
    }
}

extension UIApplication: UIApplicationType {}
