//
//  Bundle+Extension.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 16/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol BundleType {
    var bundleIdentifier: String? { get }
}
extension Bundle: BundleType {}
