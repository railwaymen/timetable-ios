//
//  DispatchTimeInterval+Extension.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 01/06/2020.
//  Copyright © 2020 $(TT_ORGANIZATION_NAME). All rights reserved.
//

import Foundation

extension DispatchTimeInterval {
    init(_ seconds: TimeInterval) {
        let nanoseconds = Int(seconds / .nano)
        self = .nanoseconds(nanoseconds)
    }
}
