//
//  ErrorHandlerTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 25/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ErrorHandlerTests: XCTestCase {}

// MARK: - throwing(error: Error, finally: @escaping (Bool) -> Void)
extension ErrorHandlerTests {
    func testThrowingErrorWhileActionHandlerIsDefault() {
        //Arrange
        let sut = ErrorHandler()
        let error: TestError = TestError(message: "catching error")
        //Act
        sut.throwing(
            error: error,
            finally: { isActionExecuted in
                //Assert
                XCTAssertFalse(isActionExecuted)
            })
    }
    
    func testThrwoingErrorWhileActionHandlerIsSetUp() {
        //Arrange
        let error: TestError = TestError(message: "catching error")
        let sut = ErrorHandler { error in
            if (error as? TestError) == nil {
                throw error
            }
        }
        //Act
        sut.throwing(error: error) { isActionExecuted in
            //Assert
            XCTAssertTrue(isActionExecuted)
        }
    }
    
    func testThrowingError() {
        //Arrange
        let sut = ErrorHandler()
        let error: TestError = TestError(message: "catching error")
        //Act
        var errorHandler: ErrorHandlerType {
            return sut.catchingError(action: { catchedError in
                //Assert
                if let testError = catchedError as? TestError {
                    XCTAssertEqual(testError, error)
                } else {
                    XCTFail()
                }
            })
        }
        errorHandler.throwing(error: error, finally: { _ in })
    }
}
