//
//  UIEdgeInsets+Extension.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 18/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
    var vertical: CGFloat {
        self.top + self.bottom
    }
}
