//
//  UrlSessionMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class UrlSessionMock: URLSessionType {
    var dataTask: URLSessionDataTaskMock!
    private(set) var request: URLRequest?
    private(set) var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskType {
        self.request = request
        self.completionHandler = completionHandler
        return self.dataTask
    }
}
