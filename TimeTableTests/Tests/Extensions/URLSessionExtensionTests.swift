//
//  URLSessionExtensionTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 31/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class URLSessionExtensionTests: XCTestCase {}

// MARK: - dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskType
extension URLSessionExtensionTests {
    func testDataTask_createsProperDataTask() throws {
        //Arrange
        let url = URL(string: "www.example.com")!
        let request = URLRequest(url: url)
        let sut: URLSessionType = URLSession.shared
        //Act
        let dataTask = sut.dataTask(with: request) { (_, _, _) in }
        //Assert
        XCTAssertNotNil(dataTask as? URLSessionDataTask)
    }
}
