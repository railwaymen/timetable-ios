//
//  UIBarButtonItem+Extension.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 14/10/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    var view: UIView? {
        return self.value(forKey: "view") as? UIView
    }
}
