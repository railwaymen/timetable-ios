//
//  URLSessionExtensionTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 31/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class URLSessionExtensionTests: XCTestCase {
    
    func test() throws {
        let url = URL(string: "www.example.com")!
        let request = URLRequest(url: url)
        let urlSession: URLSessionType = URLSession.shared
        let dataTask = urlSession.dataTask(with: request) { (_, _, _) in }
        
        XCTAssertNotNil(dataTask as URLSessionDataTaskType)
    }
}
