//
//  DispatchGroupFactoryMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 30/10/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class DispatchGroupFactoryMock: DispatchGroupFactoryType {
    var expectedDispatchGroup: DispatchGroupType?
    func createDispatchGroup() -> DispatchGroupType {
        return self.expectedDispatchGroup ?? DispatchGroupMock()
    }
}
