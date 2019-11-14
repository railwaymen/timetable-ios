//
//  URLSessionDataTaskMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class URLSessionDataTaskMock: URLSessionDataTaskType {
    private(set) var resumeCalled = false
    func resume() {
        self.resumeCalled = true
    }
}
