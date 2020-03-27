//
//  JSONFileResource.swift
//  TimeTableUITests
//
//  Created by Bartłomiej Świerad on 24/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol JSONFileResource: RawRepresentable where RawValue == String {}

extension JSONFileResource {
    var fileName: String {
        return self.rawValue
    }
}
