//
//  ErrorHanlderTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 25/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ErrorHanlderTests: XCTestCase {
    
    func testThrowingErrorWhileActionHandlerIsDefault() {
        
        //Arrange
        let parentErrorHandler = ErrorHandler()
        let error: TestError = TestError(messsage: "catching error")
        
        //Act
        parentErrorHandler.throwing(error: error, finally: { isActionExecuted in
            //Assert
            XCTAssertFalse(isActionExecuted)
        })
    }
    
    func testThrwoingErrorWhileActionHandlerIsSetUp() {
        
        //Arrange
        let error: TestError = TestError(messsage: "catching error")
        let parentErrorHandler = ErrorHandler { error in
            if (error as? TestError) == nil {
                throw error
            }
        }
        //Act
        parentErrorHandler.throwing(error: error) { isActionExecuted in
            //Assert
            XCTAssertTrue(isActionExecuted)
        }
    }
    
    func testThrowingError() {
        
        //Arrange
        let parentErrorHandler = ErrorHandler()
        let error: TestError = TestError(messsage: "catching error")
        
        //Act
        var errorHandler: ErrorHandlerType {
            return parentErrorHandler.catchingError(action: { catchedError in
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

private struct TestError: Error {
    let messsage: String
}

extension TestError: Equatable {
    static func == (lhs: TestError, rhs: TestError) -> Bool {
        return lhs.messsage == rhs.messsage
    }
}
