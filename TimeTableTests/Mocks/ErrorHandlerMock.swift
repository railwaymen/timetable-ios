//
//  ErrorHandlerMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class ErrorHandlerMock: ErrorHandlerType {
    private(set) var throwedError: Error?
    private(set) var throwingFinallyBlock: ((Bool) -> Void)?
    private(set) var catchingErrorActionBlock: ((Error) throws -> Void)?
    
    func throwing(error: Error, finally: @escaping (Bool) -> Void) {
        throwedError = error
        throwingFinallyBlock = finally
    }
    
    func catchingError(action: @escaping (Error) throws -> Void) -> ErrorHandlerType {
        catchingErrorActionBlock = action
        return self
    }
}
