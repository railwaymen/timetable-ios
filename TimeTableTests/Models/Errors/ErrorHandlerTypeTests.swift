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
        let error: TestError = TestError(messsage: "catching error")
        let parentErrorHandler = ErrorHandler { newError in
            //Assert
            if let testError = newError as? TestError {
               XCTAssertEqual(testError, error)
            }
        }
        //Act
        parentErrorHandler.throwing(error: error)
    }
}

private struct TestError: Error {
    let messsage: String
}

extension TestError: Equatable {
    static func == (lhs: TestError, rhs: TestError) -> Bool {
        return lhs.messsage == rhs.messsage
    }
}
