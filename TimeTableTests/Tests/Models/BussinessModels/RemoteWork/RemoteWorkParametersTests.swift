//
//  RemoteWorkParametersTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 06/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
import Restler
@testable import TimeTable

class RemoteWorkParametersTests: XCTestCase {
    private var queryEncoder: Restler.QueryEncoder {
        Restler.QueryEncoder(jsonEncoder: self.encoder)
    }
}

// MARK: - RestlerQueryEncodable
extension RemoteWorkParametersTests {
    func testEncoding_fullModel() throws {
        //Arrange
        let page = 1
        let perPage = 10
        let sut = RemoteWorkParameters(page: page, perPage: perPage)
        //Act
        let queryItems = try self.queryEncoder.encode(sut)
        //Assert
        XCTAssertEqual(queryItems.count, 2)
        XCTAssert(queryItems.contains(.init(name: "page", value: "\(page)")))
        XCTAssert(queryItems.contains(.init(name: "per_page", value: "\(perPage)")))
    }
}
