//
//  ApiErrorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 31/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ApiErrorTests: XCTestCase {
    
    func testLocalizedDescriptionIfInvalidHostHasBeenGiven() throws {
        //Arrange
        let url = try URL(string: "www.example.com").unwrap()
        let error = ApiError.invalidHost(url)
        let expectedResult = String(format: "api.error.invalid_url".localized, url.absoluteString)
        //Act
        let localizedString = error.localizedDescription
        //Assert
        XCTAssertEqual(localizedString, expectedResult)
    }
    
    func testLocalizedDescriptionIfNilHostHasBeenGiven() {
        //Arrange
        let error = ApiError.invalidHost(nil)
        let expectedResult = String(format: "api.error.invalid_url".localized, "")
        //Act
        let localizedString = error.localizedDescription
        //Assert
        XCTAssertEqual(localizedString, expectedResult)
    }
}
