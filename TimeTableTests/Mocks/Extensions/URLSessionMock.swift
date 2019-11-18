//
//  URLSessionMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class URLSessionMock {
    private(set) var dataTaskParams: [DataTaskParams] = []
    
    var dataTaskReturnValue: URLSessionDataTaskType!
    
    // MARK: - Structures
    struct DataTaskParams {
        var request: URLRequest
        var completionHandler: (Data?, URLResponse?, Error?) -> Void
    }
}

// MARK: - URLSessionType
extension URLSessionMock: URLSessionType {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskType {
        self.dataTaskParams.append(DataTaskParams(request: request, completionHandler: completionHandler))
        return self.dataTaskReturnValue
    }
}
