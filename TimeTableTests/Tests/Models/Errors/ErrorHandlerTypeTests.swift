//
//  ErrorHandlerTypeTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 29/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ErrorHandlerTypeTests: XCTestCase {

    func testThrowingErrorWithoutHandlingFinallyBlock() {
        //Arrange
        let error: TestError = TestError(message: "catching error")
        let sut = ErrorHandler { newError in
            //Assert
            if let testError = newError as? TestError {
               XCTAssertEqual(testError, error)
            }
        }
        //Act
        sut.throwing(error: error)
    }
}
