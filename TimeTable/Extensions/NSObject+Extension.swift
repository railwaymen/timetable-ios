//
//  NSObject+Extension.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 27/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
