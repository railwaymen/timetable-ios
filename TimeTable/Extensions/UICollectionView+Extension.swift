//
//  UICollectionView+Extension.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 20/02/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

extension UICollectionView {
    func register<T>(_ type: T.Type, bundle: Bundle? = nil) where T: ReusableCellType {
        self.register(
            UINib(nibName: type.nibName, bundle: bundle),
            forCellWithReuseIdentifier: type.reuseIdentifier)
    }
    
    func dequeueReusableCell<T>(_ type: T.Type, for indexPath: IndexPath) -> T? where T: ReusableCellType {
        return self.dequeueReusableCell(withReuseIdentifier: type.reuseIdentifier, for: indexPath) as? T
    }
}
