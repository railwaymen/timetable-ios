//
//  RestlerRequestMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 10/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation
import Restler

class RestlerRequestMock<T>: Restler.Request<T> {
    
    private(set) var onSuccessParams: [OnSuccessParams] = []
    struct OnSuccessParams {
        let handler: (T) -> Void
    }
    
    private(set) var onFailureParams: [OnFailureParams] = []
    struct OnFailureParams {
        let handler: (Error) -> Void
    }
    
    private(set) var onCompletionParams: [OnCompletionParams] = []
    struct OnCompletionParams {
        let handler: (Result<T, Error>) -> Void
    }
    
    var startReturnValue: RestlerTaskType?
    private(set) var startParams: [StartParams] = []
    struct StartParams {}
    
    // MARK: - Functions
    override func onSuccess(_ handler: @escaping (T) -> Void) -> Self {
        self.onSuccessParams.append(OnSuccessParams(handler: handler))
        return self
    }
    
    override func onFailure(_ handler: @escaping (Error) -> Void) -> Self {
        self.onFailureParams.append(OnFailureParams(handler: handler))
        return self
    }
    
    override func onCompletion(_ handler: @escaping (Result<T, Error>) -> Void) -> Self {
        self.onCompletionParams.append(OnCompletionParams(handler: handler))
        return self
    }
    
    override func start() -> RestlerTaskType? {
        self.startParams.append(StartParams())
        return self.startReturnValue
    }
}
