//
//  NSRegularExpression+Extension.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 07/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

extension NSRegularExpression {
    
    func matches(in string: String) -> [NSTextCheckingResult] {
        return self.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))
    }
}
