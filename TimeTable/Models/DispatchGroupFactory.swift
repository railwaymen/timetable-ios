//
//  DispatchGroupFactory.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 30/10/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

protocol DispatchGroupFactoryType: class {
    func createDispatchGroup() -> DispatchGroupType
}

class DispatchGroupFactory: DispatchGroupFactoryType {
    func createDispatchGroup() -> DispatchGroupType {
        return DispatchGroup()
    }
}
