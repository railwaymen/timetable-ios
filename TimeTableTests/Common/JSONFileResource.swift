//
//  JSONFileResource.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 02/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
import Foundation

protocol JSONFileResource: RawRepresentable where RawValue == String {}

extension JSONFileResource {
    var fileName: String {
        return self.rawValue
    }
}
