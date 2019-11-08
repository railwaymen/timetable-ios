//
//  URLSession+Extension.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 31/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol URLSessionType: class {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskType
}

extension URLSession: URLSessionType {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskType {
        return (self.dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskType
    }
}
