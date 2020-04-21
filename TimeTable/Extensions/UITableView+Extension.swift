//
//  UITableView+Extension.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 20/02/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

extension UITableView {
    func register<T>(_ type: T.Type, bundle: Bundle? = nil) where T: ReusableCellType {
        self.register(
            UINib(nibName: type.nibName, bundle: bundle),
            forCellReuseIdentifier: type.reuseID)
    }
    
    func dequeueReusableCell<T>(_ type: T.Type, for indexPath: IndexPath) -> T? where T: ReusableCellType {
        return self.dequeueReusableCell(withIdentifier: type.reuseID, for: indexPath) as? T
    }
}
