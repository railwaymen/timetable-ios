//
//  URLSessionDataTaskMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class URLSessionDataTaskMock {
    private(set) var resumeParams: [ResumeParams] = []
    
    // MARK: - Structures
    struct ResumeParams {}
}

// MARK: - URLSessionDataTaskType
extension URLSessionDataTaskMock: URLSessionDataTaskType {
    func resume() {
        self.resumeParams.append(ResumeParams())
    }
}
