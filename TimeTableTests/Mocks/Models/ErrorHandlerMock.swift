//
//  ErrorHandlerMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class ErrorHandlerMock {
    private(set) var throwingParams: [ThrowingParams] = []
    struct ThrowingParams {
        var error: Error
        var finally: (Bool) -> Void
    }
    
    private(set) var catchingErrorParams: [CatchingErrorParams] = []
    struct CatchingErrorParams {
        var action: HandleAction<Error>
    }
}

// MARK: - ErrorHandlerType
extension ErrorHandlerMock: ErrorHandlerType {
    func throwing(error: Error, finally: @escaping (Bool) -> Void) {
        self.throwingParams.append(ThrowingParams(error: error, finally: finally))
    }
    
    func catchingError(action: @escaping HandleAction<Error>) -> ErrorHandlerType {
        self.catchingErrorParams.append(CatchingErrorParams(action: action))
        return self
    }
}
