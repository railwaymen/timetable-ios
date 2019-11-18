//
//  DispatchGroupFactoryMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 30/10/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class DispatchGroupFactoryMock {
    
    var createDispatchGroupReturnValue: DispatchGroupType = DispatchGroupMock()
    private(set) var createDispatchGroupParams: [CreateDispatchGroupParams] = []
    struct CreateDispatchGroupParams {}
}

// MARK: - DispatchGroupFactoryType
extension DispatchGroupFactoryMock: DispatchGroupFactoryType {
    func createDispatchGroup() -> DispatchGroupType {
        self.createDispatchGroupParams.append(CreateDispatchGroupParams())
        return self.createDispatchGroupReturnValue
    }
}
