//
//  ApiClientTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 06/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ApiClientTests: XCTestCase {
    private var restler: RestlerMock!
    private var accessService: AccessServiceMock!

    override func setUp() {
        super.setUp()
        self.restler = RestlerMock()
        self.accessService = AccessServiceMock()
    }
}

// MARK: - Private
extension ApiClientTests {
    private func buildSUT() -> ApiClient {
        return ApiClient(
            restler: self.restler,
            accessService: self.accessService)
    }
}
