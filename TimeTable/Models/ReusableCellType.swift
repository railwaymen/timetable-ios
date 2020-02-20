//
//  ReusableCellType.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 20/02/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol ReusableCellType: class {}

extension ReusableCellType {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
    
    static var nibName: String {
        return String(describing: Self.self)
    }
}
