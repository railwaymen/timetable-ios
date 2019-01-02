//
//  URL+Extension.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 16/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

extension URL {
    
    var isHTTP: Bool {
        return self.absoluteString.isHTTP
    }
    
    var isHTTPS: Bool {
        return self.absoluteString.isHTTPS
    }
}
